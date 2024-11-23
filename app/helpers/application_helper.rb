module ApplicationHelper
  def full_title(page_title = "")
    base_title = "Echo"

    return base_title if page_title.empty?

    "#{base_title} | #{page_title}"
  end

  def error_message_for(object, field)
    if object.errors[field].any?
      content_tag(:p, object.errors.full_messages_for(field).first, class: "input-error-message")
    end
  end
end
