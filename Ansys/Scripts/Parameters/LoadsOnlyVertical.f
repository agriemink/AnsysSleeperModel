!----------------------------------------------------------------------
!------- Forces / loads -----------------------------------------------
!----------------------------------------------------------------------
!Force_angle = 30*(3.14159/180) !convert degrees to radians !Degrees
Force_angle_default = 1.34*(3.14159/180) !Equal to rail angle !convert degrees to radians !Degrees

!No forces for a modal analysis
!
! LoadSteps = amount of consecutive simulations.
!
! Array_size = amount of different
!
!
!
!

!Geef x-afstand vanuit de oorsprong.
LoadLocation_X = 0
!LoadLocation_X = 1.25 !Halve asafstand

*DEL, LoadTable_y_L
*DEL, LoadTable_z_L
*DEL, LoadTable_y_R
*DEL, LoadTable_z_R
*DEL, TimeArray
*DEL, Loadtable_Q_sym
*DEL, Loadtable_Y_sym
*DEL, LoadTable_Q_left
*DEL, LoadTable_Y_left
*DEL, LoadTable_Q_right
*DEL, LoadTable_Y_right
*DEL, LoadTable


LoadSteps = 7

*DIM, LoadTable_y_L, table, LoadSteps,,,time !LEFT
*DIM, LoadTable_z_L, table, LoadSteps,,,time
*DIM, LoadTable_y_R, table, LoadSteps,,,time !RIGHT
*DIM, LoadTable_z_R, table, LoadSteps,,,time




Array_size = 7
*DIM, TimeArray, array, Array_size,,,
*DIM, Loadtable_Q_sym, table, Array_size,,,time
*DIM, Loadtable_Y_sym, table, Array_size,,,time
*DIM, LoadTable_Q_left, table, Array_size,,,time
*DIM, LoadTable_Y_left, table, Array_size,,,time
*DIM, LoadTable_Q_right, table, Array_size,,,time
*DIM, LoadTable_Y_right, table, Array_size,,,time




*DIM, LoadTable, table, Array_size,5,,time !For drawing the graph.
!----------------------------------------------------------------------
TimeArray(1,1) 	= 1, 2, 3, 4, 5, 6, 7! Time this should be as long as Array_size -------

*DO, i, 1, Array_size !Fill load table with time

	
	Loadtable_Q_sym(i,0) 	= TimeArray(i,1)
	Loadtable_Y_sym(i,0) 	= TimeArray(i,1)
	
	LoadTable_Q_left(i,0) 	= TimeArray(i,1)
	LoadTable_Y_left(i,0) 	= TimeArray(i,1)
	
	LoadTable_Q_right(i,0) 	= TimeArray(i,1)
	LoadTable_Y_right(i,0) 	= TimeArray(i,1)
	
	LoadTable(i,0)			= TimeArray(i,1)
*ENDDO

Q = 110000 !Newtons
Q_DAF = 209000  !Newtons
!Loading in Newtons, static 110 kN, quasi-dynamic load of 209 kN (without other sleepers contributing)
!Load case:					1	2		3		4		5				6				7							
!Loadtable_Q_sym(1,1) = 	0,	-Q/3, 	-Q/2, 	-Q, 	-Q_DAF,	 		-1.5*Q_DAF,		-2*Q_DAF
Loadtable_Q_sym(1,1) = 		0,	-Q/3, 	-Q/2, 	-Q, 	-Q,	 		-Q_DAF,			-Q_DAF
Loadtable_Y_sym(1,1) = 		0, 	0, 		0, 		0, 		0, 		 		0, 				0

!Based on forces
LoadTable_Q_left(1,1) = 	0, 	0, 		0, 		0, 		0, 				0, 				0
LoadTable_Y_left(1,1) =		0, 	0, 		0, 		0, 		0,	 			0, 				0

LoadTable_Q_right(1,1) = 	0, 	0, 		0, 		0, 		0, 				0, 				0
LoadTable_Y_right(1,1) = 	0, 	0, 		0, 		0, 		0, 				0, 				0


angle = Force_angle_default !rail angle
*DO, i, 1, LoadSteps
	!LEFT
	LoadTable_y_L(i,0) 	= TimeArray(i,1)
	LoadTable_z_L(i,0) 	= TimeArray(i,1)

	LoadTable_y_L(i,1) = Loadtable_Q_sym(i,1)*cos(angle) + Loadtable_Y_sym(i,1)*sin(angle) + LoadTable_Q_left(i,1)*cos(angle) + LoadTable_Y_left(i,1)*sin(angle)	!Y
	LoadTable_z_L(i,1) = Loadtable_Q_sym(i,1)*sin(angle) + Loadtable_Y_sym(i,1)*cos(angle) + LoadTable_Q_left(i,1)*sin(angle) + LoadTable_Y_left(i,1)*cos(angle)	!Z
	
	!RIGHT
	LoadTable_y_R(i,0) 	= TimeArray(i,1)
	LoadTable_z_R(i,0) 	= TimeArray(i,1)

	LoadTable_y_R(i,1) = Loadtable_Q_sym(i,1)*cos(angle) + Loadtable_Y_sym(i,1)*sin(angle) + LoadTable_Q_right(i,1)*cos(angle) + LoadTable_Y_right(i,1)*sin(angle)	!Y
	LoadTable_z_R(i,1) = -(Loadtable_Q_sym(i,1)*sin(angle) + Loadtable_Y_sym(i,1)*cos(angle) + LoadTable_Q_right(i,1)*sin(angle) + LoadTable_Y_right(i,1)*cos(angle))	!Z

	
	LoadTable(i,1) = Loadtable_Q_sym(i,1) + LoadTable_Q_left(i,1)
	LoadTable(i,2) = Loadtable_Q_sym(i,1) + LoadTable_Q_right(i,1)
	LoadTable(i,3) = Loadtable_Y_sym(i,1) + LoadTable_Y_left(i,1)
	LoadTable(i,4) = Loadtable_Y_sym(i,1) + LoadTable_Y_right(i,1)
*ENDDO

*DEL, Array_size
*DEL, i