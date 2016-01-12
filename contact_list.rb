require_relative 'contact'

# Interfaces between a user and their contact list. Reads from and writes to standard I/O.
class ContactList

  # TODO: Implement user interaction. This should be the only file where you use `puts` and `gets`.

  def initialize 
    argv_menu
  end

  def argv_menu
    case ARGV[0]
      when "new"
        if ARGV[1] == nil
          name = get_input("Enter the contact's full name.")
          email = get_input("Enter contact's email address.")
        else
          name = ARGV[1]
          if ARGV[2] == nil
            email = get_input("Enter contact's email address.")
          else
            email = ARGV[2]
          end
        end
        puts Contact.create(name, email)
      when "list"
        puts Contact.all
      when "show"
        if ARGV[1] == nil
          puts Contact.find(get_input("Please enter the ID."))
        else
          puts Contact.find(ARGV[1])
        end
      when "search"
        if ARGV[1] == nil
          puts Contact.search(get_input("Please enter search term."))
        else
          puts Contact.search(ARGV[1])
        end
      else
        main_menu
    end
  end

  def get_input(string)
    puts string
    $stdin.gets.chomp
  end


  def main_menu
    puts "Here is a list of available commands:
      new     - Create a new contact
      list    - List all contacts
      show    - Show a contact
      search  - Search contacts"
  
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
    end
  end

  #Creates instance of the class to run program.
  ContactList.new
end
