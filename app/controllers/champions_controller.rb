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
          render :index
        when 1
          # Exactly one match - redirect to show page
          champion = matching_champions.first
          redirect_to champion_path(champion.champion_id)
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
    champion = Champion.find_by!(champion_id: params[:id])
    @champion = champion.to_api_format
  rescue ActiveRecord::RecordNotFound
    redirect_to root_path, alert: "Champion not found."
  end

  private

  def initialize_client
    @client = LolDataFetcher::Client.new
  end
end
