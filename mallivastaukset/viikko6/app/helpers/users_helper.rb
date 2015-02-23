module UsersHelper
  def froze_button_label(user)
    return "reactivate account" if user.is_frozen?
    "froze account"
  end
end
