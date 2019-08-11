class UsersController < ApplicationController
  before_action :set_user, only: [:show, :update]

  def index
    # TODO this will be needed if/when the notion of organizations is introduced
  end

  def show
    render json: {user: {id: @user.id, name_first: @user.name_first, name_last: @user.name_last, email: @user.email, created_at: @user.created_at}}, status: :created
  end

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

  private;

    def set_user
      if email_confirm_params[:email_confirm_token]
        @user = User.find_by_email_confirm_token(email_confirm_params[:email_confirm_token])
      else
        user_id = JsonWebToken.decode(cookies[:login])["id"]
        @user = User.find(user_id)
      end
    end

    def email_confirm_params
      params.permit(:redirect_url, :email_confirm_token)
    end

    def user_params
      params.require(:user).permit(:email, :password, :password_confirmation)
    end
end
