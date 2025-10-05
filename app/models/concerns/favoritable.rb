module Favoritable
  extend ActiveSupport::Concern

  included do
    has_many :favorites, dependent: :destroy
    
    def favorite!
      favorites.create(user: user)
    end
  
    def unfavorite!
      favorite.destroy
    end
  
    def favorite
      favorites.find_by(user: user)
    end        
  end
end