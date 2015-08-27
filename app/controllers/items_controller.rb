class ItemsController < ApplicationController
	
	def eligible_edit_item(item)
		item.user_id == current_user.id  || admin?
	end


	# show all items
	def index
		@items = Item.all
	end

	# form for new item
	def new
		unless logged_in?
			redirect_to '/422.html'
		else
			@item = Item.new
		end
	end 

	# saving to database new item
	def create
		unless logged_in?
			redirect_to '/422.html'
		else 
			@item = Item.new(item_params)
			@item.user_id = current_user.id
			if @item.save
				flash[:info] = "Item has been successfully created."
				redirect_to '/items/user/' + current_user.id.to_s
			else
				render 'new'
			end
		end
	end

	# all items that are created by current user
	def user_items 
		@items = Item.where(user_id: params[:id])
	end

	# item with current id
	def show
		require 'open-uri'
    	require 'json'

		@item = Item.find(params[:id])
		if logged_in?
			seller = User.find(@item.user_id)
			data = open("https://api.jacobs-cs.club/user/name/" + (seller.username) + "?token=" + (current_user.token))
	    	@seller_info = JSON.parse(data.read)
	    end
	end

	# form for editing item
	def edit
		@item = Item.find(params[:id])
		# check access
		if (!eligible_edit_item(@item))
			redirect_to '/422.html'
		end
	end

	def update
		@item = Item.find(params[:id])
	    if (!eligible_edit_item(@item))
			redirect_to '/422.html'
		end
	    if @item.update_attributes(item_params)
	    	flash[:info] = "Item has been successfully updated."
	      	redirect_to '/user/items'
	    else
	    	flash[:error] = "Error while updating item."
	      	render 'edit'
	    end
	end 

	def delete
		@item = Item.find(params[:id])
		if (!eligible_edit_item(@item))
			redirect_to '/422.html'
		end
		if @item.destroy
			flash[:info] = "Item has been successfully deleted."
			redirect_to '/'
		else
			flash[:error] = "Error while deleting item."
		end
	end

	private
		def item_params
			params.require(:item).permit(:name, :price, :description, :id, :image)
		end
end
