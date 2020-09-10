class EmailValidator < ActiveModel::Validator
  def validate record
    return unless record.email == record.password

    record.errors[:email] << I18n.t("email_resemble_password")
  end
end
