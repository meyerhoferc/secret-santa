class DashboardController < ApplicationController
  def show
    if current_user
      @user = current_user
    else
      redirect_to root_path
      flash[:warning] = 'You must be logged in first.'
    end
  end
end
