#----- Sage Code for Computing Inversion and AES SBox in Composite Field (Polynomial Basis) ------------# 

# Some useful webpages on sage that you may find handy
# https://doc.sagemath.org/html/en/reference/finite_rings/sage/rings/finite_rings/finite_field_constructor.html
# https://doc.sagemath.org/html/en/reference/finite_rings/sage/rings/finite_rings/finite_field_ntl_gf2e.html
# https://ask.sagemath.org/question/35211/roots-of-polynomial-over-finite-field-characteristic-polynomial/
# If you still do not find everything in these page, just google it....

# Some useful functions---
# <Fieldname>.<polynomial>.roots() --> returns the roots of a polynomial (note that the polynomial should be defined in terms of the indeterminant of the field)
# <fieldelement>.integer_representation() -- > returns integer representation of a field element
# <Fieldname>.fetch_int(<int>) --> returns the representation of an integer in the field.
# <Fieldname>(<some poly>) --> maps some poly in the field.


# Step 1. Define the fields. Notice that for this assignment you do not need to explicitly define the composite fields.

# GF(2^8) mod R(X) = X^8 + X^4 + X^3 + X + 1
_.<X> = GF(2)[]
F.<X> = GF(2^8, modulus=X^8 + X^4 + X^3 + X +1)

# GF(2^4) mod R1(V) = V^4 + V^3 + 1
_.<V> = GF(2)[]
F24.<V> = GF(2^4, modulus=V^4 + V^3 + 1)

# GF(2^2) mod R2(U) = U^2 + U + 1
_.<U> = GF(2)[]
F22.<U> = GF(2^2, modulus=U^2 + U + 1)


# Step 2. The goal of this step is to define a mapping from GF(2^8)-->GF(2^2^2^2). Basically, you have to find
# out the mapping matrix.  
# Let g = (g7, g6, g5, g4, g3, g2, g1, g0) \in GF(2^8)
# and b = (b7, b6, b5, b4, b3, b2, b1, b0) \in GF(2^2^2^2)
# We need a matrix A such that g = Ab, and then A^{-1} will be our desired matrix.
# This is as per the "Change of basis" strategy (See Wiki..)
# Let's assume g is in polynomial basis
# as per the slides we can write: g = [WZY, ZY, WY, Y, WZ, Z, W, 1]b, where each WZY, ZY etc are column vectors 
# (basically polynomials). As per the technique for "change of basis", each of these can be represented as an element of
# GF(2^8), which is basically the "old basis" here. In a nutshell, we want every product term (e.g. WZY) or single term (Y)
# to be elements of GF(2^8).

# Now the question is, how to determine W,Z,Y.
# They depends on 4 polynomials:
# R(X) = X^8 + X^4 + X^3 + X + 1 -- GF(2^8)
# S(W) = W^2 + W + 1 -- GF(2^2)
# Q(Z) = Z^2 + Z + N -- GF(2^2^2)
# P(Y) = Y^2 + Y + mu -- GF(2^2^2^2)

# Here we do not know the values of mu and N. Let's first get them.

# Step 2.1 ------------------------------
# As per the slides, N is a root of the poly S(W). It should be in GF(2^2). 
# The irreducable poly of GF(2^2) is S(W). Let us find out its roots...

# -------------Your code here for finding and printing the roots------------ 

W = F22['W'].gen()
S = W^2 + W + 1
roots = S.roots(multiplicities=False)
print("********** Roots of W^2 + W + 1 **********")
print(roots)

#---------------------------------------------------------------------------

# Step 2.2 ---------------------------
# Now, GF(2^2) is a subfield of GF(2^8). So the same roots will also be there in GF(2^8).
# However, there representation will be different. To find out the representation, let us first find out the at least one root of U^2 + U + 1
# in GF(2^8). 

# Write your code here for finding N
#------------------------------------

U = F['U'].gen()
p = U^2 + U + 1
roots = p.roots(multiplicities=False)
print("\n********** Representation of roots of U^2 + U + 1 in GF(2^8) **********")
print(roots)

