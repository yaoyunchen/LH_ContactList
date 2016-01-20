class Contact < ActiveRecord::Base
  has_many :numbers, :dependent => :destroy

  validates :name, :email, presence: true
  validates :email, uniqueness: true
  validates_format_of :email, :with => /@/

  def to_s
    ret_str = "ID: #{self.id}, Name: #{self.name}, Email: #{self.email}, Phone: "
    numbers = self.numbers.to_a
    if numbers.empty?
      ret_str << "N/A"
    else
      ret_str << get_numbers(numbers)
    end
    ret_str
  end

  def get_numbers(numbers)
    ret_str = ""
    numbers.each {|number| ret_str << "#{number} "}
    ret_str
  end
end





# # Represents a person in an address book.
# class Contact

#   attr_accessor :name, :email, :phone
#   attr_reader :ID
#   @@file = 'contacts.csv'

#   def initialize(name, email)
#     # TODO: Assign parameter values to instance variables.
#     @ID = ID
#     @name = name
#     @email = email
#     @phone = phone
#   end

#   # Provides functionality for managing a list of Contacts in a database.
#   class << self
#     # Creates a new contact, adding it to the database, returning the new contact.
#     def create(name, email, phone = nil)
#       count = 1
#       CSV.foreach(@@file) do |row|
#         count += 1
#       end
#       CSV.open(@@file, 'a') do |csv|
#         phone.nil? ? csv << [count, name, email] : csv << [count, name, email, phone]
#       end
#       "New contact #{name} (#{email}) added at ID: #{count}."
#     end


#     #Goes through contacts and carry out actions based on inputs.
#     def loop_through_contacts(action, param = nil)
#       ret_str = ""
#       count = 0

#       csv_to_hash.each do |row|
#         case action
#           when "all"
#             ret_str << build_string(row)
#             count += 1
#           when "show"
#             ret_str << build_string(row) if row[:ID].to_i == param.to_i
#           when "search"  
#             unless row.values.grep(/#{param}/i) == []
#               ret_str << build_string(row)
#               count += 1
#             end
#         end
#       end

#       ret_str << "---\n#{count} records total" unless action == "show"
#       ret_str
#     end


#     #Checks if the entered email exists in the contact list already.
#     def email_exists?(email)
#       CSV.foreach(@@file) do |row|
#         return true if row.any? {|element| element =~ /#{email}/i}
#       end
#     end


#     #Converts the CSV file into a hash.
#     def csv_to_hash
#       keys = [:ID, :name, :email, :phone]
#       # CSV.parse(input).map {|ele| Hash[keys.zip(ele)]}
#       CSV.read(@@file).map{|a| Hash[keys.zip(a)]}
#     end


#     #Builds the return string to be displayed to the user.
#     def build_string(row)
#       "#{row[:ID]}: #{row[:name]} (#{row[:email]}) #{row[:phone]}\n"
#     end
#   end
# end


