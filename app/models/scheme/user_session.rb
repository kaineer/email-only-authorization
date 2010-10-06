#
#
#
#
#

require File.join( File.dirname( __FILE__ ), 'auth_hash' )
require File.join( File.dirname( __FILE__ ), '../../session' )

class UserSession
  include DataMapper::Resource

  property :id,      Serial
  property :user_id, Integer
  property :session_hash,    String
  property :updated_at, DateTime

  belongs_to :user

  include AuthHash

  # init:
  #   us = UserSession.detect
  #   user = us.user
  #   renderables = Renderable.all( :session_id => us.id )
  #
  def self.detect
    us = if Session[ "session_id" ]
      UserSession.first( :id => Session[ "session_id" ] )
    end 
    unless us
      us = generate
      Session[ "session_id" ] = us.id
    else
      us.update_timestamps( :save => true )
    end
    us.update_timestamps( :save => true )
    us
  end

  def self.any?
    !Session[ "session_id" ].nil?
  end

  def self.generate
    us = UserSession.create( :session_hash => current_time_hash )
    us
  end

  def self.restore_for( user )
    us = UserSession.last( :conditions => { :user_id => user.id }, :order => :updated_at )
    Session[ "session_id" ] = us.id
  end

  def update_hash
    self.update( :session_hash => self.class.current_time_hash )
  end

  before :save, :update_timestamps
  def update_timestamps( opts = { :save => false } )
    self.updated_at = Time.now
    self.save if opts[ :save ]
  end
end
