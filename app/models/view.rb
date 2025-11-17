class View < ApplicationRecord
  include Renderable

  belongs_to :theme
  belongs_to :layout, class_name: 'View', optional: true
end
