module ApplicationHelper
  def full_sentence_errors(model)
    model.errors.full_messages.to_sentence
  end
end
