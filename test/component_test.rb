gem 'minitest', '~> 5.4'
require 'minitest/autorun'
require_relative '../lib/component'

class ComponentTest < Minitest::Test
  def test_the_first_verse
    assert true
  end
end
