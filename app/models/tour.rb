class Tour < ActiveRecord::Base
	belongs_to :group
	has_many :concerts, dependent: :destroy
end
