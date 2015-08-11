module Find
  def find_by(x, match)
    found = find_all_by(x, match)
    if found.first.nil?
      false
    else
      found[0]
    end
  end

  def find_all_by(x, match)
    match = match.to_s.downcase
    records.select do |record|
      match == record.send(x).to_s.downcase
    end
  end

  def all
    records
  end

  def random
    records.sample
  end
end