class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
#  protect_from_forgery with: :exception
  before_filter :user_authentication!

  private
  
  # For this example, we are simply using token authentication
  # via parameters. However, anyone could use Rails's token
  # authentication features to get the token from a header.
  def user_authentication!
      if params[:auth_token].present? or params[:token_authentication]== "true"
          #this is for api authentication and access
          authenticate_user_from_token!
      else
          #normal devise authentication
          authenticate_user!
      end
  end


  def authenticate_user_from_token!
    user_email = params[:user_email].presence
    user       = user_email && User.find_by_email(user_email)
 
    # Notice how we use Devise.secure_compare to compare the token
    # in the database with the token given in the params, mitigating
    # timing attacks.
    if user && Devise.secure_compare(user.authentication_token, params[:user_token])
      sign_in user, store: false
    end
  end


end
