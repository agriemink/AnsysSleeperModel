GeometryHasContact = 1
GeometryHasFoundation = 1

!Wapening locatie middelpunt:
W_x = S_Breedte/2 - W_Dekking_x - W_Straal 
W_y = -W_Dekking_y - W_Straal

*IF, W_Divisions, LT, 1, THEN
	W_Divisions = 1 !Set default if unusable data is entered
*ENDIF

!Wapening block size:
!Rectangular (symmetric) block around the reinforcement
OB_size_height = W_Diameter + W_Dekking_y*2
OB_size_width = W_Diameter + W_Dekking_x*2

!Rail rotation should be set before. In general default parameters file
!RailRotation = 2.86 !1 op 20
!RailRotation = 1.43 !1 op 40



ESIZE_Sleeper = MIN(7 ,(W_Straal / W_Divisions)*(20/(2*W_Divisions))) !Test: 1 = 10, 2 = 5, 3, 2,5, 4, 1.25
