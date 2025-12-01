class ExtraField < ApplicationRecord
  belongs_to :owner, polymorphic: true

  enum data_type: %i[string text image array boolean json color].to_h { |e| [e, e.to_s] }

  before_save :parse_json, if: Proc.new {|extra_field| extra_field.data_type == "json"}

  private

  def parse_json
    self.data = JSON.parse(self.data) if data.present? && data.is_a?(String)
  end
end
