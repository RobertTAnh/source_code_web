module ApplicationHelper
  include UserAllowedMethods
  def view_render(*args)
    render *args
  end

  def full_asset_url(path)
    "#{ENV['ASSET_HOST'] || ENV['HOST']}#{path}"
  end

  def safe_eval_user_input(name)
    return name unless name.is_a?(String)
    name.gsub(/%[^%]+%/) do |m|
      method = m[1..-2].strip.to_sym
      if UserAllowedMethods.instance_methods.include?(method) 
        send(method)
      else
        " "
      end
    end
  end
end

