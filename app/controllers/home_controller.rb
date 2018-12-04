class HomeController < ApplicationController
  before_action :forbid_login_user_home, only: [:top, :about]
  def top
  end
  def about
  end
  def forbid_login_user_home
    if @current_user
      redirect_to("/users/#{@current_user.id}")
    end
  end
end
