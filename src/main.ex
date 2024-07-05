defmodule Parser do
  # Early exit if path is empty
  # IO.binread IO.binwrite are faster,
  # but they don't do UTF-8
  # slower but UTF-8 compatible functions are
  # IO.read IO.write
  # shell conventions like ~ aren't expanded
  # by default, for that use Path.expand

  # Early exit no path passeed
  def read_parse_json() do
    IO.puts("Error! No path specified.")
    :error
  end

  # Early exit empty path
  def read_parse_json("") do
    IO.puts("Error! Path to file is empty.")
    :error
  end

  # Open file and parse it
  def read_parse_json(path) do
    # TODO: Handle paths using $HOME or ~
    file = File.read!(path)
    IO.puts("Read file successfully.\n" <> file)
    file_parsed = Parser.parse(file)
    IO.puts("File successfully parsed.\n" <> file_parsed)
    :ok
  end

  # Recursively check content
  # Split on open brackets
  # if closing brackets appear
  # they need to match last opening
  # bracket
  # 
  # Step 2 is to check key: value,
  def parse(content) do
    stack = []
    {_left_side, right_side, stack} = if String.contains?(content, "{") do
      [_left, right] = String.split(content, "{", parts: 2)
      stack = ["{" | stack]
      {_left, right, stack}
    else
      [_left, right] = String.split(content, "[", parts: 2)
      stack = ["[" | stack]
      {_left, right, stack}
    end
    IO.puts("Split content, new right_side" <> right_side)
    IO.puts("The stack be bussin #{inspect(stack)}")
    parse(right_side, stack)
  end
  def parse(content, stack) do
    IO.puts("Splitting with stack fr fr #{inspect(stack)}")
  end
end

Parser.read_parse_json()
Parser.read_parse_json("")
Parser.read_parse_json("./data/test_same_level.json")
