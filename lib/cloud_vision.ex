defmodule CloudVision do
  def analyze(img_path, :local) do
    %{content: Base.encode64(File.read!(img_path))}
    |> analyze
  end
  def analyze(img_path, :storage) do
    %{source: %{
      gcsImageUri: "gs://" <> Application.get_env(:cloud_vision, :gcsUri) <> "/" <> img_path
    }}
    |> analyze
  end

  def analyze(img_path) when is_bitstring(img_path) do
    analyze(img_path, :local)
  end
  def analyze(img) do
    params =
      %{requests: [%{
         image: img,
         features: [
           %{
             type: "LABEL_DETECTION"
           }, %{
             type: "LOGO_DETECTION"
           }, %{
             type: "TEXT_DETECTION"
           }
         ]}]}

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
end
