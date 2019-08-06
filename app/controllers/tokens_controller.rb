class TokensController < ApplicationController

  def access_token
    @user = User.find_by_email(user_params['email'])
    if @user
      if @user.is_validated_user?
        if @user.authenticate(user_params['password'])
          token = JsonWebToken.encode({"id": @user.id})
          cookies[:login] = { :value => token, :expires => 1.hour.from_now, httponly: true}
          render json: {username: @user.email}, status: :ok
        else
          render json: {'unauthorized': 'incorrect login credentials'}, status: :unauthorized
        end
      else
        render json: {'unauthorized': 'verify email first'}, status: :unauthorized
      end
    else
      render json: {'unauthorized': 'user with given email does not exist'}, status: :unauthorized
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_user
      @user = User.find(params[:email])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def user_params
      params.require(:user).permit(:email, :password, :tkn)
    end
end
