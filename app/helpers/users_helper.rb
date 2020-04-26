module UsersHelper
  def avatar(user, size = '250x250')
    image_tag(user.avatar.variant(resize: size), class: 'user_avatar') if user.avatar.attached?
  end
end
