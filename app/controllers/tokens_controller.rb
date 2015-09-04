class TokensController < ApplicationController
  # skip_before_filter :authenticate_user_from_token
  skip_before_filter :user_authentication!
  respond_to :json
  def create
    email = params[:email] rescue nil
    password = params[:password] rescue nil
    if request.format != :json
      render :status=>406, :json=>{:message=>"The request must be json"}
      return
    end
    
    if email.nil? or password.nil?
       render :status=>400,
              :json=>{:message=>"The request must contain the user email and password."}
       return
    end
 
    @user=User.find_by_email(email.downcase)
 
    if @user.nil?
      logger.info("User #{email} failed signin, user cannot be found.")
      render :status=>401, :json=>{:message=>"Invalid email or passoword."}
      return
    end
 
    # # http://rdoc.info/github/plataformatec/devise/master/Devise/Models/TokenAuthenticatable
    # @user.ensure_authentication_token!
 
    if not @user.valid_password?(password)
      logger.info("User #{email} failed signin, password \"#{password}\" is invalid")
      render :status=>401, :json=>{:message=>"Invalid email or password."}
    else
      render :status=>200, :json=>{:token=>@user.authentication_token}
    end    
  end
 
  def reset_token
    @user=User.find_by_authentication_token(params[:auth_token])
    if @user.nil?
      logger.info("Token not found.")
      render :status=>404, :json=>{:message=>"Invalid token."}
    else
      @user.reset_authentication_token!
      render :status=>200, :json=>{:token=>params[:auth_token]}
    end
  end
end
