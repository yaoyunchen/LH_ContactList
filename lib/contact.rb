class Contact < ActiveRecord::Base
  has_many :numbers, dependent: :destroy

  validates :name, :email, presence: true
  validates :email, uniqueness: true
  validates_format_of :email, :with => /@/

  def to_s
    ret_str = "ID: #{self.id}, Name: #{self.name}, Email: #{self.email}, Phone: "
    numbers = self.numbers.to_a
    if numbers.empty?
      ret_str << "N/A"
    else
      ret_str << get_numbers(numbers)
    end
    ret_str
  end

  def get_numbers(numbers)
    ret_str = ""
    numbers.each {|number| ret_str << "#{number} "}
    ret_str
  end
end



