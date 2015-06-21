class TransactionsController < ApplicationController
  #before_action: authenticate_user!

  def new
    gon.client_token = generate_client_token
    render :new
  end
 
  def create
    @result = Braintree::Transaction.sale(
              amount: $price,
              payment_method_nonce: params[:payment_method_nonce])
    if @result.success?
      redirect_to items_path, notice: "Congratulations! Your transaction has been successful!"
    else
      #flash[:alert] = "Something went wrong while processing your transaction. Please try again!"
      gon.client_token = generate_client_token
      render :new
    end
  end

  private
  def generate_client_token
    Braintree::ClientToken.generate
  end
end
