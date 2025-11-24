class SummonerSpellsController < ApplicationController
  before_action :initialize_client

  def index
    # Display only summoner spells available in Classic mode
    # Filter in Ruby for SQLite compatibility
    @summoner_spells = SummonerSpell.all.select { |spell| spell.modes&.include?("CLASSIC") }.sort_by(&:name)
  end

  def show
    spell = SummonerSpell.find_by(spell_id: params[:id])
    if spell
      @spell = spell.to_api_format
    else
      redirect_to summoner_spells_path, alert: "Summoner spell not found."
    end
  end

  private

  def initialize_client
    @client = LolDataFetcher::Client.new
  end
end
