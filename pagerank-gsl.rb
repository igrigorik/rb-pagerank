# Ilya Grigorik
#
#  Bruteforce implementation of PageRank algorithm, works for small(ish) graphs
#  of up to couple of thousand pages.
#

require "rubygems"
require "gsl"

include GSL

# INPUT: link structure matrix
# OUTPUT: pagerank scores
def pagerank(g)
  raise if g.size1 != g.size2

  i = Matrix.I(g.size1)                       # identity matrix
  p = (1.0/g.size1) * Matrix.ones(g.size1,1)  # teleportation vector

  s = 0.85  # probability of following a link
  t = 1-s   # probability of teleportation

  t*((i-s*g).invert)*p
end

# page 1 -> page 2  (0.33)
# page 2 -> page 3  (0.33)
# page 3 -> page 1  (0.33)
puts "Circular: ", pagerank(Matrix[[0,0,1], [0,0,1], [1,0,0]])

# page 1 -> page 3  (0.05)    # page 1 & page 2 have minimal postrank values
# page 2 -> page 3  (0.05)    # min value = min(t * Teleport Vector)
# page 3 -> page 3  (0.09)    # for uniform teleport vector, min = t * (1/N)
puts "Star: ", pagerank(Matrix[[0,0,0], [0,0,0], [1,1,1]])

# page 1 -> page 2, page 3  (0.05)
# page 2 -> page 3          (0.07)
# page 3 -> page 3, page 3  (0.87)
puts "Converge: ", pagerank(Matrix[[0,0,0], [0.5,0,0], [0.5,1,1]])

# page 1 -> page 1, page 2  (0.18)
# page 2 -> page 1, page 3  (0.13)
# page 3 -> page 3          (0.69)
puts "Linked:", pagerank(Matrix[[0.5,0.5,0], [0.5,0,0], [0,0.5,1.0]])
