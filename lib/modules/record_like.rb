require 'date'

module RecordLike
  def ==(other)
    if other.is_a?(self.class)
      self.id == other.id
    end
  end

  def columns
    self.instance_variables.map{|var| var.to_s.delete('@').to_sym}
  end

  def to_dollars(cents)
    (cents / 1).round(2)
  end

  def inspect
    values = columns.map{|column| self.send(column)}
    columns.zip(values).to_h
  end
end