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

  # Search champions by name or ability names (case-insensitive, partial match)
  def self.search(query)
    return none if query.blank?

    sanitized_query = "%#{sanitize_sql_like(query)}%"

    where(<<-SQL, sanitized_query, sanitized_query, sanitized_query)
      name LIKE ?
      OR json_extract(passive_data, '$.name') LIKE ?
      OR EXISTS (
        SELECT 1
        FROM json_each(spells_data)
        WHERE json_extract(json_each.value, '$.name') LIKE ?
      )
    SQL
    .order(:name)
  end
end
