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

```
$ gem install blobby-gcs
```

## Development

You can run the tests within docker via `auto/test` or directly within your shell using `scripts/test`.

There are integration tests within this gem which point to a real **Google Cloud Storage** bucket, so you will need to provide credentials. If you have authenticated via [`gcloud`](https://cloud.google.com/sdk/gcloud/), you may already have credentials available when using `scripts/test`. If you are using Docker, then you will need to provide the credentials:

```bash
export GOOGLE_APPLICATION_CREDENTIALS=$HOME/.config/gcloud/application_default_credentials.json
export GOOGLE_CLOUD_PROJECT=...name of project...
export BLOBBY_GCS_TEST_BUCKET=...a bucket you have storage.objectAdmin access to...
```

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and publish the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/greensync/blobby-gcs.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
