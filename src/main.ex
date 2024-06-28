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
    # If doesn't start or end with {}
    # not a valid json file
    # if !String.starts_with?(content, "{") and !String.ends_with?(content, "}") do
    #   IO.puts("Not a valid json, doesn't start/end with {}")
    #   :error
    # end
    [left, right] = String.split(content, "{", parts: 2)
    index = String.length(left)
    # IO.puts([left, parsed_content, String.length(left), " ", String.length(parsed_content)])
    IO.write("Found '{' at ")
    IO.write(index)
    IO.write(" index.\n")
    IO.puts(right)
    # Now if we get item in "" on the left then we know what variable
    # is defined on the right side, and if right side starts with {
    # then it's an object, [ is an array, "" is a string,
    # number/bool is number/bool
    if String.contains?(left, ",") do
      [pair, parsed_content] = String.split(left, ",")
      IO.write("Parsed on comma: ")
      IO.write(String.strip(pair))
      IO.write(" ")
      IO.write(String.strip(parsed_content))
      IO.write("\n")

      [variable, value] = String.split(pair, ":")
      IO.write("Parsed on variable and value: ")
      IO.write(String.strip(variable))
      IO.write(" ")
      IO.write(String.strip(value))
      IO.write("\n")
    end
    IO.write("Parsed left string: ")
    IO.write(left)
    IO.write("\n")
    parse(right)
  end
end

Parser.read_parse_json()
Parser.read_parse_json("")
Parser.read_parse_json("./data/test_same_level.json")