#------------------------------------        

# Step 2.3 -------------------------------
# So you shall find out two roots. These roots should match the values mentioned in the slide. Just choose the one chosen 
# in the slides. This will make the verifiction of your code easy. But you should also print the other values here...


# Write your code here for setting the value of N
#------------------------------------------------

X = F.gen()
N = X^7 + X^5 + X^4 + X^3 + X^2
print("Found N...", N)

#------------------------------------------------

# Step 2.4 --------------------------------------
# Next, we have to find mu. According to the theory, mu should be a root of the irreducable polynomial defining GF(2^4).
# There are two such polynomials: x^4 + x^3 + 1 and x^4 + x^3 + x^2 + x + 1. Chose x^4 + x^3 + 1, and proceed.

# -------------Your code here for finding and printing the roots------------ 

V = F24['V'].gen()
R1 = V^4 + V^3 + 1
roots = R1.roots(multiplicities=False)
print("\n********** Roots of X^4 + X^3 + 1 **********")
print(roots)

#------------------------------------


# Write your code here for finding mu
#------------------------------------

X = F['X'].gen()
r1 = X^4 + X^3 + 1
roots = r1.roots(multiplicities=False)
print("\n********** Representation of roots of X^4 + X^3 + 1 in GF(2^8) **********")
print(roots)

#------------------------------------

# Step 2.5----------------------------
# Choose the one which matches the value given in the slides. But show all possible values here ------------------
 
# Write your code here for setting the value of mu
#-------------------------------------------------
X = F.gen()
mu = X^7 + X^6 + X^5 + X^3 + X^2
print("Found mu...", mu)
#-------------------------------------------------

# Step 2.6----------------------------

# Now, our polynomials are well-defined. We just need to find out roots of these polies mod R(X).

# Write your code here for finding Y
#------------------------------------

Y = F['Y'].gen()
P = Y^2 + Y + mu
roots = P.roots(multiplicities=False)
print("\n********** Roots of Y^2 + Y + mu **********")
print(roots)

#------------------------------------

# Write your code here for setting the value of Y. Once again, set the value specified in the slide.
#--------------------------------------------------------------------------------------------------
X = F.gen()
Y = X^7 + X^6 + X^5 + X^4 + X^3 + X^2 + X + 1
print("Found Y...", Y)
#--------------------------------------------------------------------------------------------------

# Step 2.7----------------------------

# Write your code here for finding W
#------------------------------------

W = F['W'].gen()
S = W^2 + W + 1
roots = S.roots(multiplicities=False)
print("\n********** Roots of W^2 + W + 1 **********")
print(roots)

#------------------------------------------------        

# Write your code here for setting the value of W. Once again, set the value specified in the slide.
#--------------------------------------------------------------------------------------------------
X = F.gen()
W = X^7 + X^5 + X^4 + X^3 + X^2 + 1
print("Found W...", W)
#--------------------------------------------------------------------------------------------------

# Step 2.8----------------------------

# Finally, find Z

# Write your code here for finding Z
#------------------------------------

Z = F['Z'].gen()
Q = Z^2 + Z + N
roots = Q.roots(multiplicities=False)
print("\n********** Roots of Z^2 + Z + N **********")
print(roots)

#------------------------------------------------                

# Write your code here for setting the value of Z. Once again, set the value specified in the slide.
#--------------------------------------------------------------------------------------------------
X = F.gen()
Z = X^6 + X^4 + X^3 + X^2
print("Found Z...", Z)
#------------------------------------------------        

# Step 2.9----------------------------

# All set!! Let's find out [WZY, ZY, WY, Y, WZ, Z, W, 1] = [gamma_7,  gamma_6, gamma_5, gamma_4, gamma_3, gamma_2, gamma_1, gamma_0]

# Write your code here--------------------

X = F.gen()
I = X^0
gamma_7 = W*Y*Z
gamma_6 = Z*Y
gamma_5 = W*Y
gamma_4 = Y
gamma_3 = W*Z
gamma_2 = Z
gamma_1 = W
gamma_0 = I

