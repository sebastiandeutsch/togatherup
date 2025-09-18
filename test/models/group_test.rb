require "test_helper"

class GroupTest < ActiveSupport::TestCase
  test "owner is added as member on create" do
    owner = User.create!(name: "Owner", email: "owner@example.com", password: "averysecurepwd", password_confirmation: "averysecurepwd")
    assert_difference -> { GroupMembership.count }, 1 do
      Group.create!(name: "Crew", owner: owner)
    end
  end

  test "add_member creates membership" do
    owner = User.create!(name: "Owner", email: "owner2@example.com", password: "averysecurepwd", password_confirmation: "averysecurepwd")
    group = Group.create!(name: "Friends", owner: owner)
    member = User.create!(name: "Member", email: "member@example.com", password: "averysecurepwd", password_confirmation: "averysecurepwd")

    assert_difference -> { group.members.count }, 1 do
      group.add_member(member)
    end

    assert group.member?(member)
  end
end
