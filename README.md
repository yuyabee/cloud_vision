[![Build Status](https://travis-ci.org/yuyabee/cloud_vision.svg?branch=master)](https://travis-ci.org/yuyabee/cloud_vision)
# CloudVision

[Google Cloud Vision API](https://cloud.google.com/vision/) Client in Elixir.

## Installation

  1. Add `cloud_vision` to your list of dependencies in `mix.exs`:

    ```elixir
    def deps do
      [{:cloud_vision, "~> 1.0.0"}]
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

Analyze a local file (label detection)
```elixir
iex> CloudVision.analyze("/Users/yourname/Images/cat.jpg", from: :local, features: [:label])
{:ok,¬
 %{"responses" => [%{"labelAnnotations" => [%{"description" => "cat",
         "mid" => "/m/01yrx", "score" => 0.97193068},
       %{"description" => "mammal", "mid" => "/m/04rky", "score" => 0.90458882},
       %{"description" => "kitten", "mid" => "/m/0hjzp", "score" => 0.87782878},
       %{"description" => "american shorthair", "mid" => "/m/02zfvv", "score" => 0.87157649},
       %{"description" => "vertebrate", "mid" => "/m/09686", "score" => 0.85715842}]}]}}
```

or the shorthand version (simple OCR):
```elixir
iex> CloudVision.analyze("/Users/yourname/Images/receipt.jpg", features: [:text])
{:ok,¬
 %{"responses" => [%{"textAnnotations" => [%{"boundingPoly" => %{"vertices" => [%{"x" => 7,
              "y" => 52}, %{"x" => 288, "y" => 52}, %{"x" => 288, "y" => 617},
            %{"x" => 7, "y" => 617}]},
         "description" => "Sunshine POS\nSold To: Samples\nSAMPLES 14107 August 07, 2001\nBedwetting (1 FL. 02.)\n$8.50\nC, VITAMIN CITR ¬
US Bioflav/500 $10.95\nALJ (2 FL OZ)\n$9.50\nHSN-W (KSP-STRUCTURAL, T-10) $11.25\nACIDOPHILUS-FLORA Force (90)\n$14.25\nOregon Grape (2¬
FL. Oz.)\n$11.95\nSUBTOTAL: $66.40\nSALES TAX\n$0.00\nTOTAL\n$66.40\nPAYMENTS\n$66.40\nBALANCE DUE\n$783.95\nYou Saved: $30.80\nTotal nu
mber of items: 6\nVolumes\nInvoice\nPN\nGV*\nNSP\nN/C\n225\n225\n*Paid Invoices for Current Month Only\nCash\n$66.40\nThank you for your
 order.\nPlease contact us with any\nquestions or problems you have.\nwww.sunshinesupport.com\n",
         "locale" => "en"},
       %{"boundingPoly" => %{"vertices" => [%{"x" => 64, "y" => 52},
            %{"x" => 172, "y" => 54}, %{"x" => 172, "y" => 70},
            %{"x" => 64, "y" => 68}]}, "description" => "Sunshine"},
       %{"boundingPoly" => %{"vertices" => [%{"x" => 184, "y" => 54},
            %{"x" => 225, "y" => 55}, %{"x" => 225, "y" => 71},
            %{"x" => 184, "y" => 70}]}, "description" => "POS"},
       %{"boundingPoly" => %{"vertices" => [%{"x" => 98, "y" => 69},
            %{"x" => 125, "y" => 69}, %{"x" => 125, "y" => 85},
            %{"x" => 98, "y" => 85}]}, "description" => "Sold"},
       %{"boundingPoly" => %{"vertices" => [%{"x" => 132, "y" => 70},
            %{"x" => 152, "y" => 70}, %{"x" => 152, "y" => 86},
            %{"x" => 132, "y" => 86}]}, "description" => "To:"},
       ... %{} ...
       %{"boundingPoly" => %{"vertices" => [%{"x" => 206, "y" => 87},
            %{"x" => 225, "y" => 87}, %{"x" => 225, "y" => 104},
            %{"x" => 206, "y" => 104}]}, "description" => "07,"},
       %{"boundingPoly" => %{"vertices" => [%{"x" => 233, "y" => 87},
            %{"x" => 260, "y" => 87}, %{"x" => 260, "y" => 104},
            %{"x" => 233, "y" => 104}]}, "description" => "2001"},
       %{"boundingPoly" => %{"vertices" => [%{"x" => 9, "y" => 118},
            %{"x" => 77, "y" => 119}, %{"x" => 77, "y" => 136},
            %{"x" => 9, "y" => 135}]}, "description" => "Bedwetting"},
       %{"boundingPoly" => %{"vertices" => [%{"x" => 252, "y" => 122},
            %{"x" => 287, "y" => 121}, %{"x" => 288, "y" => 137},
            %{"x" => 253, "y" => 138}]}, "description" => "$8.50"},
       %{"boundingPoly" => %{"vertices" => [%{"x" => 83, "y" => 135},
            %{"x" => 124, "y" => 136}, %{"x" => 124, "y" => 153},
            %{"x" => 83, "y" => 152}]}, "description" => "CITRUS"},
       ... %{} ...
       ]}]}}
```

or analyze an image stored in Google Cloud Storage
cat.jpg is a relative path from the storage's root (face detection)
```elixir
iex> CloudVision.analyze("happy_face.jpg", from: :storage, features: [:face])
{:ok,
 %{"responses" => [%{"faceAnnotations" => [%{"angerLikelihood" => "VERY_UNLIKELY",
         "blurredLikelihood" => "VERY_UNLIKELY",
         "boundingPoly" => %{"vertices" => [%{"x" => 93}, %{"x" => 455},
            %{"x" => 455, "y" => 332}, %{"x" => 93, "y" => 332}]},
         "detectionConfidence" => 0.99995375,
         "fdBoundingPoly" => %{"vertices" => [%{"x" => 123, "y" => 29},
            %{"x" => 415, "y" => 29}, %{"x" => 415, "y" => 320},
            %{"x" => 123, "y" => 320}]},
         "headwearLikelihood" => "VERY_UNLIKELY", "joyLikelihood" => "UNLIKELY",
         "landmarkingConfidence" => 0.76674944,
         "landmarks" => [%{"position" => %{"x" => 210.89491, "y" => 121.90675,
              "z" => 0.0025563254}, "type" => "LEFT_EYE"},
          %{"position" => %{"x" => 325.90634, "y" => 128.08356,
              "z" => -11.521945}, "type" => "RIGHT_EYE"},
          %{"position" => %{"x" => 181.93886, "y" => 92.46627,
              "z" => 17.332249}, "type" => "LEFT_OF_LEFT_EYEBROW"},
          %{"position" => %{"x" => 242.16783, "y" => 93.013054,
              "z" => -20.188667}, "type" => "RIGHT_OF_LEFT_EYEBROW"},
          %{"position" => %{"x" => 294.74652, "y" => 97.684624,
              "z" => -25.704315}, "type" => "LEFT_OF_RIGHT_EYEBROW"},
          %{"position" => %{"x" => 361.67432, "y" => 107.19203,
              "z" => -1.3647085}, "type" => "RIGHT_OF_RIGHT_EYEBROW"},
          %{"position" => %{"x" => 266.40848, "y" => 118.0172,
              "z" => -27.905827}, "type" => "MIDPOINT_BETWEEN_EYES"},
          ... %{} ...
          %{"position" => %{"x" => 252.03857, "y" => 304.84265,
              "z" => -38.217918}, "type" => "CHIN_GNATHION"},
          %{"position" => %{"x" => 155.81267, "y" => 250.15256,
              "z" => 77.565819}, "type" => "CHIN_LEFT_GONION"},
          %{"position" => %{"x" => 376.55591, "y" => 266.35092,
              "z" => 54.400257}, "type" => "CHIN_RIGHT_GONION"}],
         "panAngle" => -5.996583, "rollAngle" => 4.9760289,
         "sorrowLikelihood" => "VERY_UNLIKELY",
         "surpriseLikelihood" => "VERY_UNLIKELY", "tiltAngle" => 8.2322607,
         "underExposedLikelihood" => "VERY_UNLIKELY"}]}]}}
```

### Available features (you can pass as many as you want(`features: [...]`)):
```elixir
[:label, :logo, :text, :face, :landmark, :safe_search, :image_properties]
# and the default
:unspecified
```
