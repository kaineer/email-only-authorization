require 'md5'

module AuthHash
  def self.included( klazz )
    klazz.extend( ClassMethods )
  end

  def self.timestamp
    Time.now.strftime( "%Y%m%d%H%M%S" )
  end

  module ClassMethods
    def current_time_hash
      MD5.md5( AuthHash.timestamp ).to_s
    end

    def current_user_hash( email )
      MD5.md5( email + '/' + AuthHash.timestamp ).to_s
    end
  end
end
