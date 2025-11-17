module HasTag
  extend ActiveSupport::Concern

  included do
    has_many :tags, as: :owner, dependent: :destroy
    accepts_nested_attributes_for :tags, allow_destroy: true
  end

  def create_tags(tags_params)
    tags_params.each do |tag|
      create_tag(tag) if tag.present?
    end
  end

  def create_tag(name)
    Tag.create!(name: name, owner: self)
  end

  def tag_names
    @tag_names ||= tags.pluck(:name).uniq
  end

  def update_tags(params=[])
    params = params.reject {|name| name.blank?}
    unchange_names = tag_names & params
    del_tags(tag_names - unchange_names)
    create_tags(params - tag_names)
  end

  def reload_tags
    @tag_names = Tag.where(owner: self).pluck(:name).uniq
    @tag_id = Tag.where(owner: self).pluck(:id)
  end

  def del_tags(names)
    Tag.where(owner: self, name: names).delete_all
  end

  class_methods do
    def all_tag_names
      Tag.where(owner_type: self.name).pluck(:name).uniq
    end
  end
end
