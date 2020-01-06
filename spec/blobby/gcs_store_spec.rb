# frozen_string_literal: true

require 'blobby-gcs'

RSpec.describe Blobby::GCSStore do
  context 'when accessing a public bucket' do
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
          @gcs_file = @gcs_store['LT05/PRE/001/001/LT50010011985144KIS00/LT50010011985144KIS00_MTL.txt']
        end

        describe '#exists?' do
          it 'is true' do
            expect(@gcs_file).to be_exist
          end
        end

        describe '#read' do
          it 'downloads the content' do
            content = @gcs_file.read
            content.rewind if content.respond_to? :rewind
            expect(content.read).to include('GROUP = L1_METADATA_FILE')
          end
        end

        describe '#delete' do
          xit 'is not tested'
        end

        describe '#write' do
          xit 'is not tested'
        end
      end

      context 'with a key that does not exist in the bucket' do
        before(:all) do
          @gcs_file = @gcs_store['does/not/exist.txt']
        end

        describe '#exists?' do
          it 'is false' do
            expect(@gcs_file).not_to be_exist
          end
        end

        describe '#read' do
          it 'returns nil' do
            expect(@gcs_file.read).to be_nil
          end
        end
      end
    end
  end
end
