require "test_helper"

class CarePlanTest < ActiveSupport::TestCase
  test "latest? is true only for the most recently created plan for that recipient" do
    care_recipient = care_recipients(:one)
    older = CarePlan.create!(care_recipient: care_recipient, created_by: users(:one), created_on: 6.months.ago.to_date)
    newer = CarePlan.create!(care_recipient: care_recipient, created_by: users(:one), created_on: Date.current)

    assert newer.latest?
    assert_not older.latest?
  end

  test "rejects a goal with no issue or goals filled in, but keeps one with content" do
    care_plan = CarePlan.new(
      care_recipient: care_recipients(:one),
      created_by: users(:one),
      created_on: Date.current,
      care_plan_goals_attributes: {
        "0" => { issue: "", long_term_goal: "", short_term_goal: "" },
        "1" => { issue: "入浴に不安がある", long_term_goal: "安全に入浴できる", short_term_goal: "見守りで入浴できる" }
      }
    )

    assert care_plan.save
    assert_equal 1, care_plan.care_plan_goals.count
    assert_equal "入浴に不安がある", care_plan.care_plan_goals.first.issue
  end

  test "rejects a service with no content" do
    care_plan = CarePlan.create!(care_recipient: care_recipients(:one), created_by: users(:one), created_on: Date.current)
    goal = care_plan.care_plan_goals.create!(issue: "テスト課題")

    goal.update!(care_plan_services_attributes: {
      "0" => { content: "" },
      "1" => { content: "通所介護", category: "通所介護" }
    })

    assert_equal 1, goal.care_plan_services.count
    assert_equal "通所介護", goal.care_plan_services.first.content
  end
end
