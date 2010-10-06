class Session
  def self.instance=( session )
    @session = session
  end

  def self.instance
    @session
  end

  def self.[]( key )
    ensure_session_is_valid
    @session[ key ]
  end

  def self.[]=( key, value )
    ensure_session_is_valid
    @session[ key ] = value
  end

protected
  def self.ensure_session_is_valid
    raise "Session is not initiated!" unless @session
  end
end

=begin
module Session
  def self.instance=( session )
    @@session = session
  end

  def session
    @@session
  end
end

# include Session # for use in objects
# extend  Session # for use in class methods


=end
