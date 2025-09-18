require "test_helper"

class AvailabilitySlotTest < ActiveSupport::TestCase
  setup do
    @user = User.create!(name: "Availability Owner", email: "availability@example.com", password: "averysecurepwd", password_confirmation: "averysecurepwd")
  end

  test "invalid when end is before start" do
    slot = AvailabilitySlot.new(user: @user, day_of_week: :monday, starts_at: "18:00", ends_at: "15:00")

    assert_not slot.valid?
    assert_includes slot.errors[:ends_at], "must be after start time"
  end

  test "ordered scope sorts by day then start time" do
    slot_a = AvailabilitySlot.create!(user: @user, day_of_week: :tuesday, starts_at: "19:00", ends_at: "21:00")
    slot_b = AvailabilitySlot.create!(user: @user, day_of_week: :monday, starts_at: "12:00", ends_at: "14:00")

    assert_equal [slot_b, slot_a], AvailabilitySlot.ordered.to_a
  end
end
