require 'csv'

# Represents a person in an address book.
class Contact

  attr_accessor :name, :email

  def initialize(name, email)
    # TODO: Assign parameter values to instance variables.
    @ID = ID
    @name = name
    @email = email
  end

  # Provides functionality for managing a list of Contacts in a database.
  class << self

    # Returns an Array of Contacts loaded from the database.
    def all
      ret_str = ""
      count = 0
      CSV.foreach('contacts.csv') do |row|
        ret_str << "#{$.}: #{row[0]} (#{row[1]})\n"
        count += 1
      end
      ret_str << "---\n#{count} records total"
      ret_str
    end

    # Creates a new contact, adding it to the database, returning the new contact.
    def create(name, email)
      # TODO: Instantiate a Contact, add its data to the 'contacts.csv' file, and return it.
      CSV.open('contacts.csv', 'a') do |csv|
        csv << [name, email]
      end
      count = 0
      CSV.foreach('contacts.csv') do |row|
        count += 1
      end
      "Done. #{name} (#{email}) added at #{count}."
    end

    # Returns the contact with the specified id. If no contact has the id, returns nil.
    def find(id)
      # TODO: Find the Contact in the 'contacts.csv' file with the matching id.
      ret_str = ""
      count = 0
      CSV.foreach('contacts.csv') do |row|
        count += 1
        if id.to_i == count
          ret_str = "#{id}: #{row[0]} (#{row[1]})\n"
        end
      end
      ret_str = "ID not found." if ret_str == ""
      ret_str
    end

    # Returns an array of contacts who match the given term.
    def search(term)
      # TODO: Select the Contact instances from the 'contacts.csv' file whose name or email attributes contain the search term.
      # ret_str = ""

      # count = 0
      # CSV.foreach('contacts.csv') do |row|
      #   if row.include?(/.*Andy.*/)
      #     ret_str << "#{$.}: #{row[0]} (#{row[1]})\n"
      #     count += 1
      #   end
      # end
      # ret_str << "---\n#{count} records total"
      # ret_str
    end

  end

end
