# python code
# n = 50 
# set(range(2,n+1)).difference(set((p * f) for p in range(2,int(n**0.5) + 2) for f in range(2,(n/p)+1))))

# set() is an object of unordered, unique elements e.g. ignore order in a vector

# difference is the set of values in p but not in f within the loop

n = 50
setE = seq(2, n+1)

## Basic logic, bump up the modulo by n + 1 to infinity; what is the stopping rule?
## numberSet[numberSet %% modulus_n == 1]
# eliminate all even numbers -- use modulo
setE2 <- setE[setE %% 2 == 1];setE2

# eliminate all numbers divisible by 3
setE2 <- setE[setE2 %% 3 == 1];setE2

# eliminate all numbers divisible by 4
setE2 <- setE[setE2 %% 4 == 1];setE2

# eliminate all numbers divisible by 5
setE2 <- setE[setE2 %% 5 == 1];setE2
# eliminate all numbers divisible by 7 
# print remaining numbers