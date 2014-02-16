class String
  def trim
    self.gsub(/([^\d\w\s-])/){'\\'+$1}
  end
end