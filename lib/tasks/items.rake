namespace :items do
  desc "Sync all items from the Data Dragon API"
  task sync: :environment do
    puts "Starting item synchronization..."

    client = LolDataFetcher::Client.new

    # Fetch all items
    all_items_response = client.items.all
    items_data = all_items_response["data"]

    created_count = 0
    updated_count = 0
    failed_count = 0

    items_data.each_with_index do |(item_key, item_data), index|
      begin
        puts "[#{index + 1}/#{items_data.size}] Syncing #{item_data['name']}..."

        # Find or initialize item record (item_key is the numeric ID as a string)
        item = Item.find_or_initialize_by(item_id: item_key.to_i)

        # Update item attributes
        item.assign_attributes(
          name: item_data["name"],
          description: item_data["description"],
          plaintext: item_data["plaintext"],
          gold: item_data["gold"],
          stats: item_data["stats"] || {},
          tags: item_data["tags"] || [],
          image_full: item_data.dig("image", "full"),
          purchasable: item_data.fetch("gold", {}).fetch("purchasable", true),
          into: item_data["into"] || [],
          from: item_data["from"] || [],
          synced_at: Time.current
        )

        if item.save
          if item.previously_new_record?
            created_count += 1
          else
            updated_count += 1
          end
        else
          puts "  ❌ Failed to save #{item_data['name']}: #{item.errors.full_messages.join(', ')}"
          failed_count += 1
        end
      rescue => e
        puts "  ❌ Error syncing #{item_data['name']}: #{e.message}"
        failed_count += 1
      end
    end

    puts "\n" + "=" * 50
    puts "Item Synchronization Complete!"
    puts "=" * 50
    puts "Created: #{created_count}"
    puts "Updated: #{updated_count}"
    puts "Failed: #{failed_count}"
    puts "Total: #{items_data.size}"
    puts "=" * 50
  end
end
