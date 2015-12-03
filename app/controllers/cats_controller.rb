class CatsController < ApplicationController

  before_action :require_user!, only: [:new, :create, :edit, :update]
  before_action :validate_ownership, only: [:edit, :update]


  def index
    @cats = Cat.all
    render :index
  end

  def show
    @cat = Cat.find(params[:id])
    render :show
  end

  def new
    @cat = Cat.new
    render :new
    #/cats/new
    #show a form to craete a new object
  end

  def create
    @cat = current_user.cats.new(cat_params)
    if @cat.save
      redirect_to cat_url(@cat)
    else
      flash.now[:errors] = @cat.errors.full_messages
      render :new
    end
  end

  def edit
    @cat = current_user.cats.find(params[:id])
    render :edit
  end

  def update
    @cat = current_user.cats.find(params[:id])
    if @cat.update(cat_params)
      redirect_to cat_url(@cat)
    else
      render :edit
    end
  end


  private

  def cat_params
    params.require(:cat).permit(:name, :birth_date, :color, :sex, :description)
  end

  def validate_ownership
    cat = Cat.find(params[:id])
    unless current_user.cats.include?(cat)
      flash.now[:errors] = "You cannot edit this cat. You are not the owner"
      redirect_to cats_url
    end
  end

end
