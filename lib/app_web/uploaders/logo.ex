defmodule App.Uploaders.Logo do
  use Waffle.Definition

  # Include ecto support (requires package waffle_ecto installed):
  use Waffle.Ecto.Definition

  # To add a thumbnail version:
  @versions [:original, :thumb, :thumb_webp]

  # Override the bucket on a per definition basis:
  # def bucket do
  #   :custom_bucket_name
  # end

  # Whitelist file extensions:
  def validate({file, _}) do
    ~w(.jpg .jpeg .png) |> Enum.member?(Path.extname(file.file_name))
  end

  # Define a thumbnail transformation:
  def transform(:thumb, _) do
    {:convert, "-thumbnail 256x -format png", :png}
  end

  def transform(:thumb_webp, {%{file_name: file_name}, _}) do
    if String.ends_with?(file_name, ".png") do
      {:cwebp, "-mt -lossless -resize 256 0 -quiet -o", :webp}
    else
      {:cwebp, "-m 6 -pass 10 -mt -q 90 -jpeg_like -resize 256 0 -quiet -o", :webp}
    end
  end

  # Override the persisted filenames:
  def filename(version, _) do
    version
  end

  # Override the storage directory:
  def storage_dir(_version, {_file, scope}) do
    "logos/#{scope.slug}"
  end

  # Provide a default URL if there hasn't been a file uploaded
  def default_url(:thumb_webp, _scope) do
    "/images/default_logo_thumb.webp"
  end

  def default_url(version, _scope) do
    "/images/default_logo_#{version}.png"
  end

  # Specify custom headers for s3 objects
  # Available options are [:cache_control, :content_disposition,
  #    :content_encoding, :content_length, :content_type,
  #    :expect, :expires, :storage_class, :website_redirect_location]
  #
  # def s3_object_headers(version, {file, scope}) do
  #   [content_type: MIME.from_path(file.file_name)]
  # end
end
