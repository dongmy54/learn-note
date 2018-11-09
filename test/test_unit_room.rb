# test/unit ruby 自带测试库
################################### 代码部分 ######################################
class Room
  attr_reader :name, :description, :paths

  def initialize(name, description)
    @name        = name
    @description = description
    @paths       = {}
  end

  def go(direction)
    paths[direction]
  end

  def add_paths(path)
    paths.update(path)
  end
end


################################### 测试部分 ######################################
require 'test/unit'

class TestRoom < Test::Unit::TestCase

  def setup
    @center = Room.new('center_room', 'This is a beautiful room')
    @north  = Room.new('north_room', 'The room is sunny')
    @south  = Room.new('south_room', 'The room has good air')
  end

  def test_room     # test_ 开头的方法
    assert_equal('center_room', @center.name)
    assert_equal('The room is sunny', @north.description)
    assert_equal({}, @south.paths)
  end

  def test_add_paths
    @center.add_paths('north' => @north)       # Ps: 这里对实例变量的修改 对其它测试变量是不可见的
    @center.add_paths('south' => @south)

    assert_equal({'north' => @north, 'south' => @south}, @center.paths)
  end

  def test_go
    @center.add_paths('north' => @north)
    @center.add_paths('south' => @south)
    
    assert_equal(@north, @center.go('north'))
    assert_equal(@south, @center.go('south'))
  end

end


# 运行： ruby test_unit_room.rb 结果：

# Loaded suite test_unit_room
# Started
# ...
# Finished in 0.001672 seconds.
# -----------------------------------------------------------------------------------------------------------
# 3 tests, 6 assertions, 0 failures, 0 errors, 0 pendings, 0 omissions, 0 notifications
# 100% passed
# -----------------------------------------------------------------------------------------------------------
# 1794.26 tests/s, 3588.52 assertions/s