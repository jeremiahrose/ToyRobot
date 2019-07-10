defmodule ToyRobot do
    @moduledoc """
    Toy Robot simulator.

    This is an Elixir solution to the popular 'Toy Robot' interview question.
    For operating instructions refer to https://github.com/fredwu/toy-robot-elixir
    """

    # Size of board, starting at zero
    # e.g x_max of 4 creates 5 horizontal squares
    @x_max 4
    @y_max 4
    # The directions the robot can face are numbered 0-3 in anticlockwise order.
    # This allows to easily change direction by adding or subtracting, and to easily
    # add new directions (e.g @north_west 1.5) if we so desired.
    @east 0
    @north 1
    @west 2
    @south 3
    # Allowable directions
    @directions 0..3

    @doc """
    Given a tuple representing the robot's state, return the same tuple if the state is valid,
    otherwise return nil.
    State is represented as {x, y, f} where x and y are the robot's position on the board
    (starting at 0) and f is a string representing the direction the robot is facing.
    """
    def check_state({x, y, f}) when x in 0..@x_max
                                and y in 0..@y_max
                                and f in @directions,
                               do: {x, y, f}
    def check_state(_invalid_state), do: nil

    @doc """
    Alter the given state so that the robot faces the desired direction.
    """
    def face({x,y,_f}, direction) when direction in @directions, do: {x,y,direction}
    def face(_state, _invalid_direction), do: nil

    @doc """
    Alter the given state so that the robot moves one square in the direction it is facing.
    If the robot is facing the edge of the board, it is not moved
    """
    def move({x,y,@north}) when y<@y_max, do: {x,y+1,@north}
    def move({x,y,@south}) when y>0, do: {x,y-1,@south}
    def move({x,y,@east}) when x<@x_max, do: {x+1,y,@east}
    def move({x,y,@west}) when x>0, do: {x-1,y,@west}
    def move(all_other_states), do: all_other_states

    # Alternative move that would also work diagonally.
    #def move({x, y, f}) do
    #    {dx, dy} = {round(:math.cos(f*:math.pi/2)), round(:math.sin(f*:math.pi/2))}
    #    check_state({x + dx, y + dy, f}) || {x , y, f}
    #end

    @doc """
    Alter the given state so that the robot rotates left or right.

    The rotation parameter must be -1 or 1 for a right or left hand turn respectively.
    """
    def rotate({x,y,f}, r) when r in [-1,1], do: {x,y,Integer.mod(f+r,4)}
    def rotate(nil, _f), do: nil

    @doc """
    Reads lines of input from the given device (`stdio` by default) and parses them.
    """
    def read_input(device \\ :stdio) do
        IO.puts("Enter one command per line (Ctrl+D to finish):")
        initial_state = nil
        end_state = Enum.reduce(IO.stream(device, :line), initial_state, &parse_line/2)
        IO.puts("final state:")
        IO.inspect(end_state)
    end

    @doc """
    Parses a command and feeds `state` through the appropriate transformation
    """
    def parse_line(string, state) do
        case string do
            "PLACE"<>args ->
                [x_str,y_str,f_str] = String.split(args, ~r{\s+}, [trim: true, parts: 4])
                {x,y} = {String.to_integer(x_str), String.to_integer(y_str)}
                f = case f_str do
                    "NORTH" -> @north
                    "SOUTH" -> @south
                    "EAST" -> @east
                    "WEST" -> @west
                    end
                check_state({x,y,f})
            "LEFT\n" -> rotate(state,1)
            "RIGHT\n" -> rotate(state,-1)
            "MOVE\n" -> move(state)
            _ ->
                IO.puts("Skipping invalid command: " <> string)
                state
        end
    end
            
   
end

ToyRobot.read_input()
