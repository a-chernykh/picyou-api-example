class OauthController < ApplicationController
  def request_token
    @request_token = consumer.get_request_token(:oauth_callback => callback_url)
    session[:request_token] = @request_token
    redirect_to @request_token.authorize_url
  end

  def callback
    @request_token = session[:request_token]
    @access_token = @request_token.get_access_token :oauth_verifier => params[:oauth_verifier]
    session[:access_token] = @access_token
    redirect_to root_url, :notice => 'Linked successfully'
  end
end
