require "json"
class SchoolpostsController < ApplicationController
    def index
        time = Time.new
        time = time - 30.day
        time = time.strftime("%Y-%m-%d")
        @posts = Schoolpost.where("publishdate >= ?", time).includes(:catalog).page(params[:page]).per(10)
        respond_to do |format|
	        format.html
	        format.js { render :layout => false }
	    end
    end

    def show
        @post = Schoolpost.includes(:catalog,:schoolpostfiles,:schoolpostimages).find(params[:id])
    end
end