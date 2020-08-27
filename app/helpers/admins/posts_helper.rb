module Admins::PostsHelper
  def post_activated_text activated
    activated ? t("admins.active") : t("admins.inactive")
  end
end
