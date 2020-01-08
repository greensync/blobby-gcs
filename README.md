# Blobby::GCSStore [![Build status](https://badge.buildkite.com/3a10d87beff89aab18d733ccd5fb3080e76020079c00ebdaab.svg)](https://buildkite.com/gs/blobby-gcs)

This gem provides a Google Cloud Storage (GCS) implementation of the "store" interface defined by the [`blobby`](https://github.com/realestate-com-au/blobby) gem. It's been packaged separately to avoid adding dependencies to the core gem.

The simplest use-case is writing to a single bucket:

```ruby
gcs_store = Blobby.store("gs://<bucket_name>/<directory_path_inside_bucket>")
gcs_store["key"].write("IO or string file content")
```

Configuration is provided using the [same environment variables](https://googleapis.dev/ruby/google-cloud-storage/latest/file.AUTHENTICATION.html) as the `google-cloud-storage` gem (which this one is wrapping).

```ruby
require 'blobby-gcs'

ENV["GOOGLE_CLOUD_PROJECT"] = "my-project-id"
ENV["GOOGLE_APPLICATION_CREDENTIALS"] = "path/to/keyfile.json"

gcs_store = Blobby.store("gs://<bucket_name>/<directory_path_inside_bucket>")
```

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'blobby-gcs'
```

And then execute:

```bash
$ bundle
```

Or install it yourself as:

```bash
$ gem install blobby-gcs
```

## Development

You can run the tests within Docker via `auto/test` or directly within your shell using `scripts/test`.

There are integration tests within this gem which point to a real **Google Cloud Storage** bucket, so credentials are required. If you do not already have `~/.config/gcloud/application_default_credentials.json` from authenticating with [`gcloud`](https://cloud.google.com/sdk/gcloud/), run:

```bash
$ gcloud auth application-default login
```

You will also need to provide the name of a GCS bucket you have `storage.objectAdmin` access to (and unfortunately, also `storage.legacyBucketReader`):

```bash
export GOOGLE_CLOUD_PROJECT=unused
export BLOBBY_GCS_TEST_BUCKET=...name of bucket...
```

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and publish the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/greensync/blobby-gcs.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
