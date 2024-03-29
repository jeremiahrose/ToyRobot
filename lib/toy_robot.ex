defmodule ToyRobot do
    @moduledoc """
    Toy Robot simulator.

    This is an Elixir solution to the popular 'Toy Robot' interview question.
    For operating instructions refer to https://github.com/fredwu/toy-robot-elixir
    """
    
    use Application
    def start(_type, _args) do
        read_input()
        Supervisor.start_link([], strategy: :one_for_one)
    end

    # Size of board, starting at zero
    # e.g x_max of 4 creates 5 horizontal squares
    @x_max 4
    @y_max 4
    # The directions the robot can face are numbered 0-3 in anticlockwise order.
    # This allows to easily change direction by adding or subtracting, and to easily
    # add new directions (e.g @north_west 1.5) if we so desire.
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
    def check_state(_all_other_states), do: nil

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
    Print `state` in human readable form. Returns `state` unaltered.
    """
    def report({x,y,f}) do
        f_str = case f do
            0 -> "EAST"
            1 -> "NORTH"
            2 -> "WEST"
            3 -> "SOUTH"
            end
        IO.puts("#{x},#{y},#{f_str}")
        {x,y,f}
    end

    def report(nil) do
        IO.puts("Robot not on table.")
        nil
    end    

    @doc """
    Read commands from the given device (`stdio` by default) and action them.
    """
    def read_input(device \\ :stdio) do
        IO.puts("Enter one command per line (Ctrl+D to finish):")
        initial_state = nil
        Enum.reduce(IO.stream(device, :line), initial_state, &parse_line/2)
    end

    @doc """
    Parse a command and feed `state` through the appropriate transformation.
    """
    def parse_line(string, state) do
        # trim line for leading / trailing whitespace and newlines
        case String.trim(string) do
            "PLACE"<>args ->
                # Check PLACE argument formatting with regex
                case Regex.named_captures(~r{^\s+(?<x_str>\d+),(?<y_str>\d+),(?<f_str>(NORTH|EAST|SOUTH|WEST))\s*$}, args) do
                    # Parse matching strings
                    %{"x_str" => x_str, "y_str" => y_str, "f_str" => f_str} ->
                        new_state = {String.to_integer(x_str), 
                                     String.to_integer(y_str),
                                     case f_str do
                                         "NORTH" -> @north
                                         "SOUTH" -> @south
                                         "EAST"  -> @east
                                         "WEST"  -> @west
                                     end
                                    }
                        # Check that the desired position is actually on the board
                        # But don't throw an error if it's not - brief says to "ignore" this case
                        check_state(new_state) || state
                    # Warn against incorrect arguments
                    _no_regex_match -> 
                        IO.puts("PLACE command: invalid arguments")
                        state
                end
            "LEFT" -> rotate(state,1)
            "RIGHT" -> rotate(state,-1)
            "MOVE" -> move(state)
            "REPORT" -> report(state)
            # Ignore empty input
            "" -> state
            # Warn against incorrect commands
            no_match ->
                IO.puts("Invalid command: " <> no_match)
                state
        end
    end
            
   
end
