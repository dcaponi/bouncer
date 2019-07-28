class TokensController < ApplicationController

  def access_token
    @user = User.find_by_email(user_params['email'])

    if @user.authenticate(user_params['password'])
      token = JsonWebToken.encode({"id": @user.id})
      time = Time.now + 24.hours.to_i
      render json: {token: token, exp: time.strftime("%m-%d-%Y %H:%M"), username: @user.email}, status: :ok
    else
      render json: {'unauthorized': 'incorrect login credentials'}, status: :unauthorized
    end

  end

  def test
    binding.pry
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
