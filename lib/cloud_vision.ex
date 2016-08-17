defmodule CloudVision do
  def analyze(img_path) when is_bitstring(img_path) do
    analyze(img_path, :local)
  end

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
      {:ok, %HTTPoison.Response{body: res}} -> Poison.decode!(res)
      {:error, _} -> "Something went wrong"
    end
  end
end
