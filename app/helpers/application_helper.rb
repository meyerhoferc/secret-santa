module ApplicationHelper
  def full_sentence_errors(model)
    model.errors.full_messages.to_sentence
  end

  def santa_assignment_messages(model)
    join(model.messages)
  end

  def santa_assignment_errors(model)
    join(model.errors)
  end

  def join(text)
    text.join(', ').to_s
  end

  def required_label_maker(text)
    "#{text} <span class=\"required\" title=\"#{text} is required\">*</span>".html_safe
  end

  def page_title(text)
    if text.present?
      "#{text} - Secret Santa".html_safe
    else
      "Secret Santa"
    end
  end
end
