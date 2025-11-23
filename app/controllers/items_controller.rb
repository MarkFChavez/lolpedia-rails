class ItemsController < ApplicationController
  before_action :initialize_client

  def index
    # Homepage - empty state until search is performed
  end

  def search
    if params[:query].present?
      begin
        query = params[:query].strip

        # Search items from database
        matching_items = Item.sr_purchasable.search(query)

        case matching_items.size
        when 0
          # No matches found
          render :index
        when 1
          # Exactly one match - show it automatically
          redirect_to item_path(matching_items.first.item_id)
        else
          # Multiple matches - show them
          @items = matching_items
          render :index
        end
      rescue => e
        flash.now[:alert] = "An error occurred while searching. Please try again."
        render :index
      end
    else
      render :index
    end
  end

  def show
    # Find only Summoner's Rift purchasable items
    item = Item.sr_purchasable.find_by(item_id: params[:id])
    if item
      @item = item.to_api_format
    else
      redirect_to items_path, alert: "Item not found."
    end
  end

  private

  def initialize_client
    @client = LolDataFetcher::Client.new
  end
end
