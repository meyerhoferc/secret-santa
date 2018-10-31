class WelcomeController < ApplicationController
  skip_before_action :root_path_if_not_logged_in, only: :index

  def index
    if current_user
      redirect_to dashboard_path
    end
  end
end
