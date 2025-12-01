class ContactsController < ApplicationController
  skip_before_action :verify_authenticity_token
  before_action :detect_spam, only: [:create], if: -> { Settings.detect_spam? }

  include ::MediaCmds::Utils

  def create
    contact = Contact.new(contact_params)

    if contact.save
      if contact_params[:file]
        file_url = get_relative_direct_link contact.file.blob
        contact.update file_url: file_url
      end

      NotifierMailer.contact_received(contact).deliver_later if Settings.email_notification_enabled?

      render json: { result: 'success' }, status: :created
    else
      render json: { errors: contact.errors.full_messages }, status: :bad_request
    end
  end

  private

  def contact_params
    params.permit(:form, :name, :email, :phone, :note, :file, extra: {})
  end
end
