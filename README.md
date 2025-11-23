# League Directory

Your complete League of Legends champion & item reference.

**Know your enemy, claim victory • Patch 15.23.1**

A Rails application that provides a searchable database of League of Legends champions and items, powered by the [Data Dragon API](https://developer.riotgames.com/docs/lol#data-dragon).

## Features

- 🔍 **Search Champions**: Find detailed information about 172+ champions
- 🗡️ **Search Items**: Browse 298 Summoner's Rift purchasable items
- 📊 **Ability Details**: View passive abilities, Q/W/E/R skills, and stats
- 🏗️ **Item Build Paths**: See what items build from/into
- 🔄 **Auto-Updated**: Sync latest patch data from Riot's Data Dragon API
- 🔐 **Admin Panel**: Secure admin interface for data synchronization

## Tech Stack

- **Framework**: Ruby on Rails 8.0.4
- **Database**: SQLite3
- **Styling**: Tailwind CSS v4 with custom League of Legends theme
- **Data Source**: [lol_data_fetcher](https://github.com/MarkFChavez/lol_data_fetcher-ruby) gem
- **Authentication**: HTTP Basic Auth for admin panel
- **Environment Variables**: dotenv-rails

## Prerequisites

- Ruby 3.2.2
- Rails 8.0.4
- Bundler
- SQLite3

## Getting Started

### 1. Clone the Repository

```bash
git clone <repository-url>
cd lolpedia_ai
```

### 2. Install Dependencies

```bash
bundle install
```

### 3. Configure Environment Variables

Create a `.env` file in the project root:

```bash
cp .env.example .env
```

Edit `.env` and set secure admin credentials:

```env
ADMIN_USERNAME=your_admin_username
ADMIN_PASSWORD=your_secure_password
```

⚠️ **Important**: Change these from the defaults before deploying to production!

### 4. Set Up the Database

Create and migrate the database:

```bash
rails db:create
rails db:migrate
```

This creates tables for:
- `champions` - League of Legends champion data
- `items` - League of Legends item data
- `settings` - Application settings (stores current patch version)

### 5. Populate Champions and Items

You have two options for populating the database:

#### Option A: Using Rake Tasks (Recommended)

Sync all champions from the Data Dragon API (~172 champions):

```bash
rails champions:sync
```

Sync all items from the Data Dragon API (~640 items, 298 SR purchasable):

```bash
rails items:sync
```

**Note**: Each sync task takes 1-3 minutes and will:
- Fetch the latest patch version from Riot's API
- Download all champion/item data
- Store it in the local database
- Show progress for each record

#### Option B: Using Admin Panel

1. Start the Rails server:
   ```bash
   bin/dev
   ```

2. Navigate to the admin panel:
   ```
   http://localhost:3000/admin
   ```

3. Log in with your admin credentials from `.env`

4. Click the sync buttons:
   - **Sync Champions** - Syncs all champions
   - **Sync Items** - Syncs all items

### 6. Build Tailwind CSS

Compile the Tailwind CSS styles:

```bash
rails tailwindcss:build
```

### 7. Start the Application

```bash
bin/dev
```

Visit `http://localhost:3000` to see the application!

## Usage

### Searching Champions

1. Go to the homepage (`/`)
2. Enter a champion name (e.g., "Ahri", "Yasuo")
3. Press Enter or wait for auto-submit
4. If multiple matches are found, select the champion you want
5. If exactly one match is found, you'll be taken directly to the champion page

### Searching Items

1. Click "Items" in the navigation
2. Enter an item name (e.g., "Infinity Edge", "boots")
3. Press Enter
4. Browse results or view a specific item

### Admin Panel

Access the admin panel at `/admin` to:
- View sync statistics (champion/item counts, last sync times)
- Trigger manual data synchronization
- Update to the latest patch version

## Data Synchronization

### When to Sync

Sync your data when:
- Setting up the application for the first time
- A new League of Legends patch is released
- You want to ensure you have the latest champion/item data

### How Syncing Works

Both sync tasks:
1. Fetch the current patch version from `https://ddragon.leagueoflegends.com/api/versions.json`
2. Store the version in the `settings` table
3. Download all champion/item data from the Data Dragon API
4. Create or update records in the database
5. Track sync timestamps (`synced_at`)

### Sync Output

```bash
$ rails champions:sync
Starting champion sync...
Updated patch version to: 15.23.1
Found 172 champions to sync
[1/172] Syncing Aatrox...
[2/172] Syncing Ahri...
...
Sync complete!
Created: 172
Updated: 0
Failed: 0
Total: 172
```

## Project Structure

```
lolpedia_ai/
├── app/
│   ├── controllers/
│   │   ├── admin/          # Admin panel controllers
│   │   ├── champions_controller.rb
│   │   └── items_controller.rb
│   ├── models/
│   │   ├── champion.rb
│   │   ├── item.rb
│   │   └── setting.rb
│   ├── views/
│   │   ├── admin/          # Admin panel views
│   │   ├── champions/
│   │   ├── items/
│   │   └── shared/         # Header, nav, footer
│   └── helpers/
│       └── application_helper.rb  # current_patch_version helper
├── db/
│   ├── migrate/            # Database migrations
│   └── schema.rb
├── lib/tasks/
│   ├── champions.rake      # Champions sync task
│   └── items.rake          # Items sync task
└── .env                    # Environment variables (git-ignored)
```

## Database Schema

### Champions Table
- `champion_id` (string) - Champion identifier (e.g., "Ahri")
- `name` (string) - Champion name
- `title` (string) - Champion title
- `blurb` (text) - Champion description
- `tags` (json) - Champion roles (e.g., ["Mage", "Assassin"])
- `passive_data` (json) - Passive ability details
- `spells_data` (json) - Q/W/E/R ability details
- `image_full` (string) - Image filename
- `synced_at` (datetime) - Last sync timestamp

### Items Table
- `item_id` (integer) - Item ID from API
- `name` (string) - Item name
- `description` (text) - Item description (HTML)
- `plaintext` (text) - Simple description
- `gold` (json) - Cost information
- `stats` (json) - Item stats
- `tags` (json) - Item categories
- `purchasable` (boolean) - Can be bought in shop
- `into` (json) - Items this builds into
- `from` (json) - Component items
- `synced_at` (datetime) - Last sync timestamp

### Settings Table
- `key` (string) - Setting name (e.g., "patch_version")
- `value` (string) - Setting value (e.g., "15.23.1")

## Development

### Running Tests

```bash
rails test
```

### Code Style

This project uses RuboCop with Rails Omakase configuration:

```bash
rubocop
```

### Background Tasks

The application includes Solid Queue for background job processing (currently unused but available for future async sync tasks).

## Deployment

### Environment Variables

Ensure these are set in your production environment:
- `ADMIN_USERNAME` - Admin panel username
- `ADMIN_PASSWORD` - Admin panel password (use a strong password!)

### Database

For production, consider migrating from SQLite to PostgreSQL:

1. Add PostgreSQL gem to Gemfile
2. Update `config/database.yml`
3. Re-run migrations
4. Sync data

### Assets

Precompile assets before deployment:

```bash
rails assets:precompile
rails tailwindcss:build
```

## API Rate Limits

The Data Dragon API is public and does not require an API key. However:
- Be respectful with sync frequency
- Sync tasks include delays to avoid overwhelming the API
- Typically sync once per patch (every 2 weeks)

## Contributing

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

## License

This project is licensed under the MIT License.

## Acknowledgments

- **Riot Games** - For the Data Dragon API and League of Legends
- **[lol_data_fetcher](https://github.com/MarkFChavez/lol_data_fetcher-ruby)** - Ruby gem for accessing Data Dragon
- **Tailwind CSS** - For the styling framework

## Disclaimer

League Directory isn't endorsed by Riot Games and doesn't reflect the views or opinions of Riot Games or anyone officially involved in producing or managing Riot Games properties. Riot Games, and all associated properties are trademarks or registered trademarks of Riot Games, Inc.

---

Made with ❤️ for the League of Legends community
