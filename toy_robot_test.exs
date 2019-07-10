Code.load_file("toy_robot.exs")

ExUnit.start()
ExUnit.configure(trace: true)

defmodule ToyRobotTest do
    use ExUnit.Case

    test "Check valid state" do
        assert ToyRobot.check_state({0,0,"NORTH"}) == {0,0,"NORTH"}
    end

    test "Check invalid position" do
        assert ToyRobot.check_state({0,-1,"NORTH"}) == nil
    end

    test "Check invalid direction" do
        assert ToyRobot.check_state({0,0,2}) == nil
    end
        
end
