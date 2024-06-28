defmodule Parser do
  # Early exit if path is empty
  # IO.binread IO.binwrite are faster,
  # but they don't do UTF-8
  # slower but UTF-8 compatible functions are
  # IO.read IO.write
  # shell conventions like ~ aren't expanded
  # by default, for that use Path.expand
  def read_parse_json() do
    IO.puts("Error! No path specified.")
    :error
  end

  def read_parse_json("") do
    IO.puts("Error! Path to file is empty.")
    :error
  end

  def read_parse_json(path) do
    # TODO: Handle paths using $HOME or ~
    file = File.read!(path)
    IO.puts("Read file successfully.\n" <> file)
    file_parsed = Parser.parse(file)
    IO.puts("File successfully parsed.\n" <> file_parsed)
    :ok
  end

  def parse(content) do
    # brackets always take the priority
    # if : is before brackets, split on that
    # else split on brackets
    # Now we need to keep count of open brackets
    # then we need to split at closing brackets,
    # depending on which bracket type was last
    # and return the amount
    # TODO: How to save last character?
    [left_side, right_side] =
      if String.contains?(content, "{") do
        [left_bracket, right_bracket] = String.split(content, "{", parts: 2)
        [left_colon, right_colon] = String.split(content, ":", parts: 2)

        if String.length(left_bracket) < String.length(left_colon) do
          [left_side, right_side] = [left_bracket, right_bracket]
        else
          [left_side, right_side] = [left_colon, right_colon]
        end
      else
        if String.contains?(content, "[") do
          [left_bracket, right_bracket] = String.split(content, "[", parts: 2)
          [left_colon, right_colon] = String.split(content, ":", parts: 2)

          if String.length(left_bracket) < String.length(left_colon) do
            [left_side, right_side] = [left_bracket, right_bracket]
          else
            [left_side, right_side] = [left_colon, right_colon]
          end
        else
          if String.contains?(content, ",") do
            [left_side, right_side] = String.split(content, ",", parts: 2)
          end
        else
          if String.contains?(content, "}") do
            [left_side, right_side] = String.split(content, "}", parts: 2)
          end
        else
          if String.contains?(content, "]") do
            [left_side, right_side] = String.split(content, "]", parts: 2)
          end
        end
      end

    [left_side, right_side] = [String.trim(left_side), String.trim(right_side)]
    IO.write("Left side chosen is: ")
    IO.puts(left_side)
    parse(right_side)
  end
end

Parser.read_parse_json()
Parser.read_parse_json("")
Parser.read_parse_json("./data/test_same_level.json")
