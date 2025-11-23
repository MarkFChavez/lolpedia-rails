class Admin::DashboardController < AdminController
  def index
    @champions_count = Champion.count
    @items_count = Item.sr_purchasable.count
    @last_champion_sync = Champion.maximum(:synced_at)
    @last_item_sync = Item.maximum(:synced_at)
  end
end
