class TokensController < ApplicationController

  def access_token
    @user = User.find_by_email(user_params['email'])
    if @user
      if @user.is_validated_user?
        if @user.authenticate(user_params['password'])
          token = JsonWebToken.encode({"id": @user.id})
          domain = ENV['COOKIE_DOMAIN']
          cookies[:login] = {
            :value => token,
            :expires => 1.hour.from_now,
            :httponly => true,
            :domain => domain
          }
          render json: { username: @user.email }, status: :ok
        else
          render json: {'unauthorized': 'incorrect login credentials'}, status: :unauthorized
        end
      else
        render json: {'unauthorized': 'verify email first'}, status: :unauthorized
      end
    else
      render json: {'unauthorized': 'user with given email does not exist'}, status: 401
    end
  end

  private

    def user_params
      params.require(:user).permit(:email, :password, :tkn)
    end
end
