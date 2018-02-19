class Document < ActiveRecord::Base
  belongs_to :user

  dragonfly_accessor :file do
    after_assign do 
      |i| i.encode!('jpg', '-quality 80') if i.image? 
    end
  end

  validates :file, presence: true
end
