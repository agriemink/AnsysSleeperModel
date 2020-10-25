

NSEL, S, LOC, Y, -S_Hoogte
NSEL, R, LOC, X, 0
CM, BottomMidsideNodes, NODE
*GET, aantalMidsideNodes, NODE, 0, COUNT


*DIM, StressesResults, TABLE, aantalMidsideNodes, AantalSleepers, 1, Z
*DIM, DisplacementResults, TABLE, aantalMidsideNodes, AantalSleepers, 1, Z
*DIM, Z_COORD_ARRAY, ARRAY, aantalMidsideNodes

!Pseudocode:
! 
! Loop door alle z-coordinaten
! Selecteer alle fixed foundation nodes op deze locatie (Over alle X)
! Get the FSUM (FY)
! Onthoud de z-afstand tussen beide.
! Bereken de spanning: (FSUM / (1/2 * z-afstand_voor + 1/2 * z-afstand_na));
!
!
!



CMSEL, S, BottomMidsideNodes
index_ = 0
nd=ndnext(0) !Gets first node
*DOWHILE, nd
	index_ = index_ + 1
	Z_COORD_ARRAY(index_) = NZ(nd)
	nd = ndnext(nd) 
*enddo

*VFUN, Z_COORD_ARRAY, ASORT, Z_COORD_ARRAY !Sort by Z-coordinate

*DO, sleeperIndex, 1, AantalSleepers

	X_COORD_MIN = Sleeperdistance*(sleeperIndex  - 1) - Sleeperdistance/2
	X_COORD_MAX = Sleeperdistance*(sleeperIndex  - 1) + Sleeperdistance/2

	Z_COORD_Prev = Z_COORD_ARRAY(1)
	*DO, index_, 1, aantalMidsideNodes
		/GO
		*IF, index_+1, LE, aantalMidsideNodes, THEN
			Z_COORD_Next = Z_COORD_ARRAY(index_+1)
		*ELSE
			Z_COORD_Next = Z_COORD_ARRAY(index_)
		*ENDIF
		
		CMSEL, S, Foundation_Fixed_Nodes
		NSEL, R, LOC, Z, Z_COORD_ARRAY(index_)
		NSEL, R, LOC, X, X_COORD_MIN, X_COORD_MAX
		
		A = S_Breedte * abs(Z_COORD_Next - Z_COORD_Prev)*1000000
		
		FSUM, , ,
		*GET, RForces, FSUM, 0, ITEM, FY		
		StressesResults(index_,sleeperIndex) = RForces/A
		StressesResults(index_,0) = Z_COORD_ARRAY(index_)
		
		ETABLE, DisplacementTable, U, Y, MAX
		*GET, Displacement, SSUM, 0, ITEM, DisplacementTable
		DisplacementResults(index_,sleeperIndex) = Displacement
		DisplacementResults(index_,0) = Z_COORD_ARRAY(index_)
		
		Z_COORD_Prev = Z_COORD_ARRAY(index_)
		index_ = index_ + 1
	*ENDDO
	
	
	*CFOPEN, '%OutputFilename_(1)%_FoundationStressesSleeper_%sleeperIndex%', csv
	*VWRITE, 'Z-coordinate', ';', 'Stress [N/mm2]'
	%C%C%C
	
	
*ENDDO



!Configure output


*VWRITE, 'Node', ';', 'Loc X', ';', 'Loc Y', ';', 'Loc Z', ';', 'UX [m]', ';', 'UY [m]', ';', 'UZ [m]'
%C%C%C%C%C%C%C%C%C%C%C%C%C

!*VWRITE ,'Node', ';','X-coordinate', ';','Y-coordinate', ';','Z-coordinate', ';','X-displacement', ';','Y-displacement', ';','Z-displacement', ';', 'Equivalent stress' ';', 'Bonus'
*vmask, Mask_(1)
*VWRITE , sequ, ';', ReducedValues_(1,1), ';',ReducedValues_(1,2), ';', ReducedValues_(1,3), ';', ReducedValues_(1,4), ';', ReducedValues_(1,5), ';', ReducedValues_(1,6)
(F8.0,A,F8.5,A,F8.5,A,F8.5,A,EN15.4E2, A,EN15.4E2,A,EN15.4)
!Dont use spaces in formatting!

*CFCLOS


/gcol, 1, 'Sleeper 1'
/AXLAB, X, Z [m]
/AXLAB, Y, Stress [N/mm2]
*VPLOT,Z, StressesResults(1,1), , !Plot left (1) and right (2) loads


*DEL, Mask_