# -----------------------------------------

# Step 2.10----------------------------

# Finally, create the matrix (uncomment the following code)

V = F.vector_space(map = False)
a = [list(reversed(list(V(gamma_7)))), list(reversed(list(V(gamma_6)))), list(reversed(list(V(gamma_5)))), list(reversed(list(V(gamma_4)))), list(reversed(list(V(gamma_3)))), list(reversed(list(V(gamma_2)))), list(reversed(list(V(gamma_1)))), list(reversed(list(V(gamma_0))))]
A = matrix(a).transpose()
A_inv = ~A
# Print A and A_inv and show that it matches with the slide.
# Uncomment here---------------
print("\n********** Matrix A **********")
print(A)
print("\n********** Inverse of Matrix A **********")
print(A_inv)
# -----------------------------------

#**** Milestone 1: Here you should be able to generate the matrix shown in the slides ******#

# Step 2.11----------------------------

# Finally, let (g7, g6, g5, g4, g3, g2, g1, g0) be the input bits in GF(2^8). Find the equations for the corresponding
# bits b = (b7, b6, b5, b4, b3, b2, b1, b0) in where b in in GF(2^2^2^2)

# Write your code here ------------------------

def equations(g_list):
    g = vector(F, g_list) 
    b = A_inv * g
    return b

# ---------------------------------------------

# Step 2.12----------------------------
# Now, compute the inverse in the polynomial basis
# Input: b7, b6, b5, b4, b3, b2, b1, b0

# Your code here -----------------------------------
# Write all the necessary funtions etc in this space. 

def computeInverse(b_list):
    b = sum([b_list[i] * F.gen()^(7-i) for i in range(8)])
    return b.inverse()

aes_inv = []

for i in range(1, 256):
  element = F.from_integer(i)
  elementList = [int(x) for x in bin(element.to_integer())[2:].zfill(8)]
  element_inv = computeInverse(elementList)
  aes_inv.append(element_inv.to_integer())

#----------------------------------------------------

#**** Milestone 2: Here you should be able to compute inversion of each field element (except 0 of course) ******#

# Step 2.13----------------------------
# Finally, compute the entire AES S-Box using your efficient inversion code

# Your code here -----------------------------------

aes_sbox = []

def affineTransform(x):
    xList = [int(bit) for bit in bin(x)[2:].zfill(8)]
    A = [[1, 1, 1, 1, 1, 0, 0, 0],
         [0, 1, 1, 1, 1, 1, 0, 0],
         [0, 0, 1, 1, 1, 1, 1, 0],
         [0, 0, 0, 1, 1, 1, 1, 1],
         [1, 0, 0, 0, 1, 1, 1, 1],
         [1, 1, 0, 0, 0, 1, 1, 1],
         [1, 1, 1, 0, 0, 0, 1, 1],
         [1, 1, 1, 1, 0, 0, 0, 1]]

    B = [0, 1, 1, 0, 0, 0, 1, 1]

    result = []
    for i in range(8):
      sum = 0
      for j in range(8):
        sum += (A[i][j] * xList[j])
      sum %= 2
      result.append(sum)
    
    for i in range(8):
      result[i] = (result[i] + B[i])%2
    
    ans = 0
    for i in range(8):
      ans += (result[i] * (2 ** (7-i)))
    return ans
    
def computeAES_Sbox():
    for i in range(0, 256):
        if i == 0:
            aes_sbox.append(affineTransform(0))
        else:
            aes_sbox.append(affineTransform(aes_inv[i - 1]))

computeAES_Sbox()
aes_sbox = [hex(aes_sbox[i]) for i in range(256)]
aes_inv = [hex(aes_inv[i]) for i in range(255)]

print("\n********** Inverse of every non-zero element in AES field **********")
print(aes_inv)
print("\n********** Entire AES Sbox **********")
print(aes_sbox)

#---------------------------------------------------

#**** Milestone 3: Here you should be able to compute the entire AES SBox ******#


#***** You should be able to show the correctness of the entire mapping *****#


# Enjoy the Assignment #



