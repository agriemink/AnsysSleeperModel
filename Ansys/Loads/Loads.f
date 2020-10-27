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
!No forces for a modal analysis
! LoadSteps = amount of consecutive simulations.
! Array_size = amount of different time steps
!
! Left = positive z-direction
! Right = negative z-direction
!
LoadSteps = 7
*DIM, LoadTable_y_L, table, LoadSteps,,,time !Vertical LEFT
*DIM, LoadTable_z_L, table, LoadSteps,,,time !Lateral LEFT
*DIM, LoadTable_y_R, table, LoadSteps,,,time !Vertical RIGHT
*DIM, LoadTable_z_R, table, LoadSteps,,,time !Lateral RIGHT

Array_size = 7
*DIM, TimeArray, array, Array_size,,,
*DIM, Loadtable_Q_sym, table, Array_size,,,time !Vertical symmetric loading on both rails = wheel load
*DIM, Loadtable_Y_sym, table, Array_size,,,time !Lateral symmetric loading on both rails [positive = outward on both rails]
*DIM, LoadTable_Q_left, table, Array_size,,,time !Vertical loading on left rail only [positive = outward on both rails]
*DIM, LoadTable_Y_left, table, Array_size,,,time !Lateral loading on left rail only [positive = outward on both rails]
*DIM, LoadTable_Q_right, table, Array_size,,,time !Vertical loading on right rail only  [positive = outward on both rails]
*DIM, LoadTable_Y_right, table, Array_size,,,time !Lateral loading on right rail only  [positive = outward on both rails]

*DIM, LoadTable, table, Array_size,5,,time !Only used for drawing the graph later on.
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

!Define loads:

LoadType(1) = 'Force' ! 'Displacement' [meters] or 'Force' [Newtons]

!Some suggestions:
!Loading in Newtons, static 110 kN, quasi-dynamic load of 209 kN (without other sleepers contributing)
!Single sleeper loading is about 35%
!	Q = 110000 !Newtons
!	Q_DAF = 209000  !Newtons
!Lateral forces based on Prud'homme criteria
!	Y_prud_homme = (10+(Q/1000)/3)*1000 !Convert Q to kN and the result back to Newtons
!	Y_prud_homme_DAF = (10+(Q_DAF/1000)/3)*1000

! Negative loads for wheel load == acting downwards
! Positve loads for symmetric lateral loads. Positvie == acting inwards

!Comment the non-used labels to prevent a warning message from popping up.
!Loadtable_Q_sym(1,1) = 		0, 	0, 		0, 		0, 		0, 		 		0, 				0
!LoadTable_Y_left(1,1) =		0, 	0, 		0, 		0, 		0, 		 		0, 				0
!Basic zeros
Loadtable_Y_sym(1,1) = 		0, 	0, 		0, 		0, 		0, 		 		0, 				0
LoadTable_Q_right(1,1) = 	0, 	0, 		0, 		0, 		0, 				0, 				0
LoadTable_Y_right(1,1) = 	0, 	0, 		0, 		0, 		0, 				0, 				0


!Some load cases, comment the non-used version(s). All loadtables are saved to a parameter-file and graphically saved as well.
!Original load cases:
Loadtable_Q_sym(1,1) = 		0,	-Q/3, 	-Q/2, 	-Q, 	-Q,	 			-Q_DAF,			-Q_DAF !Original
LoadTable_Q_left(1,1) = 	0, 	0, 		0, 		0, 		Y_prud_homme, 	Y_prud_homme,	Y_prud_homme_DAF

!Lower load cases better that match loads used in experiments:
!Loadtable_Q_sym(1,1) = 		0,	-15000, -30000, -Q/3, 	-Q/2, 			-Q, 			-Q,	
!LoadTable_Y_left(1,1) =		0, 	0, 		0, 		0, 		0, 				0, 				Y_prud_homme_DAF


*DO, Boilerplate, 0, 1
	angle = Rail_angle !rail angle should be set as parameter.
	!Create load tables.
	*DO, i, 1, LoadSteps
		!LEFT
		LoadTable_y_L(i,0) 	= TimeArray(i,1)
		LoadTable_z_L(i,0) 	= TimeArray(i,1)

		LoadTable_y_L(i,1) = Loadtable_Q_sym(i,1)*cos(angle) + Loadtable_Y_sym(i,1)*sin(angle) + LoadTable_Q_left(i,1)*cos(angle) + LoadTable_Y_left(i,1)*sin(angle)	!Y
		LoadTable_z_L(i,1) = Loadtable_Q_sym(i,1)*sin(angle) + Loadtable_Y_sym(i,1)*cos(angle) + LoadTable_Q_left(i,1)*sin(angle) + LoadTable_Y_left(i,1)*cos(angle)	!Z
		
		!RIGHT
		LoadTable_y_R(i,0) 	= TimeArray(i,1)
		LoadTable_z_R(i,0) 	= TimeArray(i,1)

		LoadTable_y_R(i,1) = Loadtable_Q_sym(i,1)*cos(angle) + Loadtable_Y_sym(i,1)*sin(angle) + LoadTable_Q_right(i,1)*cos(angle) + LoadTable_Y_right(i,1)*sin(angle)		!Y
		LoadTable_z_R(i,1) = -(Loadtable_Q_sym(i,1)*sin(angle) + Loadtable_Y_sym(i,1)*cos(angle) + LoadTable_Q_right(i,1)*sin(angle) + LoadTable_Y_right(i,1)*cos(angle))	!Z
		
		LoadTable(i,1) = Loadtable_Q_sym(i,1) + LoadTable_Q_left(i,1) 	!Q Left
		LoadTable(i,2) = Loadtable_Q_sym(i,1) + LoadTable_Q_right(i,1)	!Q Right
		LoadTable(i,3) = Loadtable_Y_sym(i,1) + LoadTable_Y_left(i,1)	!Y Left
		LoadTable(i,4) = Loadtable_Y_sym(i,1) + LoadTable_Y_right(i,1)	!Y Right
	*ENDDO
*EXIT
*ENDDO
*DEL, Array_size
*DEL, i