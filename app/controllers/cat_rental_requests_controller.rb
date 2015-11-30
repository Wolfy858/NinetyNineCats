class CatRentalRequestsController < ApplicationController


  def new
    @rental_request = CatRentalRequest.new
    render :new
  end

  def create
      @rental_request = CatRentalRequest.new(cat_rental_request_params)
      if @rental_request.save
        redirect_to cat_url(@rental_request.cat)
      else
        flash.now[:errors] = @rental_request.errors.full_messages
        render :new
      end
    end

  def approve
    @rental_request = CatRentalRequest.find(params[:id])

    @rental_request.approve!
    redirect_to cat_url(@rental_request.cat)
  end

  def deny
    @rental_request = CatRentalRequest.find(params[:id])

    @rental_request.deny!

    redirect_to cat_url(@rental_request.cat)

  end




  private




  def cat_rental_request_params
    params.require(:cat_rental_request)
      .permit(:cat_id, :end_date, :start_date, :status)
  end

end
