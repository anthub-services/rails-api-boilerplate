class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise   :database_authenticatable,
           :registerable,
           :recoverable,
           :rememberable,
           :trackable,
           :validatable

  has_one  :path
  has_many :sessions

  validates :email, presence: true
  validates :email, uniqueness: true

  def full_name
    [self.first_name, self.last_name].join(' ')
  end
end
