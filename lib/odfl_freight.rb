class OdflFreight
  attr_accessor :ratedClass, :nmfc, :nmfcsub, :weight, :length, :width, :height, :numberOfUnits, :dimensionUnits, :actualClass

  def to_hash
    hash = {}
    instance_variables.each {|var| hash[var.to_s.delete("@")] = instance_variable_get(var) }
    hash
  end
end