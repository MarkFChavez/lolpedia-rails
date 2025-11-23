class ChampionsController < ApplicationController
  before_action :initialize_client

  def index
    # Homepage - empty state until search is performed
  end

  def search
    if params[:query].present?
      begin
        query = params[:query].downcase.strip

        # Get all champions for partial matching
        all_champions = @client.champions.all
        champions_data = all_champions["data"]

        # Find champions that match the query (partial or exact)
        matching_champions = champions_data.select do |name, _data|
          name.downcase.include?(query)
        end

        case matching_champions.size
        when 0
          # No matches found
          flash.now[:alert] = "No champions found matching '#{params[:query]}'. Please try again."
          render :index
        when 1
          # Exactly one match - show it automatically
          champion_key = matching_champions.keys.first
          # Get detailed data for this champion
          result = @client.champions.find(champion_key)
          @champion = result["data"][champion_key]
          render :show
        else
          # Multiple matches - let user choose
          @matching_champions = matching_champions.map do |key, data|
            { id: data["id"], name: data["name"], title: data["title"], tags: data["tags"] }
          end.sort_by { |c| c[:name] }
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
    # This action is only used when redirected from search with @champion set
    unless @champion
      redirect_to root_path, alert: "Please search for a champion."
    end
  end

  private

  def initialize_client
    @client = LolDataFetcher::Client.new
  end
end
