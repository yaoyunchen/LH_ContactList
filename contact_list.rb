require_relative 'contact'

# Interfaces between a user and their contact list. Reads from and writes to standard I/O.
class ContactList

  # TODO: Implement user interaction. This should be the only file where you use `puts` and `gets`.

  def initialize
    argv_menu
    #main_menu
  end


  def argv_menu

    case ARGV[0]
    when "list"
      puts Contact.all
    when "new"
      if ARGV[1] == nil
        name = get_name
        puts "Enter contact's email."
        email = get_email
      else
        name = ARGV[1]
        if ARGV[2] == nil
          email = get_email
        else
          email = ARGV[2]
        end
      end
      puts email
      puts name
      puts Contact.create(name, email)
    end

  end

  def get_name
      puts "Enter contact's full name."
      $stdin.gets.chomp
  end

  def get_email
    puts "Enter contact's email"
    $stdin.gets.chomp
  end
  # def main_menu
  #   puts "Here is a list of available commands:
  #     new     - Create a new contact
  #     list    - List all contacts
  #     show    - Show a contact
  #     search  - Search contacts 
  #     "
  #   #input, name, email, password = ARGV

  #   #RGV << gets.chomp if ARGV.empty? 
  #   #case gets.chomp
  #   case gets.chomp
  #     when "new"
  #       puts "Enter the contact's full name."
  #       name = gets.chomp
        
  #       puts "Enter contact's email address."
  #       email = gets.chomp
  #       puts Contact.create(name, email)
  #     when "list"
  #       puts Contact.all
  #     when "show"
  #       puts "Please enter ID."
  #       puts Contact.find(gets.chomp)
  #     when "search"
  #       puts "Please enter search term."
  #       puts Contact.search(gets.chomp)
  #   end
  # end







  #Creates instance of the class to run program.
  ContactList.new
end
