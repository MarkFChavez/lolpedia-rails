class Item < ApplicationRecord
  validates :item_id, presence: true, uniqueness: true
  validates :name, presence: true

  # Scopes for filtering items
  scope :summoners_rift, -> { where("item_id < ?", 10000) }
  scope :purchasable_only, -> { where(purchasable: true) }
  scope :sr_purchasable, -> { summoners_rift.purchasable_only }

  # Convert database record to API response format
  def to_api_format
    {
      "id" => item_id,
      "name" => name,
      "description" => description,
      "plaintext" => plaintext,
      "gold" => gold || {},
      "stats" => stats || {},
      "tags" => tags || [],
      "image" => { "full" => image_full },
      "into" => into || [],
      "from" => self.from || []
    }
  end

  # Search items by name (case-insensitive, partial match, chainable with scopes)
  def self.search(query)
    if query.present?
      where("name ILIKE ?", "%#{sanitize_sql_like(query)}%").order(:name)
    else
      all.order(:name)
    end
  end

  # Filter items by tag (chainable with scopes)
  def self.by_tag(tag)
    scope = all
    if tag.present?
      scope = scope.where("EXISTS (SELECT 1 FROM json_array_elements_text(items.tags) AS tag_value WHERE tag_value = ?)", tag)
    end
    scope.order(:name)
  end

  # Get all unique tags from the current scope
  def self.all_tags
    # Get all item IDs in current scope
    ids = pluck(:id)
    return [] if ids.empty?

    connection.select_values(
      sanitize_sql_array([
        "SELECT DISTINCT tag_value FROM items, json_array_elements_text(items.tags) AS tag_value WHERE items.id IN (?) ORDER BY tag_value",
        ids
      ])
    )
  end

  # Identify which game mode this item belongs to
  def game_mode
    case item_id
    when 0..9999 then "Summoner's Rift"
    when 220000..229999 then "ARAM"
    when 320000..329999 then "Special Mode"
    when 440000..449999 then "Arena S1"
    when 660000..669999 then "Arena S2+"
    else "Other"
    end
  end
end
