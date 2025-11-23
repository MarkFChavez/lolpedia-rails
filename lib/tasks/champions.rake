namespace :champions do
  desc "Sync all champions from the Data Dragon API"
  task sync: :environment do
    puts "Starting champion sync..."

    client = LolDataFetcher::Client.new

    # Fetch and store the latest patch version
    begin
      require 'net/http'
      require 'json'
      uri = URI('https://ddragon.leagueoflegends.com/api/versions.json')
      response = Net::HTTP.get(uri)
      versions = JSON.parse(response)
      latest_version = versions.first
      Setting.find_or_create_by(key: 'patch_version').update(value: latest_version)
      puts "Updated patch version to: #{latest_version}"
    rescue => e
      puts "Warning: Could not fetch patch version: #{e.message}"
    end

    # Fetch all champions (summary data)
    all_champions_response = client.champions.all
    champions_data = all_champions_response["data"]

    total = champions_data.size
    created_count = 0
    updated_count = 0
    failed_count = 0

    puts "Found #{total} champions to sync"

    champions_data.each_with_index do |(champion_key, summary_data), index|
      begin
        print "\r[#{index + 1}/#{total}] Syncing #{summary_data['name']}...".ljust(80)

        # Fetch detailed data for this champion
        detailed_response = client.champions.find(champion_key)
        detailed_data = detailed_response["data"][champion_key]

        # Find or create champion record
        champion = Champion.find_or_initialize_by(champion_id: detailed_data["id"])
        is_new = champion.new_record?

        # Update attributes
        champion.assign_attributes(
          name: detailed_data["name"],
          title: detailed_data["title"],
          blurb: detailed_data["blurb"],
          tags: detailed_data["tags"],
          passive_data: detailed_data["passive"],
          spells_data: detailed_data["spells"],
          image_full: detailed_data["id"], # Store the ID for image URL construction
          synced_at: Time.current
        )

        if champion.save
          if is_new
            created_count += 1
          else
            updated_count += 1
          end
        else
          failed_count += 1
          puts "\nFailed to save #{detailed_data['name']}: #{champion.errors.full_messages.join(', ')}"
        end

      rescue => e
        failed_count += 1
        puts "\nError syncing #{summary_data['name']}: #{e.message}"
      end
    end

    puts "\n\nSync complete!"
    puts "Created: #{created_count}"
    puts "Updated: #{updated_count}"
    puts "Failed: #{failed_count}"
    puts "Total: #{total}"
  end
end
