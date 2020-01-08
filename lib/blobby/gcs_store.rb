# frozen_string_literal: true

require 'blobby'
require 'blobby/key_transforming_store'
require 'google/cloud/storage'
require 'uri'

module Blobby
  # A BLOB store backed by Google Cloud Storage.
  #
  class GCSStore

    def self.from_uri(uri)
      uri = URI(uri)
      raise ArgumentError, "invalid GCS address: #{uri}" unless uri.scheme == 'gs'

      bucket_name = uri.host
      prefix = uri.path.sub(%r{\A/}, '').sub(%r{/\Z}, '')
      raise ArgumentError, 'no bucket specified' if bucket_name.nil?

      store = new(bucket_name)
      store = KeyTransformingStore.new(store) { |key| prefix + '/' + key } unless prefix.empty?
      store
    end

    def initialize(bucket_name, gcs_options: {})
      @bucket_name = bucket_name
      @gcs_options = gcs_options
    end

    def available?
      !!bucket&.exists?
    end

    def [](key)
      KeyConstraint.must_allow!(key)
      StoredObject.new(bucket, key)
    end

    class StoredObject

      def initialize(bucket, key)
        @bucket = bucket
        @key = key
      end

      # https://googleapis.dev/ruby/google-cloud-storage/latest/Google/Cloud/Storage/File.html#exists%3F-instance_method
      # bucket.file(key) returns nil, if the file does not exist!
      def exists?
        !!gcs_file&.exists?
      end

      # https://googleapis.dev/ruby/google-cloud-storage/latest/Google/Cloud/Storage/File.html#download-instance_method
      def read
        return nil unless exists?

        content = gcs_file.download.read
        if block_given?
          yield content
          nil
        else
          content
        end
      end

      # https://googleapis.dev/ruby/google-cloud-storage/latest/Google/Cloud/Storage/Bucket.html#create_file-instance_method
      def write(content)
        content = StringIO.new(content) unless content.respond_to?(:read)
        bucket.create_file(content, key)
        nil
      end

      # https://googleapis.dev/ruby/google-cloud-storage/latest/Google/Cloud/Storage/File.html#delete-instance_method
      def delete
        return false unless exists?

        gcs_file.delete
      end

      private

      attr_reader :bucket, :key

      def gcs_file
        bucket.file(key)
      end

    end

    private

    attr_reader :bucket_name, :gcs_options

    def bucket
      @bucket ||= gcs_client.bucket(bucket_name)
    end

    def gcs_client
      @gcs_client ||= Google::Cloud::Storage.new(gcs_options)
    end

  end

  register_store_factory 'gs', GCSStore
end
