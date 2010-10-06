#
require 'rubygems'
require 'sinatra'
require 'haml'
require 'rack-flash'
require 'pony'

$:.unshift( File.dirname( __FILE__ ) )
set :public, File.join( File.dirname( __FILE__ ), "../public" )

require 'models'
Models.startup

enable :sessions
use Rack::Flash

require 'session'

before do
  Session.instance = session
end


get %r{/hello(/([\w]*))?} do |_, user_hash|
  if user_hash && user_hash.size > 0
    user = User.first( :user_hash => user_hash )
    unless user
      flash[ :notice ] = "Wrong user hash"
      redirect "/hello"
    end
  end

  if user
    user.restore_session
    redirect "/success"
  else
    haml :enter_email
  end
end

post "/register" do
  # NOTE: email validation..
  user = User.detect( params[ :email ] )
  user.send_login_link
  us = UserSession.detect
  us.update( :user_id => user.id )

  redirect "/wait"
end

get "/wait" do
  "Wait for email"
end

get "/success" do
  us = UserSession.detect
  user = us.user
  count = User.all.count
  "User session hash: #{us.session_hash}<br />" +
    "User hash: #{user.user_hash}<br />" +
    "User email: #{user.email}<br />" +
    "Users' count: #{count}"
end

get "/" do
  redirect ( UserSession.any? ? "/success" : "/hello" )
end
