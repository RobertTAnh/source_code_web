module Loggable
  extend ActiveSupport::Concern

  included do
    def self.loggable_actions *actions
      around_action :add_log, only: actions
    end
  end

  def add_log
    begin
      log = ActionLog.init action_name, @record, params, current_user.id
      yield
      log.finish response, @record
    end
  end
end

