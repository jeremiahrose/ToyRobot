Code.load_file("toy_robot.exs")

ExUnit.start()
ExUnit.configure(trace: true)

defmodule ToyRobotTest do
    use ExUnit.Case

    test "Check valid state" do
        assert ToyRobot.check_state({0,0,:north}) == {0,0,:north}
    end

    test "Check invalid position" do
        assert ToyRobot.check_state({0,-1,:north}) == nil
    end

    test "Check invalid direction" do
        assert ToyRobot.check_state({0,0,2}) == nil
    end

    test "Face valid direction" do
        assert ToyRobot.face({0,0,:west}, :east) == {0,0,:east}
    end

    test "Face invalid direction" do
        assert ToyRobot.face({0,0,:west}, 8768) == nil
    end
        
end
