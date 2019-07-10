Code.load_file("toy_robot.exs")

ExUnit.start()
ExUnit.configure(trace: true)

defmodule ToyRobotTest do
    use ExUnit.Case

    test "Check valid state" do
        assert ToyRobot.check_state({0,0,1}) == {0,0,1}
    end

    test "Check invalid position" do
        assert ToyRobot.check_state({0,-1,1}) == nil
    end

    test "Check invalid direction" do
        assert ToyRobot.check_state({0,0,"northh"}) == nil
    end

    test "Face valid direction" do
        assert ToyRobot.face({0,0,2}, 0) == {0,0,0}
    end

    test "Face invalid direction" do
        assert ToyRobot.face({0,0,2}, 8768) == nil
    end

    test "Move one square north" do
        assert ToyRobot.move({0,0,1}) == {0,1,1}
    end

    test "Don't move off edge" do
        assert ToyRobot.move({0,0,2}) == {0,0,2}
    end

    test "Rotate past zero" do
        assert ToyRobot.rotate({0,0,0}, -1) == {0,0,3}
    end

    test "Rotate left" do
        assert ToyRobot.rotate({2,3,1}, 1) == {2,3,2}
    end
        
end
