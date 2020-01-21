class Admin::UsersController < ApplicationController
  before_action :admin_user

  def index
    @users = User.all.order("created_at")
  end

  def new
    @user = User.new
  end

  def edit
    @user = User.find(params[:id])
  end

  def create
    @user = User.new(
      name: params[:name],
      password: params[:password],
      password_confirmation: params[:password_confirmation]
    )
    if @user.save
      redirect_to("/admin")
      flash[:notice] = "ユーザーを登録しました！"
    else
      @error_message = "*"
      @name = params[:name]
      render("/admin/users/new")
    end
  end

  def update
    @user = User.find_by(id: params[:id])
    @user.name = params[:name]
    @user.password = params[:password]
    @user.password_confirmation = params[:password_confirmation]
    if @user.save
      redirect_to("/admin")
      flash[:notice] = "ユーザー情報を更新しました"
    else
      @error_message = "*"
      @name = params[:name]
      render("admin/users/edit")
    end
  end
  private
  def admin_user
    redirect_to("/") unless @current_user.admin?
  end
end
