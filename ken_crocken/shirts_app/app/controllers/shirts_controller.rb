class ShirtsController < ApplicationController

  def index
    if params[:q]
      @my_shirts = Shirt.search_shirt(params[:q])
    else
      @my_shirts = Shirt.all
    end
  end

  def new
    @shirt = Shirt.new
  end

  def create
    @shirt = Shirt.new(shirt_params)
    if @shirt.save
      redirect_to shirts_path
    else
      render 'new'
    end
  end

  def edit
    @shirt = Shirt.find(params[:id])
  end

  def update
    @shirt = Shirt.find(params[:id])
    if @shirt.update(shirt_params)
      redirect_to shirts_path
    else
      render 'edit'
    end   
  end

  private

    def shirt_params
      params.require(:shirt).permit(:name, :description)
    end
end
