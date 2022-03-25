class Member < ApplicationRecord
    validates :name, presence: true
    validates :surname, presence: true
    validates :email, presence: true
    validates :birthday, presence: true
    validates :games_played, presence: true
    validates :rank, presence: true
end
