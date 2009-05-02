# Ilya Grigorik
#
# DIY inverted index in Ruby
# - http://www.wikipedia.org/wiki/Inverted_index
#

require 'set'

pages = {
  "1" => "it is what it is",
  "2" => "what is it",
  "3" => "it is a banana"
}

index = {}

pages.each do |page, content|
  content.split(/\s/).each do |word|
    if index[word]
      index[word] << page
    else
      index[word] = Set.new(page)
    end
  end
end

#  {
#    "it"=>#<Set: {"1", "2", "3"}>,
#    "a"=>#<Set: {"3"}>,
#    "banana"=>#<Set: {"3"}>,
#    "what"=>#<Set: {"1", "2"}>,
#    "is"=>#<Set: {"1", "2", "3"}>}
#  }

p "*" * 50

#
# Perform set intersect on inverted index to find documents that match our queries
#

# query: "what is banana"
p index["what"] & index["is"] & index["banana"]
# > #<Set: {}>

# query: "a banana"
p index["a"] & index["banana"]
# > #<Set: {"3"}>

# query: "what is"
p index["what"] & index["is"]
# > #<Set: {"1", "2"}>
