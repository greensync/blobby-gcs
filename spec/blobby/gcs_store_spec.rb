# frozen_string_literal: true

require 'blobby-gcs'
require 'time'

# Load the abstract "Store" tests from "blobby".
# This depends on the gem being packaged with "spec" dir intact.
$LOAD_PATH << Gem.loaded_specs['blobby'].full_gem_path + '/spec'

require 'blobby/store_behaviour'

RSpec.describe Blobby::GCSStore, integration: true do
  EXISTING_BUCKET_NAME = ENV.fetch('BLOBBY_GCS_TEST_BUCKET', 'greensync-blobby-gcs-test')

  context 'shared examples from blobby gem' do
    before { gcs_store['KEY'].delete }

    subject(:gcs_store) { described_class.new(EXISTING_BUCKET_NAME) }

    it_behaves_like Blobby::Store
  end

  context 'when accessing a non-existent bucket' do
    before(:all) do
      @gcs_store = Blobby.store('gs://greensync-blobby-gcs-test-non-existent-bucket')
    end

    describe '#available?' do
      it 'is false' do
        expect(@gcs_store).not_to be_available
      end
    end
  end

  context 'when accessing a public bucket (read only)' do
    before(:all) do
      @gcs_store = Blobby.store('gs://gcp-public-data-landsat')
    end

    describe '#available?' do
      it 'is true' do
        expect(@gcs_store).to be_available
      end
    end

    describe '#[]' do
      context 'with a key that exists in the bucket' do
        before(:all) do
          @gcs_file =
            @gcs_store['LC08/01/044/034/LC08_L1GT_044034_20130330_20170310_01_T2/LC08_L1GT_044034_20130330_20170310_01_T2_MTL.txt']
        end

        describe '#exists?' do
          it 'is true' do
            # If this fails, Google may have removed the file from the bucket
            expect(@gcs_file.exists?).to be_truthy
          end
        end

        describe '#read' do
          it 'downloads the content' do
            content = @gcs_file.read
            expect(content).to include('GROUP = L1_METADATA_FILE')
          end
        end

        describe '#delete' do
          it 'raises a permission denied error' do
            expect { @gcs_file.delete }.to raise_error(Google::Cloud::PermissionDeniedError)
          end
        end

        describe '#write' do
          it 'raises a permission denied error' do
            content = "herp\nderp"
            expect { @gcs_file.write(content) }.to raise_error(Google::Cloud::PermissionDeniedError)
          end
        end
      end
    end
  end

  context 'when accessing a private bucket (read/write)' do
    before(:all) do
      @gcs_store = Blobby.store('gs://' + EXISTING_BUCKET_NAME)
    end

    describe '#available?' do
      it 'is true' do
        expect(@gcs_store).to be_available
      end
    end

    describe '#[]' do
      context 'overwriting an existing key' do
        let(:gcs_file) do
          @gcs_store['blobby-gcs-test/' + Time.now.getutc.iso8601.gsub(':', '-') + '.txt']
        end

        it 'updates the content' do
          content_original = 'come with me if you want to live'
          gcs_file.write(content_original)
          expect(gcs_file.read).to eq(content_original)

          content_updated = 'i want a divorce'
          gcs_file.write(content_updated)
          expect(gcs_file.read).to eq(content_updated)
        end
      end
    end
  end
end
