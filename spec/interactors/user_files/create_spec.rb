# frozen_string_literal: true

require 'rails_helper'

describe UserFiles::Create do
  describe '#call' do
    subject(:response) { described_class.call(params: params.with_indifferent_access) }

    let(:attached_jpg_file) { Rack::Test::UploadedFile.new('spec/fixtures/files/test.jpg') }
    let(:attached_svg_file) { Rack::Test::UploadedFile.new('spec/fixtures/files/test.svg') }
    let(:attached_video_file) { Rack::Test::UploadedFile.new('spec/fixtures/files/test.mp4') }
    let(:attached_audio_file) { Rack::Test::UploadedFile.new('spec/fixtures/files/test.mp3') }
    let(:attached_pdf_file) { Rack::Test::UploadedFile.new('spec/fixtures/files/test.pdf') }
    let(:attached_text_file) { Rack::Test::UploadedFile.new('spec/fixtures/files/test.txt') }
    let(:attached_font_file) { Rack::Test::UploadedFile.new('spec/fixtures/files/test.ttf') }
    let(:attached_another_file) { Rack::Test::UploadedFile.new('spec/fixtures/files/test.glb') }

    let(:user) { create(:user) }
    let(:folder) { create(:folder, user:) }

    let(:params) do
      {
        user_id: user.id,
        folder_id: folder.id
      }
    end

    context 'with jpg file' do
      before do
        blob = ActiveStorage::Blob.create_and_upload!(
          io: attached_jpg_file.tempfile,
          filename: attached_jpg_file.original_filename,
          content_type: 'image/jpg'
        )
        params[:file] = ActiveStorage::Blob.find_signed(blob.signed_id)
      end

      it 'has correct fields values' do
        expect(response.user_file.user_id).to eq user.id
        expect(response.user_file.folder_id).to eq folder.id
        expect(response.user_file.read_only).to be_falsey
        expect(response.user_file.visible).not_to be_falsey
        expect(response.user_file.file).not_to be_nil
        expect(response.user_file.file_type).to eq 'image'
        expect(response.user_file.file_name).to eq 'test'
        expect(response.user_file.file_extension).to eq 'jpg'
        expect(response.user_file.file_mime_type).to eq 'image/jpeg'
        expect(response.user_file.file_size).to eq attached_jpg_file.size
        expect(response.user_file.file).to be_attached
      end
    end

    context 'with svg file' do
      before do
        blob = ActiveStorage::Blob.create_and_upload!(
          io: attached_svg_file.tempfile,
          filename: attached_svg_file.original_filename,
          content_type: 'image/svg+xml'
        )
        params[:file] = ActiveStorage::Blob.find_signed(blob.signed_id)
      end

      it 'has correct fields values' do
        expect(response.user_file.user_id).to eq user.id
        expect(response.user_file.folder_id).to eq folder.id
        expect(response.user_file.read_only).to be_falsey
        expect(response.user_file.visible).not_to be_falsey
        expect(response.user_file.file).not_to be_nil
        expect(response.user_file.file_type).to eq 'image'
        expect(response.user_file.file_name).to eq 'test'
        expect(response.user_file.file_extension).to eq 'svg'
        expect(response.user_file.file_mime_type).to eq 'image/svg+xml'
        expect(response.user_file.file_size).to eq attached_svg_file.size
        expect(response.user_file.file).to be_attached
      end
    end

    context 'with video file' do
      before do
        blob = ActiveStorage::Blob.create_and_upload!(
          io: attached_video_file.tempfile,
          filename: attached_video_file.original_filename,
          content_type: 'video/mp4'
        )
        params[:file] = ActiveStorage::Blob.find_signed(blob.signed_id)
      end

      it 'has correct fields values' do
        expect(response.user_file.user_id).to eq user.id
        expect(response.user_file.folder_id).to eq folder.id
        expect(response.user_file.read_only).to be_falsey
        expect(response.user_file.visible).not_to be_falsey
        expect(response.user_file.file).not_to be_nil
        expect(response.user_file.file_type).to eq 'video'
        expect(response.user_file.file_name).to eq 'test'
        expect(response.user_file.file_extension).to eq 'mp4'
        expect(response.user_file.file_mime_type).to eq 'video/mp4'
        expect(response.user_file.file_size).to eq attached_video_file.size
        expect(response.user_file.file).to be_attached
      end
    end

    context 'with audio file' do
      before do
        blob = ActiveStorage::Blob.create_and_upload!(
          io: attached_audio_file.tempfile,
          filename: attached_audio_file.original_filename,
          content_type: 'audio/mpeg'
        )
        params[:file] = ActiveStorage::Blob.find_signed(blob.signed_id)
      end

      it 'has correct fields values' do
        expect(response.user_file.user_id).to eq user.id
        expect(response.user_file.folder_id).to eq folder.id
        expect(response.user_file.read_only).to be_falsey
        expect(response.user_file.visible).not_to be_falsey
        expect(response.user_file.file).not_to be_nil
        expect(response.user_file.file_type).to eq 'audio'
        expect(response.user_file.file_name).to eq 'test'
        expect(response.user_file.file_extension).to eq 'mp3'
        expect(response.user_file.file_mime_type).to eq 'audio/mpeg'
        expect(response.user_file.file_size).to eq attached_audio_file.size
        expect(response.user_file.file).to be_attached
      end
    end

    context 'with pdf file' do
      before do
        blob = ActiveStorage::Blob.create_and_upload!(
          io: attached_pdf_file.tempfile,
          filename: attached_pdf_file.original_filename,
          content_type: 'application/pdf'
        )
        params[:file] = ActiveStorage::Blob.find_signed(blob.signed_id)
      end

      it 'has correct fields values' do
        expect(response.user_file.user_id).to eq user.id
        expect(response.user_file.folder_id).to eq folder.id
        expect(response.user_file.read_only).to be_falsey
        expect(response.user_file.visible).not_to be_falsey
        expect(response.user_file.file).not_to be_nil
        expect(response.user_file.file_type).to eq 'application'
        expect(response.user_file.file_name).to eq 'test'
        expect(response.user_file.file_extension).to eq 'pdf'
        expect(response.user_file.file_mime_type).to eq 'application/pdf'
        expect(response.user_file.file_size).to eq attached_pdf_file.size
        expect(response.user_file.file).to be_attached
      end
    end

    context 'with text file' do
      before do
        blob = ActiveStorage::Blob.create_and_upload!(
          io: attached_text_file.tempfile,
          filename: attached_text_file.original_filename,
          content_type: 'text/plain'
        )
        params[:file] = ActiveStorage::Blob.find_signed(blob.signed_id)
      end

      it 'has correct fields values' do
        expect(response.user_file.user_id).to eq user.id
        expect(response.user_file.folder_id).to eq folder.id
        expect(response.user_file.read_only).to be_falsey
        expect(response.user_file.visible).not_to be_falsey
        expect(response.user_file.file).not_to be_nil
        expect(response.user_file.file_type).to eq 'text'
        expect(response.user_file.file_name).to eq 'test'
        expect(response.user_file.file_extension).to eq 'txt'
        expect(response.user_file.file_mime_type).to eq 'text/plain'
        expect(response.user_file.file_size).to eq attached_text_file.size
        expect(response.user_file.file).to be_attached
      end
    end

    context 'with font file' do
      before do
        blob = ActiveStorage::Blob.create_and_upload!(
          io: attached_font_file.tempfile,
          filename: attached_font_file.original_filename,
          content_type: 'font/ttf'
        )
        params[:file] = ActiveStorage::Blob.find_signed(blob.signed_id)
      end

      it 'has correct fields values' do
        expect(response.user_file.user_id).to eq user.id
        expect(response.user_file.folder_id).to eq folder.id
        expect(response.user_file.read_only).to be_falsey
        expect(response.user_file.visible).not_to be_falsey
        expect(response.user_file.file).not_to be_nil
        expect(response.user_file.file_type).to eq 'font'
        expect(response.user_file.file_name).to eq 'test'
        expect(response.user_file.file_extension).to eq 'ttf'
        expect(response.user_file.file_mime_type).to eq 'font/ttf'
        expect(response.user_file.file_size).to eq attached_font_file.size
        expect(response.user_file.file).to be_attached
      end
    end

    context 'with another mime file' do
      before do
        blob = ActiveStorage::Blob.create_and_upload!(
          io: attached_another_file.tempfile,
          filename: attached_another_file.original_filename,
          content_type: 'model/gltf-binary'
        )
        params[:file] = ActiveStorage::Blob.find_signed(blob.signed_id)
      end

      it 'has correct fields values' do
        expect(response.user_file.user_id).to eq user.id
        expect(response.user_file.folder_id).to eq folder.id
        expect(response.user_file.read_only).to be_falsey
        expect(response.user_file.visible).not_to be_falsey
        expect(response.user_file.file).not_to be_nil
        expect(response.user_file.file_type).to eq 'another'
        expect(response.user_file.file_name).to eq 'test'
        expect(response.user_file.file_extension).to eq 'glb'
        expect(response.user_file.file_mime_type).to eq 'model/gltf-binary'
        expect(response.user_file.file_size).to eq attached_another_file.size
        expect(response.user_file.file).to be_attached
      end
    end
  end
end
