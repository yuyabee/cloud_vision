defmodule CloudVision.Client do
  use HTTPoison.Base
  alias Goth.Token

  def process_url(url) do
    "https://vision.googleapis.com/v1" <> url
  end

  def process_request_headers([]) do
    {:ok, %Token{token: token}} = Token.for_scope("https://www.googleapis.com/auth/cloud-platform")

    [{"Authorization", "Bearer " <> token}]
  end
end
