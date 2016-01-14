#!/usr/bin/env ruby

require 'pry'

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
        puts create_new_contact
      when "list"
        #puts Contact.all
        puts Contact.loop_through_contacts("all")
      when "show"
        puts do_show
      when "search"
        puts do_search
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
      search  - Search contacts"  
    case gets.chomp
      when "new"
        puts create_new_contact
      when "list"
        #puts Contact.all
        puts Contact.loop_through_contacts("all")
      when "show"
        #puts Contact.find(get_input("ID"))
        puts do_show
      when "search"
        #puts Contact.search(get_input("search term"))
        puts do_search
    end
  end


  #Show contact, given the ID.
  def do_show
    ARGV[1] == nil ? Contact.loop_through_contacts("show", get_input("ID")) : Contact.loop_through_contacts("show", ARGV[1])
  end


  #Search contacts for a given term.
  def do_search
    ARGV[1] == nil ? Contact.loop_through_contacts("search", get_input("search term")) : Contact.loop_through_contacts("search", ARGV[1])
  end
  

  #Used to prompt user for input and return the string the user enters.
  def get_input(string)
    puts "Please enter #{string}."
    $stdin.gets.chomp
  end

  #Gets the name for new contact.
  def get_name
    ARGV[1] == nil ? get_input("full name") : ARGV[1]
  end

  #Gets the email for new contact.
  def get_email
    ARGV[2] == nil ? get_input("email") : ARGV[2]
  end

  #Gets every input after email add add them to a phone number array.
  def get_phone_numbers
    phone_array = []

    phone_numbers = ARGV.drop(3)
    if phone_numbers[0] == nil
      puts "Please enter phone numbers in 'TYPE_01:111-111-1111/TYPE_02:222-222-2222' format, or ENTER to continue."
      phone_numbers = $stdin.gets.chomp
    else
    until phone_numbers.empty?
      phone_array << phone_numbers[0]
      phone_numbers = phone_numbers.drop(1)
    end
    phone_array.join("/")
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
      raise EmailExistsError if Contact.email_exists?(email)

      Contact.create(name, email, phone_numbers)
    rescue InvalidEmailError
      "The entered email is in an invalid format."
    rescue EmailExistsError
      "The entered email exists in the contact list already."
    end
  end

  
  class EmailExistsError < StandardError
  
  end

  class InvalidEmailError < StandardError

  end

  #Creates instance of the class to run program.
  ContactList.new
end


