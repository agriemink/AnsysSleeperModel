!File that creates the geometry from geometry-files.

!Input, an array called 'Sleepers'
! Properties:
! 1) SleeperModel, [1 = KLP_Rechthoek, 2 = KLP_Rechthoek_Simple] !Circulal reinforcement or octagonal.
! 2) SleeperType, 201 or 202 !These differ in reinforcement size and should have a different base material.
! 3) divisions (W_divisions), 1, 2, 3, etc.
! 4) foundation stiffness whole sleeper
! 5) foundation centre size as percentage [e.g. 0.2 => 20% of total lenght gets multiplied by next parameter
! 6) foundation multiplier of centre stiffness.
! Further, 	extend -> copy, copy all sleepers into the negative area
!        	extend -> add symmetry boundary conditions at X = 0


!Local coordinate systems:
!
! CS_Sleeper = X = 0, Y = 0, Z = 0
! CS_Rail_L = X = 0, Y = RH_Dikte, Z = -Spoorwijdte / 2, Hoek = +1.43 (1 op 40)
! CS_RAIL_R = X = 0, Y = RH_Dikte, Z = Spoorwijdte / 2, Hoek = -1.43 (1 op 40)
! CS_Rughellingplaat_L = 0, 0, 	+Spoorwijdte/2, 0, 0, 0, ,  
! CS_Rughellingplaat_R = 0, 0, 	-Spoorwijdte/2, 0, 0, 0, ,  

!MakeUseOfSymmetry = 'true' !DEbug opties: 'NegatieveX' & 'Symmetrie'


*DIM, SleeperModel, STRING, 100
!----------------------------------------------------------------------
!--------------------- Create local coordinate systems ----------------
!----------------------------------------------------------------------
*GET, CS_max , CDSY, 0, NUM, MAX
CS_Sleeper 				=	max(100,CS_max + 1)		!Top
CS_Rail 				=	max(101,CS_max + 2)		!Bottom of rail
CS_Rail_L 				=	max(102,CS_max + 3)
CS_Rail_R 				=	max(103,CS_max + 4)
CS_Railpad_L 			=	max(104,CS_max + 5)		!Bottom of railpad
CS_Railpad_R 			=	max(105,CS_max + 6)
CS_Railpad 				=	max(106,CS_max + 7)
CS_Rughellingplaat_L 	=	max(107,CS_max + 8) 	!Bottom of rughellingplaat
CS_Rughellingplaat_R 	=	max(108,CS_max + 9)
CS_Rughellingplaat 		=	max(109,CS_max + 10)
*DEL, CS_max
!Defines a local coordinate system by a location and orientation. (degrees)
LOCAL, CS_Sleeper, 				CART, 0, 0, 0, 0, 0,	0, ,  !0

LOCAL, CS_Rail_L, 				CART, 0, RH_Dikte + Railpad_thickness, Spoorwijdte / 2, 	0, -RailRotation,	0, ,  !
LOCAL, CS_Rail, 				CART, 0, RH_Dikte + Railpad_thickness, Spoorwijdte / 2, 	0, -RailRotation, 	0, ,  !Equal to CS_Rail_L
WPCSYS, , CS_Rail_L !Defines the working plane location based on a coordinate system.
!Move work plane
WPOFFS, 0, -Railpad_thickness, 0 !Offsets the working plane.
CSWPLA, CS_Railpad_L, CART, !Defines a local coordinate system at the origin of the working plane.
CSWPLA, CS_Railpad, CART, !Equal to CS_Railpad_L

LOCAL, CS_Rail_R, 				CART, 0, RH_Dikte + Railpad_thickness, -Spoorwijdte / 2, 	0, RailRotation, 	0, ,  ! 
WPCSYS, , CS_Rail_R !Defines the working plane location based on a coordinate system.
!Move work plane
WPOFFS, 0, -Railpad_thickness, 0 !Offsets the working plane.
CSWPLA, CS_Railpad_R, CART, !Defines a local coordinate system at the origin of the working plane.

LOCAL, CS_Rughellingplaat_L, 	CART, 0, 0, Spoorwijdte / 2, 	0, 0	0, ,  ! 
LOCAL, CS_Rughellingplaat_R, 	CART, 0, 0, -Spoorwijdte / 2, 	0, 0, 	0, ,  ! 
LOCAL, CS_Rughellingplaat, 		CART, 0, 0, Spoorwijdte / 2, 	0, 0, 	0, ,  !Equal to CS_Rughellingplaat_L

