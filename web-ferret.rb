# Ilya Grigorik
#
# TFIDF vs PageRank demo for a trivial 3-page web:
# page 1 -> page 2, page 3  (PageRank: 0.05)
# page 2 -> page 3          (PageRank: 0.07)
# page 3 -> page 3, page 3  (PageRank: 0.87)
#

require 'ferret'
include Ferret

index = Index::Index.new() 

index << {:title => "Page 1", :content => open("web/page-1.html").read, :pagerank => 0.05 }
index << {:title => "Page 2", :content => open("web/page-2.html").read, :pagerank => 0.07 }
index << {:title => "Page 3", :content => open("web/page-3.html").read, :pagerank => 0.87 }

index.search_each('content:"world"') do |id, score|
  puts "Score: #{score}, #{index[id][:title]} (PageRank: #{index[id][:pagerank]})"
end

puts "*" * 50

sf_pagerank = Search::SortField.new(:pagerank, :type => :float, :reverse => true)

index.search_each('content:"world"', :sort => sf_pagerank) do |id, score|
  puts "Score: #{score}, #{index[id][:title]}, #{index[id][:pagerank]}"
end

#  Score: 0.267119228839874, Page 3 (PageRank: 0.87)
#  Score: 0.17807948589325, Page 1 (PageRank: 0.05)
#  Score: 0.17807948589325, Page 2 (PageRank: 0.07)
#  **************************************************
#  Score: 0.267119228839874, Page 3, 0.87
#  Score: 0.17807948589325, Page 2, 0.07
#  Score: 0.17807948589325, Page 1, 0.05
