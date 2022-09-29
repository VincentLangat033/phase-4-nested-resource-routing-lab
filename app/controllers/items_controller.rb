class ItemsController < ApplicationController
  rescue_from ActiveRecord::RecordNotFound, with: :render_not_found

  def index
    if params[:user_id]
			user = User.find(params[:user_id])
			items = user.items
		else
			items = Item.all.includes([:user])
		end
    render json: items, include: :user
    
  end
  def show
		item = Item.find(params[:id])
		render json: item, status: :ok
	end

	def create
		new_item = Item.new(item_params)
		user = User.find(params[:user_id])
		user.items << new_item
		render json: new_item, status: :created
	end

  private

	def render_not_found
		render json: {error: "We could not find what you are looking for"}, status: :not_found
	end

	def item_params
		params.permit(:name, :description, :price, :user_id)
	end

end