!----------------------------------------------------------------------
!--------------------- Create empty components ------------------------
!----------------------------------------------------------------------
VSEL, NONE
CM, Rughellingplaten, VOLU
CM, Wapening_V, VOLU
CM, Kunststof_V, VOLU
!----------------------------------------------------------------------
!--------------------- Create main sleeper (Middle) -------------------
!----------------------------------------------------------------------
i = Sleepers(1,1)
SleeperModel(1) 		= SleeperModelArray(1,i)
SleeperType 			= Sleepers(2,1)
W_divisions_Local 		= Sleepers(3,1)
!Sleeper_foundation 	= Sleepers(4,1)

*USE, '%GeometryFolderCommon(1)%\%SleeperModel(1)%\createSleeper.MAC', SleeperType, 0, MakeUseOfSymmetry, W_divisions_Local
*USE, '%GeometryFolderCommon(1)%\Rughellingplaat_met_hoek\createRughellingplaat.MAC', 0, MakeUseOfSymmetry

!----------------------------------------------------------------------
!--------------------- Create sleepers --------------------------------
!----------------------------------------------------------------------
*DO, SleeperIndex, 2, AantalSleepers
	i = Sleepers(1,SleeperIndex)
	SleeperModel(1) 	= SleeperModelArray(1,i)
	SleeperType 		= Sleepers(2,SleeperIndex)
	W_divisions_Local 		= Sleepers(3,SleeperIndex)
	!Sleeper_foundation 	= Sleepers(4,SleeperIndex)
	
	X_COORD = (SleeperIndex-1)*Sleeperdistance ![n = 1 -> x = 0, n = 2 -> x = 0.6 etc.]
	*USE, '%GeometryFolderCommon(1)%\%SleeperModel(1)%\createSleeper.MAC', SleeperType, X_COORD, 'false', W_divisions_Local !MakeUseOfSymmetry = always false as all other sleepers are full sleepers instead of half.
	X_COORD = (SleeperIndex-1)*Sleeperdistance
	*USE, '%GeometryFolderCommon(1)%\Rughellingplaat_met_hoek\createRughellingplaat.MAC', X_COORD, 'false'
*ENDDO
*DEL, i
*DEL, SleeperModel, NOPR
*DEL, SleeperType
*DEL, W_divisions_Local
*DEL, X_COORD

*IF, MakeUseOfSymmetry, NE, 'true', THEN
	!Kopier naar negative x-coordinaten
	
	VSEL, S, LOC, X, Sleeperdistance/2, Sleeperdistance*AantalSleepers
	VSYMM, X, ALL, , , , , 0, 0
*ENDIF

!----------------------------------------------------------------------
!--------------------- Create rail ------------------------------------
!----------------------------------------------------------------------
!Create two rails centered on CS_Rail, CS_Rail_L (=CS_Rail) and CS_Rail_R 	
*USE, '%GeometryFolderCommon(1)%\Rail_54E1\createRail.MAC', MakeUseOfSymmetry !|| symmetrie

*USE, '%GeometryFolderCommon(1)%\Railpad\createRailPads.MAC', MakeUseOfSymmetry 

CSYS, CS_Sleeper
ALLSEL
*IF, MakeUseOfSymmetry, EQ, 'true', THEN
	!Add symmetry constraint.
	
	!TODO
	NSEL, S, LOC, X, 0
	DSYM, SYMM, X
*ENDIF



ALLSEL
!----------------------------------------------------------------------
!-------Create components ---------------------------------------------
!----------------------------------------------------------------------
!Rughellingplaten
VSEL, ALL
VSEL, R, LOC, Y, 0, RH_dikte_max
VSEL, R, LOC, Z, 0, S_Lengte/2
CM, Rughellingplaten_L, VOLU

VSEL, ALL
VSEL, R, LOC, Y, 0, RH_dikte_max
VSEL, R, LOC, Z, 0, -S_Lengte/2
CM, Rughellingplaten_R, VOLU

!Sleepers
VSEL, ALL
VSEL, R, LOC, Y, -S_Hoogte, 0
CM, Dwarsliggers_V, VOLU


*USE, '%GeometryFolderCommon(1)%\renumberEntities.MAC' !Renumber to be sure that there are no gaps
*USE, '%Scriptfolder(1)%\deleteMESH200.MAC' !Delete mesh elements
CSYS, 0
*DEL, KP_0
*DEL, Line_0
*DEL, Area_0
*DEL, Volume_0

SAVE, %Filename(1)%, 'db'