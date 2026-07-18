require "test_helper"

class CarePlansControllerTest < ActionDispatch::IntegrationTest
  setup do
    @care_recipient = care_recipients(:one)
    @care_plan = care_plans(:one)
  end

  test "admin can view the index" do
    sign_in users(:one)
    get care_recipient_care_plans_url(@care_recipient)
    assert_response :success
  end

  test "family can view but not create a care plan" do
    sign_in users(:family_one)

    get care_recipient_care_plans_url(@care_recipient)
    assert_response :success

    get new_care_recipient_care_plan_url(@care_recipient)
    assert_redirected_to root_path
  end

  test "staff can view but not create a care plan" do
    sign_in users(:staff_one)

    get care_recipient_care_plans_url(@care_recipient)
    assert_response :success

    assert_no_difference("CarePlan.count") do
      post care_recipient_care_plans_url(@care_recipient), params: {
        care_plan: { created_on: Date.current, office_name: "テスト事業所" }
      }
    end
    assert_redirected_to root_path
  end

  test "care_manager can create a care plan with nested goals and services" do
    sign_in users(:care_manager_one)

    assert_difference(["CarePlan.count", "CarePlanGoal.count", "CarePlanService.count"], 1) do
      post care_recipient_care_plans_url(@care_recipient), params: {
        care_plan: {
          created_on: Date.current,
          office_name: "テスト居宅介護支援事業所",
          policy_summary: "安心して自宅で生活を続けられるよう支援する",
          family_intention: "自宅で暮らし続けたい",
          care_plan_goals_attributes: {
            "0" => {
              issue: "入浴に不安がある",
              long_term_goal: "安全に入浴できる",
              long_term_goal_period: "6ヶ月",
              short_term_goal: "見守りのもと入浴できる",
              short_term_goal_period: "3ヶ月",
              care_plan_services_attributes: {
                "0" => {
                  content: "通所介護での入浴介助",
                  category: "通所介護",
                  provider: "デイサービスひまわり",
                  frequency: "週2回",
                  period: "6ヶ月"
                }
              }
            }
          }
        }
      }
    end

    created = @care_recipient.care_plans.find_by(office_name: "テスト居宅介護支援事業所")
    assert created, "expected a care plan with the submitted office_name to exist"
    assert_equal users(:care_manager_one), created.created_by
    assert_redirected_to care_recipient_care_plan_url(@care_recipient, created)
  end

  test "blank goal rows are not persisted" do
    sign_in users(:one)

    assert_difference("CarePlan.count") do
      assert_no_difference("CarePlanGoal.count") do
        post care_recipient_care_plans_url(@care_recipient), params: {
          care_plan: {
            created_on: Date.current,
            care_plan_goals_attributes: { "0" => { issue: "", long_term_goal: "", short_term_goal: "" } }
          }
        }
      end
    end
  end

  test "show renders the weekly grid derived from active recurring schedules" do
    sign_in users(:one)
    recurring_schedules(:one).update!(active: true)

    get care_recipient_care_plan_url(@care_recipient, @care_plan)
    assert_response :success
    assert_select ".care-plan-doc", 1
  end

  test "only admin or care_manager can destroy a care plan" do
    sign_in users(:staff_one)
    assert_no_difference("CarePlan.count") do
      delete care_recipient_care_plan_url(@care_recipient, @care_plan)
    end
    assert_redirected_to root_path

    sign_in users(:one)
    assert_difference("CarePlan.count", -1) do
      delete care_recipient_care_plan_url(@care_recipient, @care_plan)
    end
  end
end
