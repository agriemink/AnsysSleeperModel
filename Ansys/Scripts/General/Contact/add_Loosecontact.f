CM,_NODECM,NODE 
CM,_ELEMCM,ELEM 
CM,_KPCM,KP 
CM,_LINECM,LINE 
CM,_AREACM,AREA 
CM,_VOLUCM,VOLU 
ALLSEL

!------------ Creates a contact between two sets of nodes ----------
! This script needs a component 'target_nodes' and 'contact_nodes'
*GET, MaxElementNr, ETYP, 0, NUM, MAX, , 


!------------ Set element numbers ----------
Element_TARGE170_1_standard = MaxElementNr + 1
ET,Element_TARGE170_1_standard,TARGE170
KEYOPT,Element_TARGE170_1_standard,5,0

Element_CONTA174_standard = MaxElementNr + 2
ET,Element_CONTA174_standard,CONTA174
KEYOPT,Element_CONTA174_standard,2,0
KEYOPT,Element_CONTA174_standard,4,0
KEYOPT,Element_CONTA174_standard,5,3
KEYOPT,Element_CONTA174_standard,7,0
KEYOPT,Element_CONTA174_standard,8,0
KEYOPT,Element_CONTA174_standard,9,1
KEYOPT,Element_CONTA174_standard,10,0   
KEYOPT,Element_CONTA174_standard,11,0   
KEYOPT,Element_CONTA174_standard,12,0   !Behavior of contact surface. 0 = standaard, 5 = fully bonded, no seperation
KEYOPT,Element_CONTA174_standard,18,0   

!-----------------------
!Real constants
*get,Maxreal_,rcon,0,num,max 
R, Maxreal_ + 1
REAL, Maxreal_ + 1  
R,Maxreal_ + 1,,,1.0,0.1,0,
RMORE,,,1.0E20,0.0,1.0, 
RMORE,0.0,0,1.0,,1.0,0.5
RMORE,0,1.0,1.0,0.0,,1.0
RMORE,,,,,,1.0

! Generate the target surface   
NSEL,S,,, target_nodes  


TYPE,Element_TARGE170_1_fixed 
ESLN,S,0
ESURF 
CM,_TARGET,NODE 
 
NSEL,S,,, contact_nodes    
CM,_CONTACT,NODE
TYPE,Element_CONTA174_1_fixed  
ESLN,S,0
ESURF   


CMSEL,A,_NODECM 
CMDEL,_NODECM   
CMSEL,A,_ELEMCM 
CMDEL,_ELEMCM   
CMSEL,S,_KPCM   
CMDEL,_KPCM 
CMSEL,S,_LINECM 
CMDEL,_LINECM   
CMSEL,S,_AREACM 
CMDEL,_AREACM   
CMSEL,S,_VOLUCM 
CMDEL,_VOLUCM   

CMDEL,_TARGET   
CMDEL,_CONTACT  
ALLSEL

*DEL, MaxElementNr
*DEL, Maxreal_