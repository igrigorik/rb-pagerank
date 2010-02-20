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

# each array represents an adjancency matrix for each node, hence
# [0,0,1] for the first element indicates that node 3 links to 1
# and because the weight is 1, that's the only node coming from 
# node 3

# page 1 -> page 2  (0.33)
# page 2 -> page 3  (0.33)
# page 3 -> page 1  (0.33)
puts "Circular: ", pagerank(Matrix[[0,0,1], [1,0,0], [0,1,0]])

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

# wikipedia example: http://en.wikipedia.org/wiki/File:PageRanks-Example.svg
#
#    a    b    c    d    e    f    g    h    i    j    k
#   [0   ,0   ,0   ,0   ,0   ,0   ,0   ,0   ,0   ,0   ,0   ]
a = [0   ,0   ,0   ,0.50,0   ,0   ,0   ,0   ,0   ,0   ,0   ]
b = [0   ,0   ,1   ,0.50,0.33,0.50,0   ,0   ,0.50,0.50,0.50]   
c = [0   ,1   ,0   ,0   ,0   ,0   ,0   ,0   ,0   ,0   ,0   ]
d = [0   ,0   ,0   ,0   ,0.33,0   ,0   ,0   ,0   ,0   ,0   ]
e = [0   ,0   ,0   ,0   ,0   ,0.50,1   ,1   ,0.50,0.50,0.50]
f = [0   ,0   ,0   ,0   ,0.33,0   ,0   ,0   ,0   ,0   ,0   ]
g = [0   ,0   ,0   ,0   ,0   ,0   ,0   ,0   ,0   ,0   ,0   ]
h = [0   ,0   ,0   ,0   ,0   ,0   ,0   ,0   ,0   ,0   ,0   ]
i = [0   ,0   ,0   ,0   ,0   ,0   ,0   ,0   ,0   ,0   ,0   ]
j = [0   ,0   ,0   ,0   ,0   ,0   ,0   ,0   ,0   ,0   ,0   ]
k = [0   ,0   ,0   ,0   ,0   ,0   ,0   ,0   ,0   ,0   ,0   ]

puts "Wikipedia: ", pagerank(Matrix[a,b,c,d,e,f,g,h,i,j,k])

# Wikipedia: 
# a   2.755e-02 
# b   3.227e-01 
# c   2.879e-01 
# d   3.274e-02 
# e   6.812e-02 
# f   3.274e-02 
# g   1.364e-02 
# h   1.364e-02 
# i   1.364e-02 
# j   1.364e-02 
# k   1.364e-02 
