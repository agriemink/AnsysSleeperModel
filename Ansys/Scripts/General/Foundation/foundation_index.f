
!----------------------------------------------------------------------
!-------Add foundation  -----------------------------------------------
!----------------------------------------------------------------------
ALLSEL
ASEL, S, LOC, Y, -S_Hoogte, , ,
CM, Bodem_ALL, AREA
ALLSEL

MAT, Ballast

!Create empty components:
ESEL, NONE
CM, foundation_elements, ELEM
CM, shoulder_elements, ELEM
NSEL, NONE
CM, Foundation_Fixed_Nodes, NODE 
CM, BottomSleeperNodes, NODE 


*DIM,foundationscript,STRING,150
*DIM,DefaultScript,STRING,150
DefaultScript(1) = 'AddFoundationStiffness_WithSpringDamperElements'


startX_coord = 0
Y_location = -S_Hoogte
Z_location = S_Halve_Lengte !lateral foundation postion / location, at the end of the sleeper.
*DO, SleeperIndex, 1, AantalSleepers
	
	!
	X_Min = startX_coord - (SleeperDistance/2)
	X_Max = startX_coord + (SleeperDistance/2)
	
	!Vertical foundation:
	foundation_stiffness = Sleepers(4,SleeperIndex)
	
	*GET, SleeperArraySize, PARM, Sleepers, DIM, 1
	*IF, SleeperArraySize, GE, 6, THEN !Bad foundation parameters. Introduce a symmetric, stiffer or less stiff area in the middle.
		foundation_supported_area_factor = Sleepers(5,SleeperIndex) ! A percentage of the length <1
		foundation_supported_area_mp = Sleepers(6,SleeperIndex) !multiplier % C
	*ENDIF
	
	!5) foundation_supported_area_factor center-piece of the foundation as factor of the total length. E.g. for a value of 0.4, the center portion [0.4 * S_lengte] is supported by K_d/length times the foundation_supported_area_mp
	!6) foundation_supported_area_mp 
	foundation_damping = Damping_foundation
	


	*IF, foundation_supported_area_mp, EQ, -3, THEN
		foundationscript(1) = 'AddFoundationStiffness_As3PointBending'
	*ELSE
		foundationscript(1) = '%DefaultScript(1)%'
	*ENDIF

	
	
	!Middle sleepe and every sleeper at x > 0
	*USE, '%Scriptfolder(1)%/Foundation/%foundationscript(1)%.MAC', X_Min, X_Max, Y_location, foundation_stiffness, foundation_damping, MakeUseOfSymmetry, foundation_supported_area_factor,foundation_supported_area_mp
	
	*IF, SleeperIndex, GT, 1, AND, MakeUseOfSymmetry, NE, 'true', THEN
		!Every sleeper at x < 0
		*USE, '%Scriptfolder(1)%/Foundation/%foundationscript(1)%.MAC', -X_Max, -X_Min, Y_location, foundation_stiffness, foundation_damping, 'false', foundation_supported_area_factor, foundation_supported_area_mp	
	*ENDIF
	
	
	!Horizontal foundation:
	lateral_foundation_stiffness = K_shoulder 			!Set in DefaultParameters or analysis file.
	lateral_foundation_damping = Damping_shoulder 		!Set in DefaultParameters or analysis file. 
	!----------------------------------------------------------------------
	!------ Add foundation in lateral direction (Z), ballast shoulder -----
	!----------------------------------------------------------------------
	
	*IF, SleeperIndex, GT, 1, AND, MakeUseOfSymmetry, NE, 'true', THEN
		!*USE, '%Scriptfolder(1)%/Foundation/AddLateralStiffness_WithSpringDamperElements.MAC', -X_Max, X_Max, Z_location, lateral_foundation_stiffness, lateral_foundation_damping, 'false'
	*ELSEIF, SleeperIndex, EQ, 1
		!Add only a lateral foundation at the middle sleepers
		*USE, '%Scriptfolder(1)%/Foundation/AddLateralStiffness_WithSpringDamperElements.MAC', startX_coord-S_Halve_Breedte, startX_coord+S_Halve_Breedte, Z_location, lateral_foundation_stiffness, lateral_foundation_damping, MakeUseOfSymmetry
	*ENDIF

	startX_coord = SleeperDistance*SleeperIndex !update start coordinate
*ENDDO

*DEL, startX_coord
*DEL, SleeperIndex
*DEL, X_Min
*DEL, X_Max
*DEL, startX_coord
*DEL, foundation_stiffness
*DEL, foundation_damping
*DEL, Y_location
*DEL, foundation_supported_area_factor
*DEL, foundation_supported_area_mp
*DEL, foundationscript
*DEL, DefaultScript