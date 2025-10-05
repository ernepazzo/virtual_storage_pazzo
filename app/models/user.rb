class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  acts_as_paranoid
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :confirmable

  # validates :whatsapp, resence: false, uniqueness: true,
  #           format: {
  #             # with: /\A\+[0-9]+\z/,
  #             with: /\A[0-9]+\z/,
  #             message: :invalid
  #           }

  has_many :products, dependent: :destroy
  has_many :favorites, dependent: :destroy
end
