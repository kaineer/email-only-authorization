#
#
#
#
#

require 'rubygems'
require 'dm-core'
require 'dm-migrations'

$:.unshift( File.dirname( __FILE__ ) )

module Models
  FILES = %w( renderable user user_session )

  def self.startup
    migrate
  end

  def self.require_from( dir, files = FILES )
    files.each do |name|
      filename = File.join( dir, name + ".rb" )
      print "[DEBUG] Loading from #{filename}.."
      begin
        require filename
      rescue LoadError => le
        puts "FAIL"
      else
        puts "OK"
      end
    end
  end

  def self.migrate
    datamapper_startup
    require_from "models/scheme"

    DataMapper.finalize
    DataMapper.auto_upgrade!
  end

  def self.datamapper_startup
    DataMapper.
      setup( :default, 
             ENV[ "DATABASE_URL" ] ||
             local_datamapper_startup )
  end

  def self.local_datamapper_startup
    Dir.mkdir( "db" ) unless File.directory?( "db" )
    "sqlite3:///#{Dir.pwd}/db/rendered.db"
  end
end
