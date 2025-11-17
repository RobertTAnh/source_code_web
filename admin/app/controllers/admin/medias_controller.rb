class Admin::MediasController < ActiveStorage::DirectUploadsController
  include ::MediaCmds::Utils
  include Admin::Localizable if Settings.localized?
  skip_before_action :verify_authenticity_token

  if Settings.localized?
    before_action :redirect_to_locale_record, only: %i[upload]
  end

  def upload
    if params[:record_type] == "Album"
      res = upload_multiple_images(blob_args)

      respond_to do |format|
        format.json { render json: res, status: :ok }
      end

      return
    end

    begin
      blob = ActiveStorage::Blob.create_and_upload! io: blob_args, filename: blob_args.original_filename
      if params[:record_type]
        record_type = params[:record_type]
        record_id = params[:record_id]

        record = record_type.constantize.find record_id
        if record
          if params[:for] == 'content'
            record.content_medias.attach(blob)
          elsif params[:for] == 'featured_images'
            record.featured_images.attach(blob)
          else
            record.general_medias.attach(blob)
          end
        end
      end

      res = {
        "uploaded": 1,
        "fileName": blob.filename,
        "key": blob.key,
        "url": get_absolute_direct_link(blob),
        "type": blob.attachments.first&.name
      }

      if blob.image?
        res[:mediaType] = "image"
      elsif blob.video?
        res[:mediaType] = "video"
      else
        res[:mediaType] = "file"
      end
    rescue
      res = {
        "uploaded": 0
      }
    end

    respond_to do |format|
      format.json { render json: res, status: :ok }
    end
  end

  def browse
    if params[:record_type]
      record_type = params[:record_type]
      record_id = params[:record_id]

      record = record_type.constantize.find record_id

      if record
        if params[:for] == 'content'
          file_scope = record.content_medias.blobs
          if params[:type] == 'image'
            blobs = file_scope.where(content_type: ActiveStorage.variable_content_types)
          else
            blobs = file_scope.where.not(content_type: ActiveStorage.variable_content_types)
          end
          @files = blobs.map{|file| {url: get_absolute_direct_link(file), filename: file.filename, key: file.key, created_at: file.created_at, blob: file}}
        elsif params[:for] == 'featured_images'
          @files = record.featured_images.map{|file| {url: get_absolute_direct_link(file), filename: file.filename, key: file.key, created_at: file.created_at, blob: file}}
        else
          @files = record.general_medias.map{|file| {url: get_absolute_direct_link(file), filename: file.filename, key: file.key, created_at: file.created_at, blob: file}}
        end
      end
    end
  end

  def destroy
    blob = ActiveStorage::Blob.find_by(key: params[:key] + '.' + params[:format])
    attachment = ActiveStorage::Attachment.find_by(blob_id: blob.id) if blob

    attachment.destroy!

    respond_to do |format|
      format.any
      format.json { render json: { "key":  params[:key] }, status: :ok }
    end
  end

  protected

  def upload_multiple_images(image_params)
    begin
      images = []
      image_params.each do |_, image|
        blob = ActiveStorage::Blob.create_and_upload! io: image, filename: image.original_filename
        images << blob
      end

      record_type = params[:record_type]
      record_id = params[:record_id]

      record = record_type.constantize.find record_id

      if record && params[:for] == 'album'
        record.files.attach(images)
      end

      res = {
        "uploaded": 1,
        "files": images.map{|image| {url: get_absolute_direct_link(image), filename: image.filename, key: image.key, created_at: image.created_at}}
      }
    rescue
      res = { "uploaded": 0 }
    end
  end

  private
  def blob_args
    params.require(:upload)
  end
end
