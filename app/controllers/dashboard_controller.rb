class DashboardController < ApplicationController
  def show
    if !current_user
      redirect_to root_path
      flash[:warning] = 'You must be logged in first.'
    end
  end
end
