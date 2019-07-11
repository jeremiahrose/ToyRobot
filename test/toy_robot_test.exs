defmodule ToyRobotTest do
    use ExUnit.Case
    import ExUnit.CaptureIO

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

    test "Bad command outputs unaltered state" do
        assert ToyRobot.parse_line("sfasdDFS", {0,0,2}) == {0,0,2}
    end

    test "Bad PLACE args output unaltered state" do
        assert ToyRobot.parse_line("PLACE 1 2 north\n", {1,1,1}) == {1,1,1}
    end

    test "PLACE command" do
        assert ToyRobot.parse_line("PLACE 0,0,EAST\n", nil) == {0,0,0}
    end

    test "MOVE command" do
        assert ToyRobot.parse_line("MOVE\n", {1,1,3}) == {1,0,3}
    end

    test "Multiple commands example a" do
        assert capture_io([input: "PLACE 0,0,NORTH\nMOVE\nREPORT\n"], &ToyRobot.read_input/0)
               == "Enter one command per line (Ctrl+D to finish):\n0,1,NORTH\n"
    end

    test "Multiple commands example b" do
        assert capture_io([input: "PLACE 0,0,NORTH\nLEFT\nREPORT\n"], &ToyRobot.read_input/0)
               == "Enter one command per line (Ctrl+D to finish):\n0,0,WEST\n"
    end

    test "Multiple commands example c" do
        assert capture_io([input: "PLACE 1,2,EAST\nMOVE\nMOVE\nLEFT\nMOVE\nREPORT\n"], &ToyRobot.read_input/0)
                == "Enter one command per line (Ctrl+D to finish):\n3,3,NORTH\n"
    end

end
