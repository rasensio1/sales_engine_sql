module FindByX
  def find_by_id(match)
    find_by(column_name(__callee__), match)
  end

  def find_all_by_id(match)
    find_all_by(column_name(__callee__), match)
  end

  def find_by_item_id(match)
    find_by(column_name(__callee__), match)
  end

  def find_all_by_item_id(match)
    find_by(column_name(__callee__), match)
  end

  def find_by_invoice_id(match)
    find_by(column_name(__callee__), match)
  end

  def find_all_by_invoice_id(match)
    find_by(column_name(__callee__), match)
  end

  def find_by_quantity(match)
    find_by(column_name(__callee__), match)
  end

  def find_all_by_quantity(match)
    find_by(column_name(__callee__), match)
  end

  def find_by_first_name(match)
    find_by(column_name(__callee__), match)
  end

  def find_all_by_first_name(match)
    find_all_by(column_name(__callee__), match)
  end

  def find_by_last_name(match)
    find_by(column_name(__callee__), match)
  end

  def find_all_by_last_name(match)
    find_all_by(column_name(__callee__), match)
  end

  def find_by_created_at(match)
    find_by(column_name(__callee__), match)
  end

  def find_all_by_created_at(match)
    find_all_by(column_name(__callee__), match)
  end

  def find_by_updated_at(match)
    find_by(column_name(__callee__), match)
  end

  def find_all_by_updated_at(match)
    find_all_by(column_name(__callee__), match)
  end

  def find_by_quantity(match)
    find_by(column_name(__callee__), match)
  end

  def find_all_by_quantity(match)
    find_all_by(column_name(__callee__), match)
  end

  def find_by_unit_price(match)
    find_by(column_name(__callee__), match)
  end

  def find_all_by_unit_price(match)
    find_all_by(column_name(__callee__), match)
  end

  def find_by_customer_id(match)
    find_by(column_name(__callee__), match)
  end

  def find_all_by_customer_id(match)
    find_all_by(column_name(__callee__), match)
  end

  def find_by_description(match)
    find_by(column_name(__callee__), match)
  end

  def find_all_by_description(match)
    find_all_by(column_name(__callee__), match)
  end

  def find_by_merchant_id(match)
    find_by(column_name(__callee__), match)
  end

  def find_all_by_merchant_id(match)
    find_all_by(column_name(__callee__), match)
  end

  def find_by_name(match)
    find_by(column_name(__callee__), match)
  end

  def find_all_by_name(match)
    find_all_by(column_name(__callee__), match)
  end

  def find_by_status(match)
    if clean_status(match)
      find_by(column_name(__callee__), match)
    else
      nil
    end
  end

  def find_all_by_status(match)
    if clean_status(match)
      find_all_by(column_name(__callee__), match)
    else
      nil
    end
  end

  def find_by_credit_card_number(match)
    find_by(column_name(__callee__), match)
  end

  def find_all_by_credit_card_number(match)
    find_by(column_name(__callee__), match)
  end

  def find_by_credit_card_expiration_date(match)
    find_by(column_name(__callee__), match)
  end

  def find_all_by_credit_card_expiration_date(match)
    find_by(column_name(__callee__), match)
  end

  def find_by_result(match)
    find_by(column_name(__callee__), match)
  end

  def find_all_by_result(match)
    find_all_by(column_name(__callee__), match)
  end

  def column_name(method)
    if method.to_s.include?("all")
      method.slice(find_all_prefix..-1)
    else
      method.slice(find_prefix..-1)
    end
  end

  def find_prefix
    "find_by_".length
  end

  def find_all_prefix
    "find_all_by_".length
  end
end