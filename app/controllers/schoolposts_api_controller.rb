require "json"
class SchoolpostsApiController < ApplicationController
    def index
        @posts = Schoolpost.where("publishdate >= '2020-06-01'").includes(:catalog, :schoolpostimages, :schoolpostfiles).limit(100)
        render json: @posts.to_json(
            :include => {
                :catalog => {
                    :except => [:created_at, :updated_at]
                },
                :schoolpostimages =>{
                    :except => [:created_at, :updated_at]
                },
                :schoolpostfiles =>{
                    :except => [:created_at, :updated_at]
                }
            }, 
            :except => [:created_at, :updated_at]
        )
    end
end