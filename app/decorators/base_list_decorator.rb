class BaseListDecorator
  class << self
    attr_accessor :item_class

    def set_item_class(item_class)
      @item_class = item_class
    end
  end

  attr_reader :relation

  def initialize(relation)
    @relation = relation
  end

  def limit(number)
    wrap_list relation.limit(number)
  end

  def result
    relation
  end

  def each(&block)
    result.each do |item|
      yield wrap_item(item)
    end
  end

  def map(&block)
    result.map do |item|
      yield wrap_item(item)
    end
  end

  def to_a
    result.to_a.map do |item|
      wrap_item item
    end
  end

  def first
    wrap_item result.first
  end

  def last
    wrap_item result.last
  end

  def wrap_list(relation)
    self.class.new(relation)
  end

  def wrap_item(item)
    return nil if item.nil?

    self.class.item_class.new(item)
  end
end
