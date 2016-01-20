#!/usr/bin/env ruby

require_relative 'contact'

# Interfaces between a user and their contact list. Reads from and writes to standard I/O.
class ContactList

  class EmailExistsError < StandardError
  
  end

  class InvalidEmailError < StandardError

  end

  def initialize 
    argv_menu
  end

  def argv_menu
    case ARGV[0]
      when "new"
       puts create_new_contact
      when "list"
        puts Contact.list
      when "show"
        p Contact.show(ARGV[1])
      when "search"
        puts Contact.search(ARGV[1])
      when "update"
        puts Contact.update(ARGV[1], ARGV[2], ARGV[3])
      when "delete"
        puts Contact.delete(ARGV[1])
      else
        main_menu
    end
  end

  #Loads a menu if no ARGV provided when running.
  def main_menu
    puts "Here is a list of available commands:
      new     - Create a new contact
      list    - List all contacts
      show    - Show a contact
      search  - Search contacts
      update  - Update contact
      delete  - Delete contact"  
    case gets.chomp
      when "new"
        puts create_new_contact
      when "list"
        puts Contact.list
      when "show"
        p Contact.show(get_input("ID"))
      when "search"
        puts Contact.search(get_input("Search Term"))
      when "update"
        puts Contact.update(get_input("ID"), get_input("Name"), get_input("Email"))
      when "delete"
        puts Contact.delete(get_input("ID"))
    end
  end


  #Used to prompt user for input and return the string the user enters.
  def get_input(string)
    puts "Please enter #{string}."
    $stdin.gets.chomp
  end


  
  #Gets the name for new contact.
  def get_name
    ARGV[1] == nil ? get_input("Name") : ARGV[1]
  end

  #Gets the email for new contact.
  def get_email
    ARGV[2] == nil ? get_input("Email") : ARGV[2]
  end

  #Gets every input after email add add them to a phone number array.
  def get_phone_numbers
    phone_numbers = ARGV.drop(3)

    phone_array = []
    temp_array = []
    
    if phone_numbers[0] == nil
      puts "Please enter phone numbers in 'TYPE_01:111-111-1111/TYPE_02:222-222-2222' format, or ENTER to continue."
      phone_numbers = $stdin.gets.chomp
      
      unless phone_numbers == ""
        phone_numbers.split("/").each do |number|
            str = number.split(":")
            phone_array << {str[0] => str[1]}
        end
        phone_array
      end
    else
      until phone_numbers.empty?
        temp_array << phone_numbers[0]
        phone_numbers = phone_numbers.drop(1)        
      end
      temp_array.each do |number|
        str = number.split(":")
        phone_array << {str[0] => str[1]}
      end
      phone_array
    end
  end



  #Used to create a new contact if inputs were given, or prompt user for inputs first if not.
  def create_new_contact
    begin
      name = get_name
      email = get_email
      phone_numbers = get_phone_numbers
      
      #Makes sure entered email is in correct email format.
      raise InvalidEmailError unless email.include?("@")
      #Check if entered email exists already in the CSV.
      raise EmailExistsError if Contact.search(email) == nil 
      Contact.insert(name, email, phone_numbers)
    rescue InvalidEmailError
      "The entered email is in an invalid format."
    rescue EmailExistsError
      "The entered email exists in the contact list already."
    end
  end


  #Creates instance of the class to run program.
  ContactList.new
end


