class ItemsController < ApplicationController
	
	# show all items
	def index
		@items = Item.all
	end

	# form for new item
	def new
		@item = Item.new
	end 

	# saving to database new item
	def create
		@item = Item.new(item_params)
		@item.user_id = current_user.id
		if @item.save
			redirect_to '/user/items'
		else
			render 'new'
		end
	end

	# all items that are created by current user
	def user_items 
		@items = Item.where(user_id: current_user)
	end

	# item with current id
	def show
		@item = Item.find(params[:id])
	end

	# form for editing item
	def edit
		@item = Item.find(params[:id])
		# check access
		if (@item.user_id != current_user.id)
			redirect_to '/422.html'
		end
	end

	def update
		@item = Item.find(params[:id])
	    if (@item.user_id != current_user.id)
			redirect_to '/422.html'
		end
	    if @item.update_attributes(item_params)
	      	redirect_to '/user/items'
	    else
	      	render 'edit'
	    end
	end

	def delete
		@item = Item.find(params[:id])
		if (@item.user_id != current_user.id)
			redirect_to '/422.html'
		end
		if @item.destroy
			redirect_to '/'
		end
	end

	private
		def item_params
			params.require(:item).permit(:name, :price, :description, :id, :image)
		end
end
