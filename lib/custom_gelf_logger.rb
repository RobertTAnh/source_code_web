require 'gelf'

class CustomGelfLogger < GELF::Logger
  private
    def extract_hash(object = nil, args = {})
      hash = super(object, args)
      hash = add_log_tags hash
      hash
    end

    def add_log_tags hash
      (Rails.application.config.log_tags || []).each_with_index do |tg, index|
        hash[tg] = self.formatter.current_tags[index]
      end

      hash
    end
end

