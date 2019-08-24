class UsersController < ApplicationController
  before_action :set_user, only: [:show, :update]

  def index
    # TODO this will be needed if/when the notion of organizations is introduced
  end

  def show
    if @user
      render json: {user: {id: @user.id, name_first: @user.name_first, name_last: @user.name_last, email: @user.email, created_at: @user.created_at, updated_at: @user.updated_at}}, status: :created
    else
      render json: {unauthorized: "Invalid or no credentials given"}, status: :unauthorized
    end
  end

  def create
    redirect_url = params[:user].delete(:redirect_url) || '/'
    @user = User.find_by_email(user_params[:email]) || User.new(user_params)
    if @user.id.nil?
      if @user.save
        @user.set_email_confirm_token
        UserMailer.email_verification( @user, :redirect_url => redirect_url ).deliver_now

        @user.save(validate: false)
        render json: {user: {id: @user.id, name_first: @user.name_first, name_last: @user.name_last, email: @user.email, created_at: @user.created_at, updated_at: @user.updated_at}}, status: :created
      else
        render json: @user.errors, status: :unprocessable_entity
      end
    elsif @user.id && @user.email_confirm_token
      UserMailer.email_verification( @user, :redirect_url => redirect_url ).deliver_now
      render json: {user: {id: @user.id, name_first: @user.name_first, name_last: @user.name_last, email: @user.email, created_at: @user.created_at, updated_at: @user.updated_at}}, status: :ok
    else
      if @user.errors.any?
        render json: @user.errors, status: :unprocessable_entity
      else
        render json: {error: "user already signed up"}, status: 401
      end
    end
  end

  def update
    if @user
      if email_confirm_params[:email_confirm_token]
        @user.validate_email
        @user.save(validate: false)
        Rails.logger.info("Redirecting to #{email_confirm_params[:redirect_url]}")
        token = JsonWebToken.encode({"id": @user.id})
        domain = ENV['COOKIE_DOMAIN']
        cookies[:login] = { :value => token, :expires => 1.hour.from_now, :httponly => true, :domain => domain }
        redirect_to email_confirm_params[:redirect_url] and return
      end
      if @user.update(user_params)
        render json: {user: {id: @user.id, name_first: @user.name_first, name_last: @user.name_last, email: @user.email, created_at: @user.created_at, updated_at: @user.updated_at}}, status: :ok
      else
        render json: @user.errors, status: :unprocessable_entity
      end
    else
      if email_confirm_params[:email_confirm_token]
        render json: {email_confirm_token: "Invalid Email Confirm Token Given"}, status: :bad_request
      else
        render json: {unauthorized: "Invalid or no credentials given"}, status: :unauthorized
      end
    end
  end

  private;

    def set_user
      if email_confirm_params[:email_confirm_token]
        @user = User.find_by_email_confirm_token(email_confirm_params[:email_confirm_token])
      else
        user_id = JsonWebToken.decode(cookies[:login])["id"]
        @user = User.find(user_id) unless user_id.nil?
      end
    end

    def email_confirm_params
      params.permit(:redirect_url, :email_confirm_token)
    end

    def user_params
      params.require(:user).permit(:email, :name_first, :name_last, :profile_pic_url, :password, :password_confirmation)
    end
end
