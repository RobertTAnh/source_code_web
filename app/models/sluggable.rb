class Sluggable < String
  def to_slug
    self.gsub('đ', 'd').gsub('Đ', 'd')
    .unicode_normalize(:nfd).codepoints.reject(&128.method(:<)).pack('U*')
    .gsub(/[^\w\d]/, ' ')
    .strip
    .gsub(/\s+/, '-')
    .downcase
  end
end
