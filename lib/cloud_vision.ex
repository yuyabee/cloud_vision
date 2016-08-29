defmodule CloudVision do
  @features [label: "LABEL_DETECTION", logo: "LOGO_DETECTION", text: "TEXT_DETECTION",
   face: "FACE_DETECTION", landmark: "LANDMARK_DETECTION", safe_search: "SAFE_SEARCH_DETECTION",
   image_properties: "IMAGE_PROPERTIES", unspecified: "TYPE_UNSPECIFIED"
 ]

  def analyze(img_path, opts \\ []) do
    img =
      if Keyword.has_key?(opts, :from) && opts[:from] == :storage do
        image(img_path, :storage)
      else
        image(img_path, :local)
      end

    features =
      if Keyword.has_key?(opts, :features) && opts[:features] != [] do
        opts[:features]
        |> Enum.map(&(%{type: @features[&1]}))
      else
        [%{type: @features[:unspecified]}]
      end

    params = %{requests: [%{image: img, features: features}]}

    case CloudVision.Client.post("/images:annotate", params |> Poison.encode!) do
      {:ok, %HTTPoison.Response{status_code: x, body: body}} when x in 200..299 ->
        decoded = Poison.decode!(body)

        # handling error here because somehow the api returns status code 200 even an error occurs
        case decoded["responses"] |> Enum.find(fn (x) -> match? %{"error" => _}, x end) do
          %{"error" => %{"message" => msg}} -> {:error, msg}
          nil -> {:ok, decoded}
        end
      {:ok, %HTTPoison.Response{body: body}} -> {:error, Poison.decode!(body)}
      {:error, _} -> {:error, "Something went wrong"}
    end
  end

  defp image(img_path, :local), do: %{content: Base.encode64(File.read!(img_path))}
  defp image(img_path, :storage), do:
    %{source: %{
      gcsImageUri: "gs://" <> Application.get_env(:cloud_vision, :gcsUri) <> "/" <> img_path
    }}
end
