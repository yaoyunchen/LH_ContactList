#!/usr/bin/env ruby

require_relative '../setup'
require 'pry'

class ContactList

  def initialize
    argv_menu
  end

  def argv_menu
    case ARGV[0]
      when "new"
        new_contact
      when "list"
        list_contacts
      when "show"
        show_contacts
      when "search"
        search_contacts
      when "delete"
        destroy_contact
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
      destroy - Destroy contact"  
    case gets.chomp
      when "new"
        new_contact(get_input("name"), get_input("email"))
      when "list"
        list_contacts
      when "show"
        show_contacts
      when "search"
        search_contacts
      when "delete"
        destroy_contact
    end
  end


  def new_contact
    ARGV[1] == nil ? name = get_input("name") : name = ARGV[1] 
    ARGV[2] == nil ? email = get_input("email") : email = ARGV[2]

    @contact = Contact.create(name: name, email: email)   
    if  @contact.valid? 
      save_numbers(get_phone_numbers)
      p  "New contact added with ID #{@contact.id}."
    else  
      p @contact.errors.to_a 
    end
  end
  
  def save_numbers(phone_numbers)
    unless phone_numbers == nil
      phone_numbers.each do |number|
        number.each do |key, value|
          phone = @contact.numbers.create(num_type: key.to_s, number: value)
        end
      end
    end
  end

  def list_contacts
    get_results(Contact.includes(:numbers))
  end


  def show_contacts
    id = ARGV[1] ? ARGV[1] : get_input("ID") 

    get_results(Contact.includes(:numbers)
    .where("contacts.id = ?", [id]))
  end


  def search_contacts
    term = ARGV[1] ? ARGV[1] : get_input("search term")

    contacts = Contact.includes(:numbers)
    .where("contacts.id = ? OR LOWER(name) LIKE LOWER(?) OR LOWER(email) LIKE LOWER(?)", is_integer(term), '%' + term + '%', '%' + term + '%')

    get_results(contacts)
  end


  def destroy_contact
    id = ARGV[1] ? ARGV[1] : get_input("ID")
    contact = Contact.find(id)
    contact.destroy
    puts "Contact #{id} deleted."
  end


  #Checks if the user input is an integer and set as -1 if not.
  def is_integer(input)
    input if Integer(input) rescue -1
  end


  #Used to prompt user for input and return the string the user enters.
  def get_input(string)
    puts "Please enter #{string}."
    $stdin.gets.chomp
  end


  def get_phone_numbers
    phone_numbers = ARGV.drop(3)

    phone_array = []
    
    phone_array = phone_numbers[0] ? argv_numbers(phone_numbers) : entered_numbers
  end


  def entered_numbers
    puts "Please enter phone numbers in 'TYPE_01:111-111-1111/TYPE_02:222-222-2222' format, or ENTER to continue."
    phone_numbers = $stdin.gets.chomp
    phone_array = []
    unless phone_numbers == ""
      phone_numbers.split("/").each do |number|
          str = number.split(":")
          phone_array << {str[0].to_sym => str[1]}
      end
      phone_array
    end
  end


  def argv_numbers(phone_numbers)
    phone_array = []
    temp_array = []
    until phone_numbers.empty?
      temp_array << phone_numbers[0]
      phone_numbers = phone_numbers.drop(1)        
    end
    temp_array.each do |number|
      str = number.split(":")
      phone_array << {str[0].to_sym => str[1]}
    end
    phone_array
  end


  def get_results(contacts)
    puts contacts.empty? ? "No results found." : contacts.to_a
  end


  ContactList.new
end





