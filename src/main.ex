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
    IO.puts("Read file successfully.")
    Parser.parse(file)
    IO.puts("File successfully parsed.")
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

    {_left_side, right_side, stack} =
      if String.contains?(content, "{") do
        [_left, right] = String.split(content, "{", parts: 2)
        stack = ["{" | stack]
        {_left, right, stack}
      else
        [_left, right] = String.split(content, "[", parts: 2)
        stack = ["[" | stack]
        {_left, right, stack}
      end

    # IO.puts("Split content, new right_side" <> right_side)
    # IO.puts("The stack be bussin #{inspect(stack)}")
    parsed = parse(right_side, stack)
    :ok
  end

  # Parse content with stack
  # Check if closing bracket
  # matches first stack element
  def parse(content, []) do
    IO.puts("Removed everything from the list! Success!")
    :ok
  end

  def parse(content, stack) do
    # IO.puts("Splitting with stack fr fr #{inspect(stack)}")

    {left_opening_curly, right_opening_curly, stack_o_c} =
      if String.contains?(content, "{") do
        [left, right] = String.split(content, "{", parts: 2)
        stack = ["{" | stack]
        {left, right, stack}
      else
        {nil, nil, nil}
      end

    {left_opening_square, right_opening_square, stack_o_s} =
      if String.contains?(content, "[") do
        [left, right] = String.split(content, "[", parts: 2)
        stack = ["[" | stack]
        {left, right, stack}
      else
        {nil, nil, nil}
      end

    {left_closing_curly, right_closing_curly, stack_c_c} =
      if String.contains?(content, "}") and Enum.at(stack, 0) == "{" do
        [left, right] = String.split(content, "}", parts: 2)
        {_, stack} = List.pop_at(stack, 0)
        # IO.puts("Popped from list for { #{inspect(stack)}")
        {left, right, stack}
      else
        {nil, nil, nil}
      end

    {left_closing_square, right_closing_square, stack_c_s} =
      if String.contains?(content, "]") and Enum.at(stack, 0) == "[" do
        [left, right] = String.split(content, "]", parts: 2)
        {_, stack} = List.pop_at(stack, 0)
        # IO.puts("Popped from list for [ #{inspect(stack)}")
        {left, right, stack}
      else
        {nil, nil, nil}
      end

    # Compare lengths of each split
    {left_side, right_side, stack} =
      Enum.min_by(
        [
          {left_opening_curly, right_opening_curly, stack_o_c},
          {left_opening_square, right_opening_square, stack_o_s},
          {left_closing_curly, right_closing_curly, stack_c_c},
          {left_closing_square, right_closing_square, stack_c_s}
        ],
        fn {left, _, _} ->
          case left do
            nil -> :infinity
            str -> String.length(str)
          end
        end,
        fn -> {nil, content, stack} end
      )

    # IO.puts("Picked right side: " <> right_side)
    parse(right_side, stack)
  end
end

Parser.read_parse_json()
Parser.read_parse_json("")
Parser.read_parse_json("./data/test_same_level.json")
Parser.read_parse_json("./data/test_long.json")
Parser.read_parse_json("./data/test_menu.json")
Parser.read_parse_json("./data/test_formatting.json")
