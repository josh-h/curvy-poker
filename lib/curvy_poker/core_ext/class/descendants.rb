# Copied from activesupport/lib/active_support/core_ext/class/subclasses.rb, line 8
class Class
  def descendants # :nodoc:
    descendants = []
    ObjectSpace.each_object(singleton_class) do |k|
      descendants.unshift k unless k == self
    end
    descendants
  end
end
