ALLSEL
!------------------- Apply loads to the rail --------------------------
!----------------------------------------------------------------------
!Requires set loadtables. Originally generated in the Loads-folder
! aangrijpingspunt is midden van de rail, over een lengte van force_length symmetrisch vanuit het centrum in rail/lengte-richting.

*IF, A_54E1, GT, 0.0001, THEN
	force_length = A_54E1
*ELSEIF, force_length, GT, 0.0001, THEN
	force_length = force_length 
*ELSE	
	force_length = 0.02 !m Default
*ENDIF


!Left area:
*GET, DoesCompExists, COMP, LoadNodes_LEFT, TYPE
*IF, DoesCompExists, GT, 0, THEN
	CMSEL, S, LoadNodes_LEFT
*ELSE
	CSYS, CS_Rail_L !Use local coordinate system
	CMSEL, S, Rail_V
	NSLV, S, 1 !select nodes corresponding to selected volume.
	NSEL, R, LOC, Y, Force_apllication_height
	NSEL, R, LOC, Z, -force_length/2, force_length/2
	NSEL, R, LOC, X, LoadLocation_X-force_length/2, LoadLocation_X+force_length/2 !LoadLocation_X makes it possible to change the location of loading.
	CM, LoadNodes_LEFT, NODE
*ENDIF
*GET, AantalNodes_LEFT, NODE, 0, COUNT, 

!Right area:
*GET, DoesCompExists, COMP, LoadNodes_RIGHT, TYPE
*IF, DoesCompExists, GT, 0, THEN
	CMSEL, S, LoadNodes_RIGHT !This function is not used as it is not possible (jet) to assign nodes before generation of the geometry or to acces this geometry after generation.
*ELSE
	CSYS, CS_Rail_R !Use local coordinate system
	CMSEL, S, Rail_V
	NSLV, S, 1 !select nodes corresponding to selected volume.
	NSEL, R, LOC, Y, Force_apllication_height
	NSEL, R, LOC, Z, -force_length/2, force_length/2
	NSEL, R, LOC, X, LoadLocation_X-force_length/2, LoadLocation_X+force_length/2
	CM, LoadNodes_RIGHT, NODE
*ENDIF
*GET, AantalNodes_RIGHT, NODE, 0, COUNT, 
	
CSYS, 0 !Return to standard coordinate system

!----------------------------------------------------------------------
!------- loading: -----------------------------------------------------
!----------------------------------------------------------------------
*IF, AantalNodes_LEFT, GT, 0, THEN
	*DEL, LoadTable_z_L_scaled
	*DEL, LoadTable_y_L_scaled
	*TOPER, LoadTable_z_L_scaled, LoadTable_z_L, ADD, LoadTable_z_L, 1/AantalNodes_LEFT, 0 , !Scale force to a force per node.
	*TOPER, LoadTable_y_L_scaled, LoadTable_y_L, ADD, LoadTable_y_L, 1/AantalNodes_LEFT, 0 , !Scale force to a force per node.
*ENDIF
*IF, AantalNodes_RIGHT, GT, 0, THEN
	*DEL, LoadTable_z_R_scaled
	*DEL, LoadTable_y_R_scaled
	*TOPER, LoadTable_z_R_scaled, LoadTable_z_R, ADD, LoadTable_z_R, 1/AantalNodes_RIGHT, 0 , !Scale force to a force per node.
	*TOPER, LoadTable_y_R_scaled, LoadTable_y_R, ADD, LoadTable_y_R, 1/AantalNodes_RIGHT, 0 , !Scale force to a force per node.
*ENDIF

!Create substeps

*DO, n, 1, LoadSteps
	ALLSEL
	TIME, TimeArray(n)
	ACEL,,9.81 !In the absence of any other loads or supports, the acceleration of the structure in each of the global Cartesian (X, Y, and Z) axes would be equal in magnitude but opposite in sign to that applied in the ACEL command. Thus, to simulate gravity (by using inertial effects), accelerate the reference frame with an ACEL command in the direction opposite to gravity.
	!NSUBST, NumberOfSubsteps      	! Use appropriate time step 
	AUTOTS, ON !Substep / timestep to auto (is default, but apply explicitly)
	
	KBC,0             				! Ramped loads (if appropriate)
	
	*IF, AantalNodes_LEFT, GT, 0, THEN
		CMSEL, S, LoadNodes_LEFT
		!---------------- 
		*IF, LoadType(1), EQ, 'Force', THEN
			F, ALL, FZ, %LoadTable_z_L_scaled%, , , 
			F, ALL, FY, %LoadTable_y_L_scaled%, , ,
		*ELSE !LoadType = displacement
			LoadType(1) = 'Displacement'
			D, ALL, UZ, %LoadTable_z_L%, , , 
			D, ALL, UY, %LoadTable_y_L%, , , 
		*ENDIF
	*ENDIF
	
	*IF, AantalNodes_RIGHT, GT, 0, THEN
		CMSEL, S, LoadNodes_RIGHT
		!---------------- 
		*IF, LoadType(1), EQ, 'Force', THEN
			F, ALL, FZ, %LoadTable_z_R_scaled%, , , 
			F, ALL, FY, %LoadTable_y_R_scaled%, , ,
		*ELSE !LoadType = displacement
			LoadType(1) = 'Displacement'
			D, ALL, UZ, %LoadTable_z_R%, , , 
			D, ALL, UY, %LoadTable_y_R%, , , 
		*ENDIF
	*ENDIF
	ALLSEL

	LSWRITE           ! Write load data to load step file (Jobname.S0x)
*ENDDO

*DEL, AantalNodes_LEFT
*DEL, AantalNodes_RIGHT

ALLSEL