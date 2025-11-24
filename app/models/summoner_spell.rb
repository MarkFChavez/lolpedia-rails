class SummonerSpell < ApplicationRecord
  validates :spell_id, presence: true, uniqueness: true
  validates :name, presence: true

  def to_api_format
    {
      id: spell_id,
      key: key,
      name: name,
      description: description,
      cooldown: cooldown,
      range: range,
      image: {
        full: image_full
      },
      summonerLevel: summoner_level,
      modes: modes
    }
  end
end
