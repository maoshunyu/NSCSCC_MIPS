
# Parameters
li   $t0, 0x0
lw   $s0, 0($t0)    # set $s0 to n
move $a0, $s0       # set $a0 to n
addi $a1, $t0, 4    # set $a1 to &graph

# Call Bellman-Ford
jal  bellman_ford

li		$t1, 1		# $t1 = 1
li		$t2, 0		# $t2 = 0
loop_show:
bge		$t1, $s0, show	# if i >= n
sll		$t3, $t1, 2			# $t3 = $t1 << 2
addi		$t3, $t3, 0x200		# $t3 = $t3 + 0x200
lw		$t3, 0($t3)		# 
add		$t2, $t2, $t3		# $t2 = $t2 + dist[i] ---------> ** t2 **
addi	$t1, $t1, 1			# $t1 = $t1 + 1
j loop_show
show:

li		$t1, 0		# $t1 = 0           i
li		$t0, 4		# $t0 = 4
loop_an:
bge		$t1, $t0, out_an	# if $t1 >= $t0 then goto target
li		$t3, 256		# $t3 = 256                      t
sllv    $t3,$t3,$t1
li		$t4, 3		# $t4 = 3
sub		$t4, $t4, $t1		# $t4 = $t4 - $t1
sll		$t4, $t4, 2			# $t4 = $t4 << 2            temp
srav    $t4,$t2,$t4
andi	$t4, $t4, 0xf			# $t4 = $t4 & 0xf
bnez    $t4,t_1
ori		$t3, $t3, 0x3f			# $t3 = $t3 | 0x3f
b out_t

t_1:
li $v0,1
bne $t4,$v0,t_2
ori $t3,$t3,0x6
b out_t

t_2:
li $v0,2
bne $t4,$v0,t_3
ori $t3,$t3,0x5b
b out_t

t_3:
li $v0,3
bne $t4,$v0,t_4
ori $t3,$t3,0x4f
b out_t

t_4:
li $v0,4
bne $t4,$v0,t_5
ori $t3,$t3,0x66
b out_t

t_5:
li $v0,5
bne $t4,$v0,t_6
ori $t3,$t3,0x6d
b out_t

t_6:
li $v0,6
bne $t4,$v0,t_7
ori $t3,$t3,0x7d
b out_t

t_7:
li $v0,7
bne $t4,$v0,t_8
ori $t3,$t3,0x7
b out_t

t_8:
li $v0,8
bne $t4,$v0,t_9
ori $t3,$t3,0x7f
b out_t

t_9:
li $v0,9
bne $t4,$v0,out_t
ori $t3,$t3,0x6f

out_t:
lui $v0,0x4000
ori $v0,$v0,0x10
sw $t3,0($v0)

li		$s1, 10000		# $s1 = 10000
li		$s0, 0		# $s0 = 0

loop_delay:
bge		$s0, $s1, out_delay	# if $s0 >= $s1 then goto out_delay
addi	$s0, $s0, 1			# $s0 = $s0 + 1
j loop_delay
out_delay:
addi	$t1, $t1, 1			# $t1 = $t1 + 1
j loop_an
out_an:
j show
# Return 0


bellman_ford:
##### YOUR CODE HERE #####
li		$t0, 0x200		    # set $t0 to 0x200
sw		$zero, 0($t0)		# dist[0]=0
li		$t1, 1		        # $t1 = 1 = i
li		$t3, -1		        # $t3 = -1

loop1:
bge		$t1, $a0, out1	    # if i >= n then goto out1
sll		$t2, $t1, 2			# $t2 = 4*i
add		$t2, $t0, $t2		# $t2 = dist[i]
sw		$t3, 0($t2)		    
addi	$t1, $t1, 1			# i++
j		loop1				# jump to loop1

out1:
li		$t1, 1		        # $t1 = 1 = i
li		$s1, -1		        # $s1 = -1                                

loopi:
bge		$t1, $a0, outi	    # if $t1 >= $a0 then goto outi
li		$t2, 0		        # $t2 = 0 = u

loopu:
bge		$t2, $a0, outu	    # if $t2 >= $a0 then goto outu
li		$t3, 0		        # $t3 = 0 = v
sll		$t5, $t2, 2			# $t5 = 4*u
add		$t5, $t5, $t0		# $t5 = $t5 + t0 = dist[u]
lw		$t5, 0($t5)		     

loopv:
bge		$t3, $a0, outv	    # if $t3 >= $a0 then goto outv
sll		$t4, $t2, 5			# $t4 = u << 5
add		$t4, $t4, $t3		# $t4 = $t4 + v = addr
sll		$t6, $t3, 2			
add		$t6, $t6, $t0		
lw		$t6, 0($t6)         # $t6 = dist[v]

sll		$t7, $t4, 2			
add		$t7, $t7, $a1		
lw		$t7, 0($t7)         # $t7 = graph[addr]
beq		$t5, $s1, next	    # if $t5 == -1 then goto next
beq		$t7, $s1, next	    # if $t7 == -1 then goto next

add		$t7, $t7, $t5		# $t7 = $t7 + $t5
beq		$t6, $s1, if	    # if $t6 == -1 then goto if
bgt		$t6, $t7, if	    # if $t6 > $t7 then goto if
j		next				# jump to next


if:
sll		$t6, $t3, 2			
add		$t6, $t6, $t0	
sw		$t7, 0($t6)		 



next:
addi	$t3, $t3, 1			# $t3 = $t3 + 1
j		loopv				# jump to loopv


outv:
addi	$t2, $t2, 1			# $t2 = $t2 + 1
j		loopu				# jump to loopu

outu:
addi	$t1, $t1, 1			# $t1 = $t1 + 1
j		loopi				# jump to loopi

outi:
jr		$ra					# jump to $ra


