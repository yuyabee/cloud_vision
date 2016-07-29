defmodule CloudVision do
  def analyze(img_path) do
    params = %{
      requests: [%{
        image: %{
          source: %{
            gcsImageUri: "gs://" <> Application.get_env(:cloud_vision, :gcsUri) <> "/" <> img_path
          }
        },
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
