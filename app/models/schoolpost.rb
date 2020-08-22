class Schoolpost < ApplicationRecord
    belongs_to :catalog
    has_many :schoolpostfiles
    has_many :schoolpostimages
end
