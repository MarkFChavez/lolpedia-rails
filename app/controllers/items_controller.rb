class ItemsController < ApplicationController
  before_action :initialize_client

  def index
    # Get Summoner's Rift purchasable items, optionally filtered by tag
    @items = Item.sr_purchasable.by_tag(params[:tag])
    @all_tags = Item.sr_purchasable.all_tags
    @selected_tag = params[:tag]
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
