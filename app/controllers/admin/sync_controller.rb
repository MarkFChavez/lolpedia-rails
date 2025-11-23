class Admin::SyncController < AdminController
  def champions
    begin
      # Clear the task to allow re-running
      Rake::Task["champions:sync"].reenable

      # Run the sync task
      Rake::Task["champions:sync"].invoke

      redirect_to admin_dashboard_path, notice: "Champions synced successfully! Total: #{Champion.count}"
    rescue => e
      redirect_to admin_dashboard_path, alert: "Champion sync failed: #{e.message}"
    end
  end

  def items
    begin
      # Clear the task to allow re-running
      Rake::Task["items:sync"].reenable

      # Run the sync task
      Rake::Task["items:sync"].invoke

      redirect_to admin_dashboard_path, notice: "Items synced successfully! Total: #{Item.count} (#{Item.sr_purchasable.count} SR purchasable)"
    rescue => e
      redirect_to admin_dashboard_path, alert: "Item sync failed: #{e.message}"
    end
  end
end
