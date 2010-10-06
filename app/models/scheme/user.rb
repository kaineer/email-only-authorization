#
#
#
#
#

require File.join( File.dirname( __FILE__ ), 'auth_hash' )

class User
  include DataMapper::Resource

  property :id,          Serial
  property :user_hash,   String
  property :email,       String
  
  property :created_at,  DateTime
  property :updated_at,  DateTime
  property :last_login,  DateTime
  property :last_email_sent, DateTime

  has n, :user_sessions


  include AuthHash

  def self.detect( email )
    user = User.first( :email => email )
    unless user 
      user = generate( email )
    else
      user.update_timestamps( :save => true )
    end
    user
  end

  def self.generate( email )
    User.create( :email => email )
  end
  
  def update_hash
    self.update( :user_hash => self.class.current_user_hash( self.email ) )
  end

  def send_login_link
    update_hash
    Pony.
      mail( 
           :to => email, 
           :from => "kaineer@mail.ru", 
           :via => :smtp, 
           :smtp => { 
             :port => 25,
             :host => "smtp.mail.ru" 
             :user => "kaineer",
             :password => "failedsecret",
             :auth => :plain,
             :domain => "localhost"
           },
           :subject => "[rendered.hello] Login link",
           :body => "http://email-only-authorization.heroku.com/hello/#{self.user_hash}" )
  end

  def restore_session
    UserSession.restore_for( self )
  end

  before :save, :update_timestamps
  def update_timestamps( opts = { :save => false } )
    now = Time.now
    self.created_at ||= now
    self.updated_at = now
    self.save if opts[ :save ]
  end
end
