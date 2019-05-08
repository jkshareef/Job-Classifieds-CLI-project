require 'bundler'
Bundler.require

require_all 'app'
require_all 'lib'

ActiveRecord::Base.establish_connection(adapter: 'sqlite3', database: 'db/development.db')
