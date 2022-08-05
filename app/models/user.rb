class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable, :omniauthable and 
  devise :database_authenticatable, :registerable,
         :recoverable, :validatable, :rememberable
end
