class Catalog < ApplicationRecord
    has_many :schoolposts, -> { order(:publishdate => :desc) }
end
