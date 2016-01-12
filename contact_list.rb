require_relative 'contact'

# Interfaces between a user and their contact list. Reads from and writes to standard I/O.
class ContactList

  # TODO: Implement user interaction. This should be the only file where you use `puts` and `gets`.

  def initialize 
    main_menu
  end

  def main_menu
    puts "Here is a list of available commands:
      new     - Create a new contact
      list    - List all contacts
      show    - Show a contact
      search  - Search contacts 
      "
      # input, name, email, password = ARGV
    case gets.chomp
      when "new"
        puts "Enter the contact's full name."
        name = gets.chomp
        
        puts "Enter contact's email address."
        email = gets.chomp
        puts Contact.create(name, email)
      when "list"
        puts Contact.all
      when "show"
        puts "Please enter ID."
        puts Contact.find(gets.chomp)
      when "search"
        puts "Please enter search term."
        puts Contact.search(gets.chomp)
      else
    end
  end

  # def list_contacts
  #   puts "List contacts."
  # end







  #Creates instance of the class to run program.
  ContactList.new
end
