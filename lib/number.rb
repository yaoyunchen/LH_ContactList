class Number < ActiveRecord::Base
  belongs_to :contact

  validates :contact, :num_type, :number, presence: true

  def to_s
    "#{self.num_type}: #{self.number}"
  end
end