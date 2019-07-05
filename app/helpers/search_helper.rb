module SearchHelper
  def search_result_item_url_for(item)
    case item.class.name
    when 'Question' then link_to(item.to_s, url_for(item))
    when 'Answer' then link_to(item.question.to_s, url_for(item.question))
    when 'Commentary'
      if item.commentable_type == 'Question'
        link_to(item.commentable.to_s, url_for(item.commentable))
      elsif item.commentable_type == 'Answer'
        link_to(item.commentable.question.to_s, url_for(item.commentable.question))
      end
    when 'User' then return item.email
    end
  end
end
