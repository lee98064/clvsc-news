class CatalogsController < ApplicationController
    
    def index
        @catalogs = Catalog.all
    end
    
    def show
        @catalog = Catalog.includes(:schoolposts).find(params[:id])
        @posts = Schoolpost.where(catalog_id: @catalog.id.to_s).includes(:catalog).page(params[:page]).per(10).order("publishdate DESC")
        respond_to do |format|
	        format.html
	        format.js { render :layout => false }
	    end
    end
end