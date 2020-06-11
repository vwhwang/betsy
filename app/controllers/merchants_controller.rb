class MerchantsController < ApplicationController
  def index
    @merchants = Merchant.all
  end

  def show
    @merchant = Merchant.find_by(id: params[:id])
    render_404 unless @merchant
  end

  def create
    auth_hash = request.env["omniauth.auth"]

    merchant = Merchant.find_by(uid: auth_hash[:uid], provider: "github")
    if merchant
      # Merchant was found in the database
      flash[:success] = "Logged in as returning: #{merchant.username}"
    else
      # Merchant doesn't match anything in the DB
      # Attempt to create a new merchant
      merchant = Merchant.build_from_github(auth_hash)

      if merchant.save
        flash[:success] = "Logged in as: #{merchant.username}"
      else
        flash[:error] = "Could not create new merchant account: #{merchant.errors.messages}"
        
        return redirect_to root_path
      end
    end

    # If we get here, we have a valid merchant instance

    session[:merchant_id] = merchant.id
    return redirect_to root_path
  end


  def destroy
    session[:merchant_id] = nil
    flash[:success] = "Successfully logged out!"

    redirect_to root_path
  end

  def current
    @merchant = Merchant.find_by(id: session[:merchant_id])
    if @merchant.nil?
      # I have to be logged in!
      flash[:error] = "You must be logged in to view this page"
      redirect_to current_merchant_path
      return
    end
  end
end
