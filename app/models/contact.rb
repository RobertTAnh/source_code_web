class Contact < ApplicationRecord
  include SoftDelete

  has_one_attached :file

  validate :email_or_phone_present

  validates :email, format: { with: URI::MailTo::EMAIL_REGEXP, message: "không đúng định dạng" }, allow_blank: true

  validates :phone, format: { with: /\A\+?\d{6,12}\z/, message: "phải gồm 6 đến 12 chữ số" }, allow_blank: true


  private

  def email_or_phone_present
    if email.blank? && phone.blank?
      errors.add(:base, "Phải nhập ít nhất email hoặc số điện thoại")
    end
  end
end
