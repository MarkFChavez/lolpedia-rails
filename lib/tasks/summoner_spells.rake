namespace :summoner_spells do
  desc "Sync all summoner spells from the Data Dragon API"
  task sync: :environment do
    puts "Starting summoner spell synchronization..."

    client = LolDataFetcher::Client.new

    # Fetch and store the latest patch version
    begin
      latest_version = client.versions.latest
      Setting.find_or_create_by(key: 'patch_version').update(value: latest_version)
      puts "Updated patch version to: #{latest_version}"
    rescue => e
      puts "Warning: Could not fetch patch version: #{e.message}"
    end

    # Fetch all summoner spells using the gem
    all_spells_response = client.summoner_spells.all
    spells_data = all_spells_response["data"]

    created_count = 0
    updated_count = 0
    failed_count = 0

    spells_data.each_with_index do |(spell_key, spell_data), index|
      begin
        puts "[#{index + 1}/#{spells_data.size}] Syncing #{spell_data['name']}..."

        # Find or initialize summoner spell record
        spell = SummonerSpell.find_or_initialize_by(spell_id: spell_key)

        # Update spell attributes
        spell.assign_attributes(
          key: spell_data["key"],
          name: spell_data["name"],
          description: spell_data["description"],
          cooldown: spell_data["cooldown"] || [],
          range: spell_data["range"] || [],
          image_full: spell_data.dig("image", "full"),
          summoner_level: spell_data["summonerLevel"],
          modes: spell_data["modes"] || [],
          synced_at: Time.current
        )

        if spell.save
          if spell.previously_new_record?
            created_count += 1
          else
            updated_count += 1
          end
        else
          puts "  ❌ Failed to save #{spell_data['name']}: #{spell.errors.full_messages.join(', ')}"
          failed_count += 1
        end
      rescue => e
        puts "  ❌ Error syncing #{spell_data['name']}: #{e.message}"
        failed_count += 1
      end
    end

    puts "\n" + "=" * 50
    puts "Summoner Spell Synchronization Complete!"
    puts "=" * 50
    puts "Created: #{created_count}"
    puts "Updated: #{updated_count}"
    puts "Failed: #{failed_count}"
    puts "Total: #{spells_data.size}"
    puts "=" * 50
  end
end
