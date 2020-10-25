ALLSEL
!/NOPR
NSEL, NONE


startX_coord = 0
*DO, SleeperIndex, 1, AantalSleepers
	X_coord_min = startX_coord - S_Halve_Breedte
	X_coord_max = startX_coord + S_Halve_Breedte
	
	*USE, '%Scriptfolder(1)%/Contact/createSleeperRughellingplaatContact.MAC', X_coord_min, X_coord_max
	
	*IF, Railpad_thickness, GT, 0.000001, THEN
		*USE, '%Scriptfolder(1)%/Contact/createRughellingplaatRailpadContact.MAC', X_coord_min, X_coord_max
	*ELSE !Geen railpad
		*USE, '%Scriptfolder(1)%/Contact/createRughellingplaatRailContact.MAC', X_coord_min, X_coord_max
	*ENDIF
	

	*IF, SleeperIndex, GT, 1, AND, MakeUseOfSymmetry, NE, 'true', THEN
	
		*USE, '%Scriptfolder(1)%/Contact/createSleeperRughellingplaatContact.MAC', -X_coord_max, -X_coord_min
	
		*IF, Railpad_thickness, GT, 0.000001, THEN
			*USE, '%Scriptfolder(1)%/Contact/createRughellingplaatRailpadContact.MAC', -X_coord_max, -X_coord_min
		*ELSE !Geen railpad
			*USE, '%Scriptfolder(1)%/Contact/createRughellingplaatRailContact.MAC', -X_coord_max, -X_coord_min
		*ENDIF
	*ENDIF
	
	startX_coord = SleeperDistance*SleeperIndex !update start coordinate
*ENDDO

CSYS, 0

*DEL, SleeperIndex
*DEL, X_coord_min
*DEL, X_coord_max
*DEL, startX_coord