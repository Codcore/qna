module QuestionsHelper
  def set_validation_errors(object)
    object.errors.full_messages.join('|')
  end

  def validation_errors_message
    html = content_tag :h2, t('shared.flash.validation_error.header')
    html += tag.hr
    html += tag.ul
    flash[:validation_error].split('|').each do |error|
      html += content_tag :li, error
    end
    html
  end
end
