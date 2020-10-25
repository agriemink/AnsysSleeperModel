NSEL, NONE
CM, ConstrainedNodes, NODE

!----------------------------------------------------------------------
!------- General constraints ------------------------------------------
!----------------------------------------------------------------------


!----------------------------------------------------------------------
!-------General fixed nodes -------------------------------------------
!----------------------------------------------------------------------
CSYS, 0
ALLSEL

*GET, L_ShoulderCompExists, COMP, Shoulder_Fixed_Nodes_L, TYPE
*GET, R_ShoulderCompExists, COMP, Shoulder_Fixed_Nodes_R, TYPE
*IF, L_ShoulderCompExists, GT, 0, AND, R_ShoulderCompExists, GT, 0, THEN
	NSEL, S, , , Shoulder_Fixed_Nodes_L, , ,
	NSEL, A, , , Shoulder_Fixed_Nodes_R, , ,
	!Fix shoulder nodes:
	D, ALL, UX , 0, 
	!D, ALL, UY , 0, 
	D, ALL, UZ , 0, 
	
	CMSEL, A, ConstrainedNodes
	CM, ConstrainedNodes, NODE
	
*ENDIF

*DEL, L_ShoulderCompExists
*DEL, R_ShoulderCompExists



ALLSEL


!----------------------------
!Symmetry
! ASEL, S, LOC, Z, 0
! DA,ALL,SYMM
! NSLA, S, 1
! CM, ConstrainedNodes_temp, NODE

! CMSEL, S, ConstrainedNodes
! CMSEL, A, ConstrainedNodes_temp
! CM, ConstrainedNodes, NODE

!----------------------------
!Fix middle bottom point in z-direction.
! NSEL, S, LOC, X, -S_Hoogte
! NSEL, R, LOC, Y, -S_Hoogte
! NSEL, R, LOC, Z, -S_Hoogte
! D, ALL, UZ, 0
! CM, ConstrainedNodes_temp, NODE

! CMSEL, S, ConstrainedNodes
! CMSEL, A, ConstrainedNodes_temp
! CM, ConstrainedNodes, NODE

!----------------------------
!fix railfoot in x-direction (length of the rail)
CMSEL, S, RailendNodes !Middle nodes of rail cross-section
D, ALL, UX, 0

CMSEL, A, ConstrainedNodes
CM, ConstrainedNodes, NODE

! !Constrain only one side
! CMSEL, S, Rail_V
! NSLV, S, 1 
! *GET, Raileinde, NODE, 0, MNLOC, X, , !MNLOC minimum
! NSEL, R, LOC, X, Raileinde, , , 0 !without symmetry
! D, ALL, UX, 0
! CM, ConstrainedNodes_temp, NODE


!----------------------------
!Fix bottom nodes under the foundation springs:
ALLSEL
NSEL, S, LOC, Y, -S_Hoogte - Y_Foundation, , ,

D, ALL, UZ , 0, 
D, ALL, UX , 0, 
D, ALL, UY , 0, 

CMSEL, A, ConstrainedNodes
CM, ConstrainedNodes, NODE

!----------------------------
!Fix middle outer bottom node to stop full body lateral displacement
!ALLSEL
!NSEL, S, LOC, X, 0, , ,
!NSEL, R, LOC, Y, -S_Hoogte, , ,
!NSEL, R, LOC, Z, S_Halve_Lengte, , ,



!D, ALL, UZ , 0, 
!CMSEL, A, ConstrainedNodes
!CM, ConstrainedNodes, NODE

!----------------------------------------------------------------------
ALLSEL