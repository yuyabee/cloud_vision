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

  3. Configure credentials for [goth](https://github.com/peburrows/goth):

    ```elixir
    config :goth, json: "PATH_TO_YOUR_CREDENTIALS" |> File.read!
    ````

  4. (Optional) Configure your Google Cloud Storage Bucket URI if you want to retrieve file from it:
    ```elixir
    config :ex_cloud_vision, gcsUri: "YOUR_BUCKET_URI" # e.g. xxx.appspot.com
    ```

## Usage

Call `CloudVision.analyze/1` or `CloudVision.analyze/2` once everything is configured properly.

```elixir
# analyze a local file
CloudVision.analyze("/Users/yourname/Images/cat.jpg", from: :local, features: [:image_properties])
# or the shorthand version
CloudVision.analyze("/Users/yourname/Images/cat.jpg", features: [:image_properties])

# or analyze an image stored in Google Cloud Storage
# cat.jpg is a relative path from the storage's root
CloudVision.analyze("cat.jpg", from: :storage, features: [:image_properties])
```

### Available features (you can pass as many as you want(`features: [...]`)):
```elixir
[:label, :logo, :text, :face, :landmark, :safe_search, :image_properties]
# and the default
:unspecified
```
