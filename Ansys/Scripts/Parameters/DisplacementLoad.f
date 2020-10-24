!----------------------------------------------------------------------
!------- Forces / loads -----------------------------------------------
!----------------------------------------------------------------------
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
! Application of displacements on the gauge nodes. 


!Geef x-afstand vanuit de oorsprong.
LoadLocation_X = 0
!LoadLocation_X = 1.25 !Halve asafstand

LoadSteps = 4

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

LateralDisplacement = 2/1000
!Loading in Newtons, static 110 kN, quasi-dynamic load of 209 kN (without other sleepers contributing)

Loadtable_Q_sym(1,1) = 		0, 	0, 0, 0
Loadtable_Y_sym(1,1) = 		0, 	0, 0, 0

!Based on forces
LoadTable_Q_left(1,1) = 	0, 	0, 0, 0
LoadTable_Y_left(1,1) =		0, 	LateralDisplacement/2 , LateralDisplacement, LateralDisplacement !towards the outside -> introduce gauge widening

LoadTable_Q_right(1,1) = 	0, 	0, 0, 0
LoadTable_Y_right(1,1) = 	0, 	LateralDisplacement/2, LateralDisplacement, LateralDisplacement	!towards the outside -> introduce gauge widening


angle = 0 !rail angle
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