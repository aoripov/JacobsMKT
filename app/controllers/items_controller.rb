class ItemsController < ApplicationController
	def index
		@items = Item.all
	end

	def new
		@item = Item.new
	end 

	def user_items 
		@items = Item.where(user_id: current_user)
	end

	def show
		@item = Item.find(params[:id])
	end

	def edit
		@item = Item.find(params[:id])
	end

	def create
		@item = Item.new(item_params)
		@item.user_id = current_user.id
		if @item.save
			redirect_to '/user/items'
		else
			render 'new'
		end
	end

	private
		def item_params
			params.require(:item).permit(:name, :price, :description, :id)
		end
end
