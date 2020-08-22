require "json"
class SchoolpostsController < ApplicationController
    def index
        posts = Schoolpost.all.includes(:catalog)
        render json: posts.to_json(
            :include => {
                :catalog => {
                    :except => [:created_at, :updated_at]
                }
            }, 
            :except => [:created_at, :updated_at]
        )
    end
end