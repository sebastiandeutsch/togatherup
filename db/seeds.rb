# frozen_string_literal: true

# Basic sample data to explore the application during development.
return if Rails.env.production?

puts "Seeding ToGatherUp sample data..."

ActiveRecord::Base.transaction do
  EventVote.delete_all
  EventTimeSuggestion.delete_all
  Event.delete_all
  GroupInvitation.delete_all
  GroupMembership.delete_all
  Group.delete_all
  AvailabilitySlot.delete_all
  User.delete_all

  passwords = "supersecure123"

  users = {
    julia: User.create!(
      name: "Julia Rivers",
      email: "julia@example.com",
      password: passwords,
      password_confirmation: passwords,
      bio: "Weekend hikes, coffee crawls, and impromptu road trips."
    ),
    sam: User.create!(
      name: "Sam Ortega",
      email: "sam@example.com",
      password: passwords,
      password_confirmation: passwords,
      bio: "Board game night host and taco enthusiast."
    ),
    lina: User.create!(
      name: "Lina Park",
      email: "lina@example.com",
      password: passwords,
      password_confirmation: passwords,
      bio: "Always down for a sunset picnic with good playlists."
    )
  }

  users.each_value do |user|
    AvailabilitySlot.create!(user:, day_of_week: :friday, starts_at: "18:00", ends_at: "22:00")
    AvailabilitySlot.create!(user:, day_of_week: :saturday, starts_at: "10:00", ends_at: "15:00")
  end

  crew = Group.create!(
    owner: users[:julia],
    name: "Trailblazers",
    description: "Friends who say yes to last-minute adventures and cozy after-hike hangouts."
  )

  crew.add_member(users[:sam])
  crew.add_member(users[:lina])

  brunch = crew.events.create!(
    creator: users[:julia],
    name: "Canyon Lookout Brunch",
    description: "Catch sunrise, share thermos coffee, and plan the summer road trip.",
    require_everyone: true,
    requires_contribution: true,
    time_suggestions_attributes: [
      { starts_at: 3.days.from_now.change(hour: 9), ends_at: 3.days.from_now.change(hour: 12) },
      { starts_at: 4.days.from_now.change(hour: 10), ends_at: 4.days.from_now.change(hour: 13) }
    ]
  )

  brunch.time_suggestions.each do |suggestion|
    users.each_value do |user|
      status = %w[available tentative unavailable].sample
      suggestion.votes.create!(user:, status:)
    end
  end
end

puts "Seed data ready."
