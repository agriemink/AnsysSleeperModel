*DIM, analysisFilename, STRING, 200
analysisFilename(1) = '201_PE_Standard_3Div'

Materiaal_S = Kunststof_PE
Materiaal_W = Staal
Materiaal_RH = Staal
Materiaal_Rail = Staal
AantalSleepers = 1

LoadLocation_X = 0 	!Location of loading on the rail.
W_Divisions = 3		!Divisions of reinforcement. This defines the amount of elements in the sleeper.

MakeUseOfSymmetry = 'false' !Use symmetry, when uses a symmetry boundary is used and a half sleeper is moddelled.
*DEL, Sleepers, NOPR
*DIM, Sleepers, Array, 4, AantalSleepers

! Tabel met data voor elke individuele ligger. 
! 1) type-model [1 = KLP_Rechthoek, 2 = KLP_Rechthoek_Simple],
! 2) type-ligger, 
! 3) divisions, 
! 4) foundation, K_d of the sleeper
Sleepers(1,1) = 1, 201, W_Divisions, K_foundation