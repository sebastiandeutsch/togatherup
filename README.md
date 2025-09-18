# ToGatherUp

ToGatherUp is a Rails 8 application for planning gatherings with friends. It focuses on quick coordination with a “traffic-light” flow — pick a time, let everyone vote **green / yellow / red**, and see at a glance which idea works best.

The UI leans into a dark, neon-accented aesthetic inspired by the product brief: refined rounded corners, generous whitespace, subtle shadows, and purple/turquoise highlights.

## Features

- **Account onboarding** — email + password registration with secure password hashing (`bcrypt`), profile editing, and avatar upload via Active Storage.
- **Availability planner** — capture recurring day/time windows so group suggestions respect when people are free.
- **Group workspaces** — create and manage friend groups, view members, and handle membership (owners can remove members; non-owners can leave).
- **Invite links** — owners generate shareable invitation URLs (optionally email-tagged). Invited users can accept after signing in.
- **ToGatherUp events** — nested under groups with descriptions, “everyone required” and “bring something” flags, plus multiple time suggestions.
- **Traffic-light votes** — each time window shows the counts of availability votes (green/amber/red) and lets members toggle their status or attach a quick note.
- **Dark-mode Tailwind UI** — custom layout, hero section, dashboards, and forms use Tailwind utility classes with Heroicons and Unsplash imagery.

## Tech Stack

- **Ruby on Rails 8** with Propshaft assets and Turbo/Stimulus via import maps.
- **TailwindCSS** using the `tailwindcss-rails` gem (build step required).
- **Heroicon** helper for SVG icons.
- **Active Storage** for user avatars (local disk in development/test).
- **PostgreSQL** (see `config/database.yml`).

## Getting Started

> **Ruby requirement:** Rails 8 needs Ruby **≥ 3.2.0**. If your system Ruby is older, install a current version via `rbenv`, `asdf`, or `ruby-install` before continuing.

1. **Install Bundler** that matches the lockfile: `gem install bundler -v 2.7.1` (once you are on Ruby 3.2+).
2. **Install gems**: `bundle install` (or `bundle config set --local path 'vendor/bundle'` then `bundle install`).
3. **Tailwind styling**
   - The current layout loads Tailwind via the official CDN so you get the full experience instantly.
   - Once you upgrade Ruby and install dependencies, you can swap to a local build by running:
     ```bash
     bin/rails tailwindcss:build
     ```
     (and optionally `bin/rails tailwindcss:watch` during development). Delete the CDN script in
     `app/views/layouts/application.html.erb` once you rely on the compiled asset.
4. **Prepare the database**:
   ```bash
   bin/rails db:setup
   ```
   This runs migrations and seeds demo data (three users, a group, and a sample ToGatherUp event with votes).
5. **Start the dev server**:
   ```bash
   bin/dev
   ```
   Visit `http://localhost:3000`.

### Demo Accounts

After seeding you can sign in with any of:

| Email             | Password         |
|-------------------|------------------|
| julia@example.com | supersecure123   |
| sam@example.com   | supersecure123   |
| lina@example.com  | supersecure123   |

### Tailwind Notes

- Utility classes live in the views; a light CSS file (`app/assets/stylesheets/application.tailwind.css`) covers a few
  extras like the glass-card helper.
- `config/tailwind.config.js` mirrors the design tokens used in the CDN configuration, so swapping to a compiled build
  keeps the same visual language.
- If you add new directories with Tailwind classes later, update the `content` array before rebuilding.

## Tests

A couple of focused model tests cover critical behaviours for group membership and availability ordering:

```bash
bin/rails test test/models
```

## Key Domain Models

| Model                  | Purpose                                                   |
|------------------------|-----------------------------------------------------------|
| `User`                 | Authentication, profile, avatar, availability windows     |
| `AvailabilitySlot`     | Recurring availability by weekday and time span           |
| `Group`                | Friend circle; owner auto-joined on create                |
| `GroupMembership`      | Join table with role + joined timestamp                   |
| `GroupInvitation`      | Token-based invitation links with expiry + optional email |
| `Event`                | “ToGatherUp” proposal with description/flags              |
| `EventTimeSuggestion`  | Candidate start/end windows for an event                  |
| `EventVote`            | Member availability vote (`available/tentative/unavailable`) |

## File Uploads

Active Storage is configured for disk use in development/test. Uploaded avatars land in `storage/`. When deploying, switch `config/storage.yml` to a cloud provider and set the corresponding credentials.

## Known Limitations / Next Steps

- Tailwind build assets are not committed; run the build tasks after installing dependencies.
- Invitation emails are not sent yet — owners share the generated link manually.
- There is no pagination on group/event listings; add if groups grow large.
- Consider adding Turbo Streams for real-time vote updates.

Enjoy organising your next gathering! ✨
