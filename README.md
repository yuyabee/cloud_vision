# CloudVision

[Google Cloud Vision API](https://cloud.google.com/vision/) Client in Elixir.

## Installation

  1. Add `cloud_vision` to your list of dependencies in `mix.exs`:

    ```elixir
    def deps do
      [{:cloud_vision, "~> 0.1.0"}]
    end
    ```

  2. Ensure `cloud_vision` is started before your application:

    ```elixir
    def application do
      [applications: [:cloud_vision]]
    end
    ```

  3. Configure credentials for [goth](https://github.com/peburrows/goth) and your Google Cloud Storage Bucket URI:

    ```elixir
    config :goth, json: "PATH_TO_YOUR_CREDENTIALS" |> File.read!

    # cloud_vision config
    config :ex_cloud_vision, gcsUri: "YOUR_BUCKET_URI" # e.g. xxx.appspot.com
    ````

## Usage

Just call ```CloudVision.analyze/1``` once everything configured properly.

```elixir
# cat.jpg is a relative path to your bucket uri from its root. it must be uploaded beforehand
CloudVision.analyze("cat.jpg")
```
