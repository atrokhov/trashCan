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
        user: user,
        folder: folder,
        read_only: false,
        visible: true
      }
    end

    context 'with jpg file' do
      before do
        params[:file] = {
          'filename' => 'test.jpg',
          'type' => 'image/jpg',
          'name' => 'file',
          'tempfile' => attached_jpg_file,
          'head' => "Content-Disposition: form-data; name=\"file\"; filename=\"test.jpg\"\r\nContent-Type: image/jpeg\r\n"
        }
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
        params[:file] = {
          'filename' => 'test.svg',
          'type' => 'image/jpg',
          'name' => 'file',
          'tempfile' => attached_svg_file,
          'head' => "Content-Disposition: form-data; name=\"file\"; filename=\"test.svg\"\r\nContent-Type: image/svg+xml\r\n"
        }
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
        params[:file] = {
          'filename' => 'test.mp4',
          'type' => 'video/mp4',
          'name' => 'file',
          'tempfile' => attached_video_file,
          'head' => "Content-Disposition: form-data; name=\"file\"; filename=\"test.mp4\"\r\nContent-Type: video/mp4\r\n"
        }
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
        params[:file] = {
          'filename' => 'test.mp3',
          'type' => 'audio/mpeg',
          'name' => 'file',
          'tempfile' => attached_audio_file,
          'head' => "Content-Disposition: form-data; name=\"file\"; filename=\"test.mp3\"\r\nContent-Type: audio/mpeg\r\n"
        }
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
        params[:file] = {
          'filename' => 'test.pdf',
          'type' => 'application/pdf',
          'name' => 'file',
          'tempfile' => attached_pdf_file,
          'head' => "Content-Disposition: form-data; name=\"file\"; filename=\"test.pdf\"\r\nContent-Type: application/pdf\r\n"
        }
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
        params[:file] = {
          'filename' => 'test.txt',
          'type' => 'text/plain',
          'name' => 'file',
          'tempfile' => attached_text_file,
          'head' => "Content-Disposition: form-data; name=\"file\"; filename=\"test.txt\"\r\nContent-Type: text/plain\r\n"
        }
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
        params[:file] = {
          'filename' => 'test.ttf',
          'type' => 'font/ttf',
          'name' => 'file',
          'tempfile' => attached_font_file,
          'head' => "Content-Disposition: form-data; name=\"file\"; filename=\"test.ttf\"\r\nContent-Type: font/ttf\r\n"
        }
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
        params[:file] = {
          'filename' => 'test.glb',
          'type' => 'model/gltf-binary',
          'name' => 'file',
          'tempfile' => attached_another_file,
          'head' => "Content-Disposition: form-data; name=\"file\"; filename=\"test.glb\"\r\nContent-Type: model/gltf-binary\r\n"
        }
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
