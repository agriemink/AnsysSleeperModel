!----------------------------------------------------------------------
!------- Elements -----------------------------------------------------
!----------------------------------------------------------------------
/PREP7
Element_MESH200 = 1
ET,Element_MESH200,MESH200
KEYOPT,Element_MESH200,1,6 !3-D quadrilateral with 4 nodes
KEYOPT,Element_MESH200,2,0

Element_SOLID185 = 2
ET,Element_SOLID185,SOLID185   

!Spring-Damper element
!https://www.sharcnet.ca/Software/Ansys/17.0/en-us/help/ans_elem/Hlp_E_COMBIN14.html
Element_COMBIN14 = 3
ET,Element_COMBIN14,COMBIN14   
KEYOPT, Element_COMBIN14, 1, 0


!COMBIN40 is a combination of a spring-slider and damper in parallel, coupled to a gap in series.
!https://www.sharcnet.ca/Software/Ansys/17.0/en-us/help/ans_elem/Hlp_E_COMBIN40.html
Element_COMBIN40 = 4
ET,Element_COMBIN40,COMBIN40
KEYOPT, Element_COMBIN40, 1, 0 !Gap behavior: 0 = Standard gap capability
KEYOPT, Element_COMBIN40, 3, 0 !Element degrees of freedom, UX (Displacement along nodal X axes)

Element_CONTA178
ET, Element_CONTA178, CONTA178
KEYOPT, Element_COMBIN40, 1, 0 	!Unidirectional gap
KEYOPT, Element_COMBIN40, 3, 2 	!Weak spring, adds weak spring stiffness to the contact normal direction for open contact and tangent plane for frictionless or open contact.
KEYOPT, Element_COMBIN40, 4, 0 	!Gap size 0 = Gap size based on real constant GAP + intitial node locations. 1 = Gap size based on real constant Gap (ignore node locations)
KEYOPT, Element_COMBIN40, 5, 0 	!The contact normal is either based on the real constant values of NX, NY, NZ or on node locations when NX, NY, NZ are not defined. For 2-D contact, NZ = 0.
KEYOPT, Element_COMBIN40, 6, 0 	!Degrees of freedom UX, UY, UZ
KEYOPT, Element_COMBIN40, 10, 0 !Models standard unilateral contact; that is , normal presuure equals zero if separation occurs


