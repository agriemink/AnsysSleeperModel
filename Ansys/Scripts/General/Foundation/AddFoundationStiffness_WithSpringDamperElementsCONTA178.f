!----------------------------------------------------------------------
!---------------------Create spring-damper elements -------------------
!----------------------------------------------------------------------
/GO

X_Min_Local = ARG1
X_Max_Local = ARG2
Y_location_Local = ARG3

foundation_stiffness_Local = ARG4
foundation_damping_Local = ARG5

*IF, ARG6, EQ, 'true', THEN !ARG6 = MakeUseOfSymmetry
	!As symmetry is used, divide the stiffness of the middle sleeper as one half of the nodes is not drawn (and thus not used in the calculation)
	foundation_stiffness_Local = ARG4/2
	foundation_damping_Local = ARG5/2
*ENDIF


!Parameter:
Y_Foundation = 0.2

!----------------------------------------------------------------------
!----------------------------------------------------------------------
!----------------------------------------------------------------------
/PREP7
ALLSEL
NSEL, S, LOC, Y, Y_location_Local
NSEL, R, LOC, X, X_Min_Local, X_Max_Local
CM, BottomSleeperNodes_Local, NODE !Save Top nodes.

*GET, AantalNodes, NODE, 0, COUNT, 

*IF, AantalNodes, GT, 0, THEN
	!----- Count the nodes to get a large enough offset between the nodes on either side of the spring element.
	*GET, MaxNode_ALL, NODE, 0, NUM, MAXD
	*GET, MaxNodeSelected, NODE, 0, NUM, MAX
	*GET, MinNodeSelected, NODE, 0, NUM, MIN
	NodeDifference = 1 + MaxNode_ALL - MinNodeSelected

	*GET, Y_bottomSleeper, NODE, 0, MNLOC, Y !Set Y_bottomSleeper to the y value of the bottom nodes and use this further on in the script.
	ALLSEL
	!----------------------------------------------------------------------
	!----------- Add spring-damper elements -------------------------------
	!----------------------------------------------------------------------


	!Copy nodes to 0.2 m /20cm offset to the current area
	NGEN,2, NodeDifference , BottomSleeperNodes_Local, , , , -Y_Foundation, ,1, 
	NSEL, S, LOC, Y, Y_bottomSleeper - Y_Foundation, , ,
	NSEL, R, LOC, X, X_Min_Local, X_Max_Local
	CM, Foundation_Fixed_Nodes_Local, NODE

	!Fix new nodes:
	CMSEL, S, Foundation_Fixed_Nodes_Local
	D, ALL, UZ , 0, 
	D, ALL, UX , 0, 
	D, ALL, UY , 0, 
	ALLSEL
	
	NSEL, S, , , BottomSleeperNodes_Local 
	NSEL, A, , , Foundation_Fixed_Nodes_Local 

	*GET, AantalNodes, NODE, 0, COUNT, 
	AantalNodes = AantalNodes / 2 !This is the amount of springs.
	NodeNumber = MinNodeSelected

	!----- Create CONTA178 elements
	

	!----------------------------------------------------------------------
	!---------------------Set foundation stiffness ------------------------
	!----------------------------------------------------------------------
	Mat, Ballast
	*get,real_,rcon,0,num,max 
	NormalStiffness = 
	IntitialGapSize = 
	InitialContactStatus = 
	StickingStiffness = 
	REDFACT
	
	
	
	
	r, real_ + 1 , foundation_stiffness_Local / AantalNodes, foundation_damping_Local / AantalNodes !Set foundation stiffness 
	real, real_+ 1

	ESEL, NONE
	TYPE,Element_COMBIN14 !set element type to combin14
	!KEYOPT,Element_COMBIN14,2,2  !longitudinal spring-damper (UY degree of freedom). 
	!^^ Don't select direction, direction is then based on element orientation. 

	*DO, i, 1, AantalNodes, 1 !iterate over all the nodes.
		!Connect all the nodes with COMBIN14 Elements
		!	node IF		node J
		e,NodeNumber, NodeNumber + NodeDifference

		!Set next node number:
		*GET, NodeNumber, NODE, NodeNumber, NXTH
	*ENDDO 

	!----------------------------------------------------------------------
	!Update components
	CM, foundation_elements_Local, ELEM
	CMSEL, A, foundation_elements
	CM, foundation_elements, ELEM 

	CMSEL, S, BottomSleeperNodes_Local
	CMSEL, A, BottomSleeperNodes
	CM, BottomSleeperNodes, NODE 

	CMSEL, S, Foundation_Fixed_Nodes_Local
	CMSEL, A, Foundation_Fixed_Nodes
	CM, Foundation_Fixed_Nodes, NODE 
	!----------------------------------------------------------------------
	!----------------------------------------------------------------------
	!----------------------------------------------------------------------
*ENDIF

*DEL, AantalNodes
*DEL, NodeNumber
*DEL, foundation_stiffness_Local
*DEL, foundation_damping_Local
*DEL, X_Min_Local
*DEL, X_Max_Local
*DEL, Y_location_Local
*DEL, MaxNodeSelected
*DEL, MAXNODE_ALL
*DEL, NodeDifference
*DEL, MinNodeSelected
*DEL, i