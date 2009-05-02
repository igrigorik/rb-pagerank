# Ilya Grigorik
#
# Ferret index demo
#

require 'ferret'
include Ferret

index = Index::Index.new() 

index << {:title => "1", :content => "it is what it is"}
index << {:title => "2", :content => "what is it"}
index << {:title => "3", :content => "it is a banana"}

index.search_each('content:"banana"') do |id, score|
  puts "Score: #{score}, #{index[id][:title]} "
end