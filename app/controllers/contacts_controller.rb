class ContactsController < ApplicationController
  skip_before_action :verify_authenticity_token

  def create
    contact = Contact.new(contact_params)

    if contact.save
      NotifierMailer.contact_received(contact).deliver_later if Settings.email_notification_enabled?

      render json: { result: 'success' }, status: :created
    else
      render json: { errors: contact.errors.full_messages }, status: :bad_request
    end
  end

  private

  def contact_params
    params.permit(:form, :name, :email, :phone, :note, extra: {})
  end
end
