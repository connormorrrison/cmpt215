


# procedure init initializes the free list
# procedure arguments as follows:
#   a0 - address of block of memory to be used for free list
#   a1 - desired size of free list (number of nodes)
# procedure returns pointer to first node in free list
init:	  	
	mv t0, a0
	blez a1, init_r
init_l:   	
	sw zero, 0(t0)
	addi t0, t0, 8
	sw t0, -4(t0)
	addi a1, a1, -1
	bnez a1, init_l
	sw zero, -4(t0)
init_r:
	jalr zero, 0(ra)


# procedure alloc gets a node from the free list
# procedure argument as follows:
#   a0 - address of word containing the address of the first node in free list
# procedure returns pointer to unlinked node; 0 if free list empty
alloc:
	mv t0, a0
	lw a0, 0(a0)
	beqz a0, alloc_r  	#if free list is empty, return 0
	lw t1, 4(a0)
	sw t1, 0(t0)
	sw zero, 4(a0)
alloc_r:
	jalr zero, 0(ra)


# procedure free returns a node to the free list
# procedure arguments as follows:
#   a0 - address of word containing the address of the first node in free list
#   a1 - address of node that should be added to free list
free:
	lw t0, 0(a0)
	sw a1, 0(a0)
	sw zero, 0(a1)
	sw t0, 4(a1)
	jalr zero, 0(ra)

