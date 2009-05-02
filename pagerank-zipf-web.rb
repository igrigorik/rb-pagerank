# Ilya Grigorik
#
# Generate a N page web, where number of links follows a power-law distribution
#

require "rubygems"
require "gsl"

include GSL

# INPUT: link structure matrix, probability of following a link
# OUTPUT: pagerank scores
def pagerank(g, s)
  raise if g.size1 != g.size2

  i = Matrix.I(g.size1)                       # identity matrix
  p = (1.0/g.size1) * Matrix.ones(g.size1,1)  # teleportation vector
  t = 1-s   # probability of teleportation

  (t*((i-s*g).invert)*p).column(0)
end

# INPUT: number of pages, and number of outgoing links for this page
# OUTPUT: n-dimensional column vector with randomly set links
def random_column(pages, links, index)
  v = Vector.alloc(pages)
  links.times { |n| v[rand(pages)] = 1 }
  v[index] = 1

  return (1.0/v.sum) * v
end

def random_network(pages, links)
  g = Matrix.alloc(pages, pages)
  rng = GSL::Rng.alloc
  data = rng.exponential(links, pages)

  pages.times { |n| g.set_col(n, random_column(pages, data[n].round, n)) }

  return g
end

g = random_network(500,10)
pr = pagerank(g,0.85)

puts "Pagerank vector: ", pr

pr.histogram(50).graph()