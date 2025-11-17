module Viewable
  extend ActiveSupport::Concern

  included do
    belongs_to :view, optional: true
  end
end
