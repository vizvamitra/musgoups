class Group < ActiveRecord::Base
	has_many :songs, dependent: :destroy
	has_many :members, dependent: :destroy
	has_many :tours, dependent: :destroy
end