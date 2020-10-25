! /prep7 
! *set,test 
! *dim,test,array,4,4 
! test(1,1)=1,2,3,4 
! test(1,2)=1,2,3,4 
! test(1,3)=1,2,3,4 
! test(1,4)=1,2,3,4 

! /output,test,txt,,append 
! *mwrite,test(1,1),,,,ijk, 
! (4f6.0) 
! /output 

*DIM,MacroFolder,STRING,80
*DIM,BaseFolder,STRING,80
*DIM,OutputFilename_,STRING,80
BaseFolder(1) = 'O:\Afstuderen\Ansys\_AnsysModel'
MacroFolder(1) = '%BASEFOLDER(1)%\Scripts\Shared\Macros\'

OutputFilename_(1) = 'test_WapeningStresses'
*USE, '%MacroFolder(1)%save_results_to_csv.MAC'

! *GET,MaxNode,NODE,0, NUM, MAXD

! CMSEL, S, Wapening_V
! ALLSEL, BELOW, VOLU

! *DIM, ReducedValues_,array,MaxNode,12	!columns array
! *DIM, Mask_,array,MaxNode
! *VGET, Mask_(1),node,1,NSEL	!Selected nodes


! *vmask, Mask_(1)
! *VGET,	ReducedValues_(1,1),node,1,LOC, X	! X-location of nodes
! *vmask, Mask_(1)
! *VGET,	ReducedValues_(1,2),node,1,LOC, Y	! Y-location of nodes
! *vmask, Mask_(1)
! *VGET,	ReducedValues_(1,3),node,1,LOC, Z	! Z-location of nodes
! !Deformations
! *vmask, Mask_(1)
! *VGET,	ReducedValues_(1,4),node,1,U, X		! X-deformations of nodes
! *vmask, Mask_(1)
! *VGET,	ReducedValues_(1,5),node,1,U, Y		! Y-deformations of nodes
! *vmask, Mask_(1)
! *VGET,	ReducedValues_(1,6),node,1,U, Z		! Z-deformations of nodes
! !Stresses
! *vmask, Mask_(1)
! *VGET,	ReducedValues_(1,7),node,1,S, 1 	!S1
! *vmask, Mask_(1)
! *VGET,	ReducedValues_(1,8),node,1,S, 2 	!S2
! *vmask, Mask_(1)
! *VGET,	ReducedValues_(1,9),node,1,S, 3 	!S3
! *vmask, Mask_(1)
! *VGET,	ReducedValues_(1,10),node,1,S, EQV 	!Equivalent stress
! !Strains
! *vmask, Mask_(1)
! *VGET,	ReducedValues_(1,11),node,1,EPTO, EQV 	!Equivalent total strain
! *vmask, Mask_(1)
! *VGET,	ReducedValues_(1,12),node,1,EPEL, EQV 	!Equivalent elastic strain


! *CFOPEN, 'Test', txt
! *VWRITE, 'Node', ';', 'Loc X', ';', 'Loc Y', ';', 'Loc Z', ';', 'UX [m]', ';', 'UY [m]', ';', 'UZ [m]', ';', 'S1 [N/m2]',';', 'S2 [N/m2]',';', 'S3 [N/m2]',';', 'S EQV [N/m2]', ';', 'EQV total strain [-]', ';', 'EQV elastic strain [-]'
! %C %C %C %C %C %C %C %C %C %C %C %C %C %C %C %C %C %C %C
! *CFCLOS


! *vmask, Mask_(1)
! *MWRITE, ReducedValues_(1,1), 'Test2', txt, , ijk
! (12E14.20)
! !(F,F5.1,F6.4,F6.4,F6.4,EN15.4E2,EN15.4,EN15.4E2, EN15.4E2, EN15.4E2, EN15.4E2, EN15.4E2, EN15.4E2)
! !%C %C %C %C %C %C %C %C %C %C %C %C %C %C %C %C %C %C %C


! *DEL, ReducedValues_
! *DEL, Mask_
