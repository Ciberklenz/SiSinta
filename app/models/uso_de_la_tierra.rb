class UsoDeLaTierra < ActiveRecord::Base
  has_many :perfiles

  validates :valor, presence: true
end
