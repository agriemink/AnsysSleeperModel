*DIM, analysisFilename, STRING, 200
analysisFilename(1) = '202_HDPE_Multiple_LeastElements'

Materiaal_S = Kunststof_HDPE
Materiaal_W = Staal
Materiaal_RH = Staal
Materiaal_Rail = Staal

LoadLocation_X = 0 	!Location of loading on the rail.
AantalSleepers = 10 !2N -1 = 19 liggers
W_Divisions = 2 	!Divisions of reinforcement. This defines the amount of elements in the sleeper.

MakeUseOfSymmetry = 'false' !Use symmetry, when uses a symmetry boundary is used and a half sleeper is moddelled.
*DEL, Sleepers, NOPR
*DIM, Sleepers, Array, 10, AantalSleepers

! Tabel met data voor elke individuele ligger. 
! 1) type-model [1 = KLP_Rechthoek, 2 = KLP_Rechthoek_Simple],
! 2) type-ligger, 
! 3) divisions, 
! 4) foundation, K_d of the sleeper
Sleepers(1,1) = 1, 202, 2, 				K_foundation
Sleepers(1,2) = 1, 202, 2, 				K_foundation
Sleepers(1,3) = 2, 202, 2, 				K_foundation
Sleepers(1,4) = 2, 202, 1, 				K_foundation
Sleepers(1,5) = 2, 202, 1, 				K_foundation
Sleepers(1,6) = 2, 202, 1, 				K_foundation
Sleepers(1,7) = 2, 202, 1, 				K_foundation
Sleepers(1,8) = 2, 202, 1, 				K_foundation
Sleepers(1,9) = 2, 202, 1, 				K_foundation
Sleepers(1,10) = 2, 202, 1, 			K_foundation
