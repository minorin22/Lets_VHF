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

  def station
    @station = Station.new(
      user_id: params[:id],
      mmsi: 431000000 + params[:id].to_i,
      channel: 16,
      state: 1,
      power: 25
    )
    if @station.save(validate: false)
      redirect_to("/admin/stations/#{@station.id}/edit")
    else
      redirect_to("/admin")
    end
  end

  def destroy
    @user = User.find_by(id: params[:id])
    @station = Station.find_by(user_id: @user.id)
    @user.destroy
    @station.destroy
    redirect_to("/admin")
    flash[:notice] = "ユーザー情報を削除しました"
  end

  private
  def admin_user
    redirect_to("/") unless @current_user.admin?
  end
end
