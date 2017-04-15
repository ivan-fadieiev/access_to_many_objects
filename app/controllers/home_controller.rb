class HomeController < ApplicationController

  def new_info
    @user_info = Service.new
  end

  def user_page
    @user_info = Service.find(params[:id])
  end

  def all_users
    @users = User.all
  end

  def create_info
    @user_info = Service.new(set_info_params)
    if @user_info.valid? && @user_info.save!
      redirect_to :root
    else
      render :new_info
    end
  end

  def edit_info
    @user_info = Service.new(set_info_params)
    if @user_info.valid? && @user_info.update!(set_info_params)
      redirect_to :root
    else
      render :user_page
    end
  end

  private
  def set_info_params
    params.require(:service).permit!
  end
end
