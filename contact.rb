require 'csv'

# Represents a person in an address book.
class Contact

  attr_accessor :name, :email, :phone
  attr_reader :ID

  def initialize(name, email)
    # TODO: Assign parameter values to instance variables.
    @ID = ID
    @name = name
    @email = email
    @phone = phone
  end

  # Provides functionality for managing a list of Contacts in a database.
  class << self
    # Returns an Array of Contacts loaded from the database.
    def all
      ret_str = ""
      count = 0

      csv_to_hash.each do |row|
        ret_str << build_string(row)
        count += 1
      end
      
      ret_str << "---\n#{count} records total"
      ret_str
    end


    # Creates a new contact, adding it to the database, returning the new contact.
    def create(name, email, phone = nil)
      # TODO: Instantiate a Contact, add its data to the 'contacts.csv' file, and return it.
      count = 1
      CSV.foreach('contacts.csv') do |row|
        count += 1
      end
      CSV.open('contacts.csv', 'a') do |csv|
        phone.nil? ? csv << [count, name, email] : csv << [count, name, email, phone]
      end
      "New contact #{name} (#{email}) added at ID: #{count}."
    end


    # Returns the contact with the specified id. If no contact has the id, returns nil.
    def find(id)
      # TODO: Find the Contact in the 'contacts.csv' file with the matching id.
      ret_str = ""

      csv_to_hash.each do |row|
        if row[:ID] == id
          ret_str << build_string(row)
        end
      end

      ret_str = "ID not found." if ret_str == ""
      ret_str
    end

    # Returns an array of contacts who match the given term.
    def search(term)
      # TODO: Select the Contact instances from the 'contacts.csv' file whose name or email attributes contain the search term.
      ret_str = ""
      count = 0

      csv_to_hash.each do |row|
        unless row.values.grep(/#{term}/i) == []
          ret_str << build_string(row)
          count += 1
        end
      end
      
      ret_str << "---\n#{count} records total"
      ret_str
    end

    #Checks if the entered email exists in the contact list already.
    def email_exists?(email)
      CSV.foreach('contacts.csv') do |row|
        return true if row.any? {|element| element =~ /#{email}/i}
      end
    end

    #Converts the CSV file into a hash for easier usage.
    def csv_to_hash
      keys = [:ID, :name, :email, :phone]
      # CSV.parse(input).map {|ele| Hash[keys.zip(ele)]}
      CSV.read('contacts.csv').map{|a| Hash[keys.zip(a)]}
    end

    #Builds the return string to be displayed to the user.
    def build_string(row)
      "#{row[:ID]}: #{row[:name]} (#{row[:email]}) #{row[:phone]}\n"
    end
  end
end


