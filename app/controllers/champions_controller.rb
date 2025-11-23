class ChampionsController < ApplicationController
  before_action :initialize_client

  def index
    # Homepage - empty state until search is performed
  end

  def search
    if params[:query].present?
      begin
        query = params[:query].strip

        # Search champions from database
        matching_champions = Champion.search(query)

        case matching_champions.size
        when 0
          # No matches found
          flash.now[:alert] = "No champions found matching '#{params[:query]}'. Please try again."
          render :index
        when 1
          # Exactly one match - show it automatically
          champion = matching_champions.first
          @champion = champion.to_api_format
          render :show
        else
          # Multiple matches - let user choose
          @matching_champions = matching_champions.map do |champion|
            { id: champion.champion_id, name: champion.name, title: champion.title, tags: champion.tags }
          end
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
