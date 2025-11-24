class Admin::DashboardController < AdminController
  def index
    @champions_count = Champion.count
    @items_count = Item.sr_purchasable.count
    @summoner_spells_count = SummonerSpell.count
    @last_champion_sync = Champion.maximum(:synced_at)
    @last_item_sync = Item.maximum(:synced_at)
    @last_summoner_spell_sync = SummonerSpell.maximum(:synced_at)

    patch_setting = Setting.find_by(key: "patch_version")
    @patch_version = patch_setting&.value || "15.23.1"
    @patch_version_updated_at = patch_setting&.updated_at
  end
end
