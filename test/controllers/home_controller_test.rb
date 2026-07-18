require "test_helper"

class HomeControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    sign_in users(:one)
    get root_url
    assert_response :success
  end

  test "admin sees all care recipients and the registration button" do
    sign_in users(:one)
    get root_url
    assert_response :success
    assert_select ".recipient-picker-card", count: CareRecipient.count
    assert_select "a", text: "対象者を登録"
  end

  test "staff does not see the registration button but does see today's visits" do
    sign_in users(:staff_one)
    VisitReport.create!(care_recipient: care_recipients(:one), user: users(:staff_one), visit_type: visit_types(:one),
                         visited_at: Time.current, status: :planned)

    get root_url
    assert_response :success
    assert_select "a", { text: "対象者を登録", count: 0 }
    assert_select "h2", text: "本日の訪問予定"
    assert_select ".today-visit-list li", minimum: 1
  end

  test "family with exactly one linked recipient is redirected straight to the menu" do
    sign_in users(:family_one)
    get root_url
    assert_redirected_to show_menu_path(care_recipient_id: care_recipients(:one).id)
  end

  test "family with no linked recipients sees the (empty) picker instead of being redirected" do
    sign_in users(:family_two)
    get root_url
    assert_response :success
    assert_select ".recipient-picker-card", count: 0
  end

  test "show_menu shows the admin-specific action set" do
    sign_in users(:one)
    get show_menu_path(care_recipient_id: care_recipients(:one).id)
    assert_response :success
    assert_select "a", text: "訪問記録を登録"
    assert_select "a", text: "対象者情報を編集"
  end

  test "show_menu shows the family-specific action set only" do
    sign_in users(:family_one)
    get show_menu_path(care_recipient_id: care_recipients(:one).id)
    assert_response :success
    assert_select "a", text: "対象者の情報を見る"
    assert_select "a", { text: "訪問記録を登録", count: 0 }
    assert_select "a", { text: "対象者情報を編集", count: 0 }
  end

  test "show_menu still rejects a family member viewing an unrelated recipient" do
    sign_in users(:family_one)
    get show_menu_path(care_recipient_id: care_recipients(:two).id)
    assert_redirected_to root_path
  end
end
