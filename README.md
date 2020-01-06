# Blobby::GCSStore

This gem provides an GCS-based implementation of the "store" interface defined by the ["blobby"](https://github.com/realestate-com-au/blobby) gem.  It's been packaged separately, to avoid adding dependencies to the core gem.

The simplest use-case is writing to a single bucket:

    gcs_store = Blobby.store("gs://<bucket_name>/<file_path_inside_bucket>")
    gcs_store["key"].write("IO containing a file")

We recommend that you provide credentials using [environment variables](https://googleapis.dev/ruby/google-cloud-storage/latest/file.AUTHENTICATION.html)

```
    require 'blobby-gcs'

    ENV["GOOGLE_CLOUD_PROJECT"]     = "my-project-id"
    ENV["GOOGLE_APPLICATION_CREDENTIALS"] = "path/to/keyfile.json"

    gcs_store = Blobby.store("gs://<bucket_name>/<file_path_inside_bucket>")
```

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'blobby-gcs'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install blobby-gcs

## Development

You can run the tests within docker via `auto/test` or directly within your shell using `scripts/test`.

The tests within this gem are pointing to the real **Google Cloud Store** as integration tests so you will need to provide credentials, if you have authenticated via [gcloud](https://cloud.google.com/sdk/gcloud/) you may already have credentials available when using `scripts/test`. If you are using docker then you will need to provide the credentials:

```
export GOOGLE_APPLICATION_CREDENTIALS=$HOME/.config/gcloud/application_default_credentials.json

export GOOGLE_CLOUD_PROJECT=...name of project...
```

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/greensync/blobby-gcs.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
