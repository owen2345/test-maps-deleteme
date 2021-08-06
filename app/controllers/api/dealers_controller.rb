# frozen_string_literal: true

module Api
  class DealersController < BaseController

    # TODO: add filtering
    # @api api/dealers.json
    def index
      res = Dealer.page(params[:page]).per(params[:per_page] || ITEMS_PER_PAGE)
      render json: res.as_json(only: %i[id name latitude longitude])
    end

    # @api api/dealers/1.json
    def show
      dealer = Dealer.find(params[:id])
      render json: dealer.as_json
    rescue ActiveRecord::RecordNotFound
      render json: { error: 'Dealer not found' }, status: :unprocessable_entity
    end
  end
end
