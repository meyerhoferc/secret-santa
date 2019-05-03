class ReactController < ApplicationController
  skip_before_action :root_path_if_not_logged_in, only: :index

  def index
  end
end
