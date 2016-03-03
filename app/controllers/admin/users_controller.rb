module Admin
  class UsersController < ApplicationController

    before_filter :restrict_admin_access

    def index
      @users = User.order(:firstname).paginate(:page => params[:page], :per_page => 10)
    end

  end
end