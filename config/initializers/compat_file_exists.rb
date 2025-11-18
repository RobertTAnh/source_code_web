class File
  class << self
    alias_method :exists?, :exist?
  end
end

class Dir
  class << self
    alias_method :exists?, :exist?
  end
end