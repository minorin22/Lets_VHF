class UsersController < ApplicationController
  before_action :set_user, only: [:show, :edit, :update, :destroy]
  before_action :authenticate_user, only: [:edit, :update, :show, :destroy]
  before_action :ensure_correct_user, only: [:show, :edit, :update, :destroy]
  before_action :forbid_login_user, only: [:new, :create, :login, :login_form]

  # GET /users/1
  # GET /users/1.json
  def show
  end

  # GET /users/new
  def new
    @user = User.new
  end

  # GET /users/1/edit
  def edit
  end

  # POST /users
  # POST /users.json
  def create
    @user = User.new(
      name: params[:name],
      password: params[:password],
      password_confirmation: params[:password_confirmation]
    )
    if @user.save
      session[:user_id] = @user.id
      @user.remember
      cookies.permanent.signed[:user_id] = @user.id
      cookies.permanent[:remember_token] = @user.remember_token
      redirect_to("/users/#{@user.id}")
      flash[:notice] = "ユーザーを登録しました！"
    else
      @error_message = "*"
      @name = params[:name]
      render("users/new")
    end
  end

  # PATCH/PUT /users/1
  # PATCH/PUT /users/1.json
  def update
    @user = User.find_by(id: params[:id])
    @user.name = params[:name]
    @user.password = params[:password]
    @user.password_confirmation = params[:password_confirmation]
    if @user.save
      session[:user_id] = @user.id
      @user.remember
      cookies.permanent.signed[:user_id] = @user.id
      cookies.permanent[:remember_token] = @user.remember_token
      redirect_to("/users/#{@user.id}")
      flash[:notice] = "ユーザー情報を編集しました"
    else
      @error_message = "*"
      @name = params[:name]
      render("users/edit")
    end
  end

  # DELETE /users/1
  # DELETE /users/1.json
  def destroy
    @user.destroy
    respond_to do |format|
      format.html { redirect_to users_url, notice: 'User was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def login_form
  end

  def login
    @user = User.find_by(name: params[:name])
    if @user && @user.authenticate(params[:password])
      session[:user_id] = @user.id
      @user.remember
      cookies.permanent.signed[:user_id] = @user.id
      cookies.permanent[:remember_token] = @user.remember_token
      redirect_to("/users/#{@user.id}")
      flash[:notice] = "ログインしました"
    else
      @error_message = "ユーザーIDまたはパスワードが間違っています"
      @name = params[:name]
      render("users/login_form")
    end
  end

  def logout
    session[:user_id] = nil
    if @current_user
      @current_user.forget
    end
    cookies.permanent[:remember_token] = nil
    cookies.permanent.signed[:user_id] = nil
    #@current_user = nil
    redirect_to("/")
    flash[:notice] = "ログアウトしました"
  end

  def ensure_correct_user
    if @current_user.id != params[:id].to_i
      flash[:notice] = "権限がありません"
      redirect_to("/users/#{@current_user.id}")
    end
  end
  private
    # Use callbacks to share common setup or constraints between actions.
    def set_user
      @user = User.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
     def user_params
       params.require(:user).permit(:name, :password, :password_confirmation)
     end
end
