require 'pg'

class Contact

  attr_accessor :id, :name, :email, :numbers
 

  def initialize(name, email)
    @id = id
    @name = name
    @email = email
    @numbers = {}
  end


  def is_new?
    @id.nil?
  end


  def save
    if is_new?
      result = Contact::connect.exec_params('INSERT INTO contacts (name, email) VALUES ($1, $2) RETURNING id;', [name, email])
      self.id = result[0]['id']
    else
      Contact::connect.exec_params('UPDATE contacts SET name = $1, email = $2 WHERE id = $3::int', [@name, @email, @id])
    end
    
    #Should be inside a transaction.
    unless self.numbers == nil
        save_numbers_string
    end
  end

  def new_numbers?
    true
  end


  def save_numbers_string
    if new_numbers
      self.numbers.each do |number|
        Contact::connect.exec_params('
          INSERT INTO numbers (contact_id, type, number)
          VALUES ($1, $2, $3)
          ;', [self.id, number.keys[0], number.values[0]])
      end
    else


    end
  end



  def destroy
    Contact::connect.exec_params("DELETE FROM contacts WHERE id = $1::int", [@id])
  end



  class << self
    #Lets Ruby connect to the database.
    def connect
      PG.connect(
        host: 'localhost',
        dbname: 'contacts',
        user: 'development',
        password: 'development'
        )
    end

    def list
      result = Contact::connect.exec_params('
        SELECT c.id, c.name, c.email, 
          array_to_string(array_agg(n.type || \': \' || n.number),\', \') AS phone
        FROM contacts AS c
        LEFT JOIN numbers AS n 
          ON c.id = n.contact_id
        GROUP BY c.id, c.name, c.email
        ;')
      create_contact_array(result)
    end


    def insert(name, email, phone = nil)
      new_contact = Contact.new(name, email)
      new_contact.numbers = phone
      new_contact.save

      "New contacted added with ID: #{new_contact.id}."
    end


    def show(id)
      result = Contact::connect.exec_params('
        SELECT c.id, c.name, c.email, n.type, n.number
        FROM contacts AS c
        LEFT JOIN numbers AS n
          ON c.id = n.contact_id
        WHERE c.id = $1::int
        ;', [id])
      contact = Contact.new(result[0]['name'], result[0]['email'])
      contact.id = result[0]['id']
      
      result.each do |ele|
        unless ele['type'] == nil
          contact.numbers[ele['type'].to_sym] = ele['number']
        end
      end

      contact
    end


    def search(term)
      result = Contact::connect.exec_params('
        SELECT * 
        FROM contacts 
        WHERE id = $1 OR LOWER(name) LIKE $2 
          OR LOWER(email) LIKE $2;
        ', [is_integer(term), "%#{term.downcase}%"])

      create_contact_array(result)
    end


    def update(id, new_name, new_email, new_numbers = nil)
      contact = Contact.show(id)
      contact.name = new_name
      contact.email = new_email

      contact.numbers = new_numbers

      contact.save
      "Contact #{id} updated."
    end


    def delete(id)
      contact = Contact.show(id)
      contact.destroy
      "Contact #{id} deleted."
    end


    def is_integer(input)
      input if Integer(input) rescue -1 
    end


    def create_contact_array(result)
      contact_arr = []
      result.each {|element| contact_arr << element}
      contact_arr
    end
 

  end
end


