module Admin
  class DashboardController < ApplicationController
    def show
      @statistic = DashboardCmds::Get.call.result
      render "admin/homes/dashboard"
    end
  end
end
