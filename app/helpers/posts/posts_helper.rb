module Posts::PostsHelper
  def load_dropdown model
    model.pluck :name, :id
  end

  # rubocop:disable Metrics/AbcSize
  def number_to_price price
    if price < Settings.second_price_limit
      price.to_s + Settings.second_price
    elsif price.to_s.last(Settings.second_price_count).sub(/^0+/, "").blank?
      (price / Settings.second_price_limit).to_s + Settings.first_price
    else
      (price / Settings.second_price_limit).to_s + Settings.first_price +
        price.to_s.last(Settings.second_price_count).sub(/^0+/, "") +
        Settings.second_price
    end
  end
  # rubocop:enable Metrics/AbcSize

  def option_select form_object, object, object_id
    form_object.select(
      object_id,
      options_for_select(
        load_dropdown(object),
        selected: load_selected(form_object)
      ), {}, class: "form-control"
    )
  end

  def status_text status
    status ? t("admins.active") : t("admins.inactive")
  end

  def load_selected form_object
    form_object.object.id
  end
end
