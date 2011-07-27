class Micropost < ActiveRecord::Base
	belongs_to :user
	
	
	validates :micropost, 	:presence => true,
						:length => { :minimum => 10 }
	
end
