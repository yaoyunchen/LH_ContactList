require 'pry' # in case you want to use binding.pry
require 'active_record'
require_relative 'lib/contact'
require_relative 'lib/number'

# Output messages from Active Record to standard out
ActiveRecord::Base.logger = Logger.new(STDOUT)

puts 'Establishing connection to database ...'
ActiveRecord::Base.establish_connection(
  adapter: 'postgresql',
  database: 'contacts',
  username: 'development',
  password: 'development',
  host: 'localhost',
  port: 5432,
  pool: 5,
  encoding: 'unicode',
  min_messages: 'error'
)
puts 'CONNECTED'

# puts 'Setting up Database (recreating tables) ...'

# ActiveRecord::Schema.define do
#   drop_table :contacts if ActiveRecord::Base.connection.table_exists?(:contacts)
#   drop_table :numbers if ActiveRecord::Base.connection.table_exists?(:numbers)

#   create_table :contacts do |t|
#     t.column :name, :string
#     t.column :email, :string
#     t.timestamps null: false
#   end

#   create_table :numbers do |t|
#     t.references :contact
#     t.column :num_type, :string
#     t.column :number, :string
#     t.timestamps null: false
#   end
# end

# puts 'Setup DONE'
