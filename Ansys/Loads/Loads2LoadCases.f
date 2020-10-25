*DO, Boilerplate, 0, 1
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
*EXIT
*ENDDO
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

LoadSteps = 2
Array_size = 2

*DIM, LoadTable_y_L, table, LoadSteps,,,time !LEFT
*DIM, LoadTable_z_L, table, LoadSteps,,,time
*DIM, LoadTable_y_R, table, LoadSteps,,,time !RIGHT
*DIM, LoadTable_z_R, table, LoadSteps,,,time

*DIM, TimeArray, array, Array_size,,,
*DIM, Loadtable_Q_sym, table, Array_size,,,time
*DIM, Loadtable_Y_sym, table, Array_size,,,time
*DIM, LoadTable_Q_left, table, Array_size,,,time
*DIM, LoadTable_Y_left, table, Array_size,,,time
*DIM, LoadTable_Q_right, table, Array_size,,,time
*DIM, LoadTable_Y_right, table, Array_size,,,time


*DIM, LoadTable, table, Array_size,5,,time !For drawing the graph.
!----------------------------------------------------------------------
TimeArray(1,1) 	= 1, 4 ! Time this should be as long as Array_size -------

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
Y_30 = sin(30*(3.14159/180))*Q
Y_20 = sin(20*(3.14159/180))*Q
Y_prud_homme = (10+(Q/1000)/3)*1000 !Convert Q to kN and the result back to Newtons
Y_prud_homme_DAF = (10+(Q_DAF/1000)/3)*1000
!Loading in Newtons, static 110 kN, quasi-dynamic load of 209 kN (without other sleepers contributing)

!Some load cases, comment the non-used version(s). All loadtables are saved to a parameter-file and graphically saved as well.
!Original load cases:
Loadtable_Q_sym(1,1) = 		0,	-Q/2
LoadTable_Q_left(1,1) = 	0, 	0

!Basic zeros, are generally not used.
Loadtable_Y_sym(1,1) = 		0, 	0
LoadTable_Q_right(1,1) = 	0, 	0
LoadTable_Y_right(1,1) = 	0, 	0


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

	
	LoadTable(i,1) = Loadtable_Q_sym(i,1) + LoadTable_Q_left(i,1) 	!Q Left
	LoadTable(i,2) = Loadtable_Q_sym(i,1) + LoadTable_Q_right(i,1)	!Q Right
	LoadTable(i,3) = Loadtable_Y_sym(i,1) + LoadTable_Y_left(i,1)	!Y Left
	LoadTable(i,4) = Loadtable_Y_sym(i,1) + LoadTable_Y_right(i,1)	!Y Right
*ENDDO

*DEL, Array_size
*DEL, i