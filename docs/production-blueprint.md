# The Boys Golf App - Version 7 Production Blueprint

## 1. Purpose
Build a hosted, mobile-friendly league management app for "The Boys" at Tashua Knolls. The app manages weekly signups, rack times, tee times, pairings, guests, reports, activity history, and yearly archives.

## 2. Core Workflow
The app runs on a rolling weekly schedule.

### Upcoming Weekend
- Shows the next weekend being played.
- Players can view all tee times and groups.
- Admins can edit/publish pairings if needed.

### Following Weekend
- Shows the following weekend already being planned/finalized.
- Players can see if they are in.
- Admins can see pending signups, rack times, tee times, and pairings.

### Signup Deadline
- Default: Thursday at 8:00 PM.
- Players mark each golf day as Playing, Out, or No Response.
- Pending list only includes No Response players.

### Rack Times
- Players can submit rack times for the Following Weekend.
- Each rack time includes:
  - Date
  - Time
  - Front/Back
  - Entered by
- Players can mark Shutout if they tried but did not get a time.
- Shutouts count only in reports, not in tee time lists.
- Admins review rack times, delete extras, and select which are used.

### Pairings
- Groups max at 4 players.
- If there are not enough tee times, the app warns the admin that more tee times are needed.
- Pairing engine should minimize repeat pairings.
- Admins can add guests.
- Admins can set Keep Together / Keep Apart rules.

## 3. User Roles

### Player
- View Player Home.
- Set availability: Playing / Out / No Response.
- Submit rack times.
- Mark shutout.
- View published tee sheets.
- View who is playing, but not who is Out or Pending.

### Admin
- Everything players can do.
- Manage players.
- Manage guests.
- Manage tee times.
- Review rack times.
- Generate and publish pairings.
- View reports.
- View activity log.
- Export/import backup.

### Commissioner
- Full admin rights.
- Manage admins.
- Manage league settings.
- Archive seasons.
- Factory reset.

## 4. Main Pages

### Dashboard
Top tiles:
- Upcoming Weekend
- Following Weekend
- Pending Signups

Other sections:
- Rack Summary
- Pairing status
- Quick actions as needed

### Player Home
- Upcoming Weekend tee sheet
- Following Weekend tee sheet/status
- Following Weekend signup controls
- Rack Time entry
- Shutout checkbox labeled only "Shutout"

### Players
- Player list
- Add/edit/deactivate players
- Role: Player/Admin/Commissioner
- Contact info
- Active/inactive status

### Rack Summary
- Admin review of submitted rack times
- Grouped by date
- Shows time, front/back, entered by
- Admin can delete unwanted times
- Admin can select rack times to become official tee times

### Pairings
- Official tee times
- Generate groups
- Manual edit support
- Publish pairings
- Enforce max 4 players per group

### Reports
- Pairing matrix
- Individual player report
- Repeat foursomes
- Rack Time Counts:
  - Entered
  - Used
  - Shutouts
- Season summary

### Activity Log
Tracks major activity:
- Signup changes
- Rack time added/deleted/used
- Shutout recorded
- Pairings generated
- Pairings published
- Guests added
- Settings changed
- Data reset/archive actions

### Archive
- View prior seasons
- Read-only season data
- Export archived season
- Restore archive if needed

### Settings
League settings:
- League name: The Boys
- App title: Golf App
- Course name: Tashua Knolls
- Footer slogan
- Signup deadline day/time
- Max players per group: 4
- Tee time interval
- Season start/end dates
- Holiday rounds
- Admin users

Data Management:
- Export Backup
- Import Backup
- Reset Demo/Test Data
- Archive Current Season
- Factory Reset with DELETE confirmation

## 5. Database Tables

### profiles
- id
- auth_user_id
- first_name
- last_name
- display_name
- email
- phone
- role
- active
- created_at

### seasons
- id
- year
- name
- start_date
- end_date
- status
- archived_at

### golf_days
- id
- season_id
- date
- day_type: regular/holiday/custom
- status: signup_open/locked/rack_open/tee_times_ready/published/completed/archived
- signup_deadline

### signups
- id
- golf_day_id
- player_id
- status: playing/out/no_response
- updated_at

### rack_times
- id
- golf_day_id
- player_id
- time
- side: front/back
- used
- created_at

### rack_shutouts
- id
- golf_day_id
- player_id
- created_at

### tee_times
- id
- golf_day_id
- time
- side
- source_rack_time_id
- sort_order

### guests
- id
- golf_day_id
- name
- host_player_id
- notes

### pairings
- id
- golf_day_id
- tee_time_id
- group_number

### pairing_players
- id
- pairing_id
- player_id
- guest_id

### pairing_rules
- id
- golf_day_id
- rule_type: keep_together/keep_apart
- player_a_id
- player_b_id
- notes

### activity_log
- id
- actor_player_id
- action_type
- description
- metadata_json
- created_at

### app_settings
- id
- key
- value_json
- updated_at

### archives
- id
- season_id
- year
- archived_data_json
- created_at

## 6. Pairing Rules
The pairing engine should:
- Never exceed 4 players per tee time.
- Warn if playing count exceeds available tee time capacity.
- Include admin-added guests.
- Prefer host/guest together unless admin overrides.
- Honor Keep Together first.
- Honor Keep Apart where possible.
- Minimize repeat pairings using season history.
- Avoid repeat foursomes where possible.
- Allow manual admin edits before publishing.

## 7. Automatic Rolling Logic
Every Monday morning:
- Determine Upcoming Weekend and Following Weekend based on current date.
- Open signup window for the appropriate following golf days.
- Keep published tee sheets visible.
- Move completed weekends forward when marked complete.

Admin should also be able to manually override statuses.

## 8. Holiday / Custom Golf Days
Season setup should allow:
- Normal Saturday/Sunday rounds.
- Memorial Day Monday.
- July 4th Friday/Monday/custom dates.
- Labor Day Monday.
- Any admin-created golf day.

## 9. Hosting Plan
Recommended stack:
- Frontend: React + TypeScript
- Styling: Tailwind CSS
- Database: Supabase PostgreSQL
- Authentication: Supabase Auth
- Hosting: Cloudflare Pages
- App type: Progressive Web App

Players can install it on phones using Add to Home Screen.

## 10. Build Phases

### Phase 1 - Production Foundation
- React app
- Supabase project
- Auth
- Roles
- Database schema
- Basic layout and routing

### Phase 2 - Core League Workflow
- Players
- Signups
- Rolling weekends
- Rack Times
- Dashboard

### Phase 3 - Pairings
- Tee time management
- Pairing engine
- Guests
- Keep together/apart
- Publish pairings

### Phase 4 - Reports and Archive
- Pairing matrix
- Rack time reports
- Activity log
- Season archive
- Data management

### Phase 5 - Hosting and Testing
- Deploy to Cloudflare Pages
- Mobile testing
- Admin testing
- Player invite testing
- Final adjustments

## 11. Current Branding
- Main title: The Boys
- Subtitle: Golf App
- Logo: Tashua Knolls logo
- Colors: maroon and gold
- Footer slogan: From the first tee to the final tab at The Nest!
