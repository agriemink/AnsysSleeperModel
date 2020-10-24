FINISH
/CLEAR
/PREP7
! Tensile test specimen according to NEN-EN-ISO 527-2:2012
!
!
!
!
!
ET,1,MESH200
KEYOPT,1,1,7
KEYOPT,1,2,0

!Parameters (Speciment type 1A)
L3 = 170 !Overall length
L2 = 109.3 !Distance between broad parallel-side portions
L1 = 80 !Length of narrow parallel-sided portion
r = 24 !Radius
b1 = 10 !Width at narrow portion
b2 = 20 !Width at ends
h = 4 !preffered thickness
L0 = 75 !Gauge length preffered


!Keypoints
	K_0 = 0 !Keypoint 1
		!#		X		Y		Z
	K, K_0 + 1, 0, 		0, 		0
	K, K_0 + 2, 0, 		b1/2,	0
	K, K_0 + 3, L1/2,	b1/2, 	0
	K, K_0 + 4, L2/2,	b2/2,	0
	K, K_0 + 5, L3/2,	b2/2, 	0
	K, K_0 + 6, L3/2,	0,		0

!Lines
	L_0 = 0 !whatch out for confusion with L0, L1 etc.
	
		!#		K1			K2
	L, 			K_0 + 1,	K_0 + 2 		
	L, 			K_0 + 2,	K_0 + 3 	
	LARC, 		K_0 + 3,	K_0 + 4, K_0 + 2, r 	
	L, 			K_0 + 4,	K_0 + 5 	
	L, 			K_0 + 5,	K_0 + 6 	

!Mirror:
LSYMM, Y, L_0 + 1, L_0 + 5, 1, , 0, 0

LSEL, ALL
CM, Lines, LINE

!Glue:
LGLUE, Lines

!Create area
LSEL, ALL
CM, Lines, LINE
AL, Lines


ESIZE, 1
AMAP,1,K_0 + 2, K_0 + 5, K_0 + 11, K_0 + 8 



!Constrain nodes at X = 0
NSEL, S, LOC, X, 0
D, All, All
