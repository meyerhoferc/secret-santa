class Comment < ApplicationRecord
  belongs_to :commentable, polymorphic: true
  belongs_to :user

  def deletable_by_user_id?(user_id)
    if self.user_id == user.id
      true
    else
      if commentable_type == 'Group'
        group = commentable
      elsif commentable_type == 'List'
        group = commentable.group
      elsif commentable_type == 'Item'
        group = commentable.list.group
      end
      user_id == group.owner_id
    end        
  end
end
