require 'csv'

module Admin
  class ContactsController < ApplicationController
    before_action :get_contact, only: %i[edit update destroy]
    loggable_actions :create, :update, :destroy

    def index
      raise Unauthorized unless can?(:read, :contact)

      @records = ContactCmds::GetList.call(context: context, params: params).result
      respond_to do |format|
        format.html
        format.csv do
          extra_keys =  @records.pluck(:extra).compact.map{|data| data&.keys}.flatten.uniq
          attributes = [:name, :phone, :email, :form, :note, :created_at]
          data_csv = CSV.generate do |csv|
            csv << attributes + extra_keys 
            @records.limit(nil).each do |record|
              data_attributes = attributes.map{ |attr|  record.public_send(attr) }
              data_extra = extra_keys.map{ |attr| record.public_send(:extra)[attr] if record.extra}
              csv << data_attributes + data_extra
            end
            csv
          end
          send_data data_csv, filename: "contacts_#{Time.zone.now.strftime("%d-%m-%y")}.csv"
        end
      end
    end

    def edit
      raise Unauthorized unless can?(:read, @record)
    end

    def update
      raise Unauthorized unless can?(:update, @record)

      cmd = ContactCmds::Update.call(context: context, contact: @record, params: edit_params)

      if cmd.success?
        redirect_to edit_contact_url(cmd.result)
      else
        @record = cmd.result
        @errors = cmd.errors

        render :edit, status: 422
      end
    end

    def destroy
      raise Unauthorized unless can?(:delete, @record)

      cmd = ContactCmds::Destroy.call(context: context, contact: @record)
      redirect_to contacts_url
    end

    private

    def get_contact
      @record = Contact.find(params[:id])
    end

    def edit_params
      params.require(:contact).permit(:form, :name, :email, :phone, :note, extra: {})
    end
  end
end
