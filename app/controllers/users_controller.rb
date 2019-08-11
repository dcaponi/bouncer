class UsersController < ApplicationController
  before_action :set_user, only: [:show, :update, :destroy]

  # GET /users
  # GET /users.json
  def index
    # TODO this will be needed if/when the notion of organizations is introduced
  end

  # GET /users/1
  # GET /users/1.json
  def show
    user_id = JsonWebToken.decode(cookies[:login])["id"]
    @user = User.find(user_id)
    render json: {user: {id: @user.id, name_first: @user.name_first, name_last: @user.name_last, email: @user.email, created_at: @user.created_at}}, status: :created
  end

  # POST /users
  # POST /users.json
  def create
    redirect_url = params[:user].delete(:redirect_url) || '/'
    @user = User.find_by_email(user_params[:email]) || User.new(user_params)
    if @user.id.nil?
      if @user.save
        @user.set_email_confirm_token
        UserMailer.email_verification( @user, :redirect_url => redirect_url ).deliver_now

        @user.save(validate: false)
        render json: {user: {id: @user.id, name_first: @user.name_first, name_last: @user.name_last, email: @user.email, created_at: @user.created_at}}, status: :created
      else
        render json: @user.errors, status: :unprocessable_entity
      end
    elsif @user.id && @user.email_confirm_token
      UserMailer.email_verification( @user, :redirect_url => redirect_url ).deliver_now
      render json: {user: {id: @user.id, email: @user.email, created_at: @user.created_at}}, status: :ok
    else
      render json: @user.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /users/1
  # PATCH/PUT /users/1.json
  def update
    if @user
      if email_confirm_params[:email_confirm_token]
        @user.validate_email
        @user.save(validate: false)
        redirect_to email_confirm_params[:redirect_url] and return
      end
      if @user.update(user_params)
        render :show, status: :ok, location: @user
      else
        render json: @user.errors, status: :unprocessable_entity
      end
    else
      render json: {email_confirm_token: "Invalid Email Confirm Token Given"}, status: :bad_request
    end
  end

  # DELETE /users/1
  # DELETE /users/1.json
  # TODO get rid of this or lock down
  def destroy
    @user.destroy
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_user
      if email_confirm_params[:email_confirm_token]
        @user = User.find_by_email_confirm_token(email_confirm_params[:email_confirm_token])
      else
        @user = User.find(params[:id])
      end
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def email_confirm_params
      params.permit(:redirect_url, :email_confirm_token)
    end

    def user_params
      params.require(:user).permit(:email, :password, :password_confirmation)
    end
end
