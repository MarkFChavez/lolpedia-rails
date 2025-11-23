class Champion < ApplicationRecord
  validates :champion_id, presence: true, uniqueness: true
  validates :name, presence: true

  # Convert database record to API response format
  def to_api_format
    {
      "id" => champion_id,
      "name" => name,
      "title" => title,
      "blurb" => blurb,
      "tags" => tags || [],
      "passive" => passive_data,
      "spells" => spells_data
    }
  end

  # Search champions by name (case-insensitive, partial match)
  def self.search(query)
    where("name LIKE ?", "%#{sanitize_sql_like(query)}%").order(:name)
  end
end
