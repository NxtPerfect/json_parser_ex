# Requirements
## Step 1 MVP
- [ ] return json as string
- [/] should check if file is valid json
    - [x] IO.puts has issue with String.length
    - [/] finds ':' but doesn't do anything with it
        - [x] finds values
        - [ ] if values on same level, doesn't split on ','
        instead of passing it to function again
        should save it's value to the variable
        - [ ] once we parse '{' we try to parse '{' again
        but find no match
    - [ ] if element is an array, it needs to split at ','
    and then split at ':'
- [ ] each opened bracket is another level
- [ ] return type of each value
## Step 2 Optimization
- [ ] benchmark code

# Optional
