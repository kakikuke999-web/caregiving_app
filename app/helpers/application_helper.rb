module ApplicationHelper
  def value_or_unset(value)
    value.presence || content_tag(:span, "未設定", class: "text-unset")
  end
end
