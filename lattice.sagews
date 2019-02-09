id = 113383597  # set up id number
S = 10^94*id  # target

prime = 2
n = 100  # the number of primes
primes = []
sum_list = []

# generate the primes
for i in range(100):
    primes.append(prime)
    prime = prime.next_prime()

# generate the lattice M
M = matrix.identity(101)*2  # diagonals are 2
for i in range(n):
    M[i, n] = floor(10^100*(primes[i].n(prec = 600).nth_root(5)))

# set up the last row of M to [1, 1, 1, ..., 1, S]
ones = matrix(1, n + 1, lambda i, j: 1)
M[n] = ones
M[n, n] = S

M_temp = copy(M)
S_error = 99/100 # S range from [S - S_error(95.01), S(97), S + S_error(97.99)]

# purify S and M with trailing 0's, e.g. 1234567 to 1234560, 1234500, ....
for exp_temp in range(0, 93, 1): 
    base = (10^exp_temp)*id
    exp_M = 101 - len(str(base)) # exponent of the factor of M
    exp_S = 103 - len(str(base)) # exponent of the factor of S
    factor_M = 10^exp_M # factor of M
    factor_S = 10^exp_S # factor of S

    for S_dec in range(199):
        # round M in matrix
        for i in range(n):
            M_temp[i, n] = M[i, n]//factor_M*factor_M

        # round S in matrix
        M_temp[n, n] = factor_S*(base - S_error + S_dec/100)  # modify S

        # choose algorithm, return reduced lattice Ml
        # Ml = M_temp.LLL() # LLL algorithm
        Ml = M_temp.BKZ()  # BKZ algorithm

        # check if the row contains the vector [-1/1, -1/1, ..., -1/1, 0]
        for i in range(99, 100, 1):
            # flag: if the row is in valid form, 1: valid, 0: invalid
            flag = 1  # if the row is valid

            # check if the last coordinate is 0
            if Ml[i, n] != 0:
                continue
            else:
                # check if other coordinates are -1/1
                for j in range(n):
                    if Ml[i, j] != 1 and Ml[i, j] != -1:
                        flag = 0  # the row is invalid
                        break
                if flag == 0:
                    continue
                else:
                    # if it is a valid row, get the sum
                    sum = 0
                    res = []  # binary vector

                    # Ml[i, j]: -1 in the set; 1 not in the set
                    for j in range(n):
                        if Ml[i, j] == -1:
                            res.append(1)
                            sum = sum + M[j, n]
                        else:
                            res.append(0)

                    if sum >= S:
                        sum_list.append(sum)
                        # print sum
                        # print 'binary vector: \n' + str(res)

    print 'exp_temp: ' + str(exp_temp)
    if sum_list != []:
        # print the minimal subset sum
        print 'subset sum: ' + str(min(sum_list))
        sum_list = []
    else:
        print 'no result found'
    
    print '\n'

print 'Finished'
