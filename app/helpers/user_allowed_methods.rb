module UserAllowedMethods
  def current_date
    current_time = Time.now().strftime("T%m/%Y")
  end
end
