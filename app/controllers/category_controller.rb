class CategoryController < ApplicationController
	def index
		unless admin?
			redirect_to '/422.html'
		end
		@categories = Category.all
		@category = Category.new
	end

	def new
		unless admin?
			redirect_to '/422.html'
		else
			@category = Category.new
		end
	end 

	def create
		unless admin?
			redirect_to '/422.html'
		else 
			@category = Category.new(category_params)
			if @category.save
				flash[:info] = "Category has been successfully created."
			else
				flash[:error] = "Error occured while saving category. Please, try again."
			end
			redirect_to '/category'
		end
	end

	def update
		@category = Category.find(params[:format])
	    unless admin?
			redirect_to '/422.html'
		end
	    if @category.update_attributes(category_params)
	    	flash[:info] = "Category has been successfully updated."
	    else
	    	flash[:error] = "Error while updating category."
	    end
	    redirect_to '/category'
	end 

	def delete
		@category = Category.find(params[:id])
		unless admin?
			redirect_to '/422.html'
		end
		if @category.destroy
			flash[:info] = "Category has been successfully deleted."
		else
			flash[:error] = "Error while deleting category."
		end
		redirect_to '/category'
	end
	
	private
		def category_params
			params.require(:category).permit(:id, :name, :machine_name)
		end
end
