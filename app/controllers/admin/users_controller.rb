module Admin
  class UsersController < ApplicationController

    before_filter :restrict_admin_access

    def index
      @users = User.order(:firstname).paginate(:page => params[:page], :per_page => 10)
    end

    def new
      @user = User.new
    end

    def edit
      @user = User.find(params[:id])
    end

    def create
      @user = User.new(user_params)

      if @user.save
        UserMailer.welcome_email(@user).deliver
        redirect_to admin_users_path, notice: "#{@user.firstname} was saved successfully!"
      else
        render :new
      end
    end

    def update
      @user = User.find(params[:id])

      if @user.update_attributes(user_params)
        redirect_to admin_users_path
      else
        render :edit
      end
    end

      def destroy
        @user = User.find(params[:id])
        @user.destroy
        UserMailer.destroy_email(@user).deliver
        redirect_to admin_users_path
      end

    protected

    def user_params
      params.require(:user).permit(:email, :firstname, :lastname, :password, :password_confirmation, :admin)
    end

  end
end