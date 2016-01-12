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
      CSV.foreach('contacts.csv') do |row|
        if row[3] == nil
          ret_str << "#{row[0]}: #{row[1]} (#{row[2]})\n"
        else
          ret_str << "#{row[0]}: #{row[1]} (#{row[2]}), #{row[3]}\n"
        end
        count += 1
      end
      ret_str << "---\n#{count} records total"
      ret_str
    end

    # Creates a new contact, adding it to the database, returning the new contact.
    def create(name, email, phone = nil)
      # TODO: Instantiate a Contact, add its data to the 'contacts.csv' file, and return it.
      id = 1
      CSV.foreach('contacts.csv') do |row|
        id += 1
      end
      CSV.open('contacts.csv', 'a') do |csv|
              if phone.nil?
        csv << [id, name, email]
      else
        csv << [id, name, email, phone]
      end
      end




      "New contact #{name} (#{email}) added at ID: #{id}."
    end

    # Returns the contact with the specified id. If no contact has the id, returns nil.
    def find(id)
      # TODO: Find the Contact in the 'contacts.csv' file with the matching id.
      ret_str = ""
      CSV.foreach('contacts.csv') do |row|
        if id.to_i == row[0].to_i
          if row[3] == nil
            ret_str = "#{row[0]}: #{row[1]} (#{row[2]})\n"
          else
            ret_str = "#{row[0]}: #{row[1]} (#{row[2]}) #{row[3]}\n"
          end
          
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

      #If there is any element within the row that matches the entered search term, append the result to the string and increment counter.
      CSV.foreach('contacts.csv') do |row|
        #The 'i' at the and of the regex tells it to ignore case.
        if row.any? {|element| element =~ /#{term}/i}
          if row[3] == nil
            ret_str = "#{row[0]}: #{row[1]} (#{row[2]})\n"
          else
            ret_str = "#{row[0]}: #{row[1]} (#{row[2]}) #{row[3]}\n"
          end
          count += 1
        end
      end
      ret_str << "---\n#{count} records total"
      ret_str
    end


    def email_exists?(email)
      CSV.foreach('contacts.csv') do |row|
        return true if row.any? {|element| element =~ /#{email}/i}
      end
    end

  end

end


