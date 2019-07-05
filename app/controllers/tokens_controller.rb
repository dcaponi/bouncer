class TokensController < ApplicationController
  def access_token
    @user = User.find_by_email(user_params['email'])
    if @user.authenticate(user_params['password'])
      render json: {'access_token': 'asdfasdf'}
    else
      render json: {'unauthorized': 'incorrect login credentials'}, status: :unauthorized
    end
  end
  private
    # Use callbacks to share common setup or constraints between actions.
    def set_user
      @user = User.find(params[:email])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def user_params
      params.require(:user).permit(:email, :password)
    end
end
