#
#
#

class Renderable
  include DataMapper::Resource
  
  property :id,          Serial
  property :created_at,  DateTime
  property :last_access, DateTime
  property :content,     String
  property :path,        String
  property :session_id,  Integer


  before :save, :update_timestamps

  def update_timestamps
    now = Time.now
    self.created_at ||= now
    self.last_access = now
  end
end
