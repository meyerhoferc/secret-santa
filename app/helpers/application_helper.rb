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
    "#{text} <span class=\"required\" title=\"Required\">*</span>".html_safe
  end
end
