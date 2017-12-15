require './config/environment'

require 'pry'
# require 'sinatra/base'
# require 'rack-flash'

require 'sinatra'
require 'sinatra/flash'

class ApplicationController < Sinatra::Base
  # use Rack::Flash  
  register Sinatra::Flash

  # set :views, Proc.new { File.join(root, "../views/") }

  configure do
    set :public_folder, 'public'
    set :views, "app/views"
    enable :sessions
    set :session_secret, "password_security_key"
  end

  get '/' do
    @user = User.find_by_id(session[:user_id])
    if logged_in?
      redirect to '/posts'
    else
      erb :index
    end
  end

  helpers do
    def logged_in?
      !!current_user
    end

    def current_user
      @current_user ||= User.find_by(id: session[:user_id]) if session[:user_id]
    end
  end

  def redirect_if_not_logged_in
    if !logged_in?
      redirect "/login"
    end
  end

  def username_exists?
    User.find_by(username: params[:username]) != nil
  end

  def email_exists?
    User.find_by(email: params[:email]) != nil
  end

end #of class
