# Caesar cipher MMXXI

.eqv	KEYREADY	0xffff0000
.eqv	KEY_READ	0xffff0004
.eqv	DISPLAY		0xffff000c

.data
shift:		.word	0

.text
main:
		jal	readkey			# read first digit 0,1,2
		sw	$v0, DISPLAY		# display digit
		sub	$s0, $v0, '0'		# $s0 = '0','1','2'
		mul	$s0, $s0, 10		# $s0 = 0,10,20
		jal	readkey			# read second digit '0'-'9'
		sw	$v0, DISPLAY		# display digit
		sub	$v0, $v0, '0'		# $v0 = 0-9
		add	$s0, $s0, $v0		# $s0 = 0-23
		move	$a0, $s0
		li	$v0, 1
		syscall
		li	$v0, 10
		sw	$v0, DISPLAY		# write new line
readtext:	jal	readkey
		beq	$v0, 10, exit		# stop on return	
		blt 	$v0, 'a', outchar	# < 'a' output the character
		add	$v0, $v0, $s0		# add the shift
		ble	$v0, 'z', outchar	# <= 'z' modified with shift still valid
		sub	$v0, $v0, 26		# wrap around
outchar:	sw	$v0, DISPLAY		# output the character		
		j	readtext

exit:		li	$v0, 10
		syscall
		
readkey:	lw	$t0, KEYREADY
		beq	$t0, 0, readkey
		lw	$v0, KEY_READ
		jr	$ra
