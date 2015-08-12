module UsersHelper

	def create
		puts 'creating new user'
	    @user = User.new(user_params)
	    if @user.save
	      log_in @user
	      flash[:success] = "Welcome to JacobsMKT!"
	      redirect_to @user
	    else
	      render 'new'
	    end
	end

end
