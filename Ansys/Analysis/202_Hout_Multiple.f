*DIM, analysisFilename, STRING, 200
analysisFilename(1) = '202_Hout_Multiple'

Materiaal_S = Hout
Materiaal_W = Hout
Materiaal_RH = Staal
Materiaal_Rail = Staal

LoadLocation_X = 0 	!Location of loading on the rail.
AantalSleepers = 10 !2N -1 = 19 liggers
W_Divisions = 2 	!Divisions of reinforcement. This defines the amount of elements in the sleeper.

MakeUseOfSymmetry = 'false' !Use symmetry, when uses a symmetry boundary is used and a half sleeper is moddelled.
*DEL, Sleepers, NOPR
*DIM, Sleepers, Array, 10, AantalSleepers

SleeperType_ = 202
! Tabel met data voor elke individuele ligger. 
! 1) type-model [1 = KLP_Rechthoek, 2 = KLP_Rechthoek_Simple],
! 2) type-ligger, 
! 3) divisions, 
! 4) foundation, K_d of the sleeper
Sleepers(1,1) = 1, SleeperType_, 3, K_foundation
!Octagonal reinforcement from here on:
Sleepers(1,2) = 2, SleeperType_, 3, K_foundation
Sleepers(1,3) = 2, SleeperType_, 2, K_foundation
Sleepers(1,4) = 2, SleeperType_, 1, K_foundation
Sleepers(1,5) = 2, SleeperType_, 1, K_foundation
Sleepers(1,6) = 2, SleeperType_, 1, K_foundation
Sleepers(1,7) = 2, SleeperType_, 1, K_foundation
Sleepers(1,8) = 2, SleeperType_, 1, K_foundation
Sleepers(1,9) = 2, SleeperType_, 1, K_foundation
Sleepers(1,10) = 2, SleeperType_, 1, K_foundation


*DEL, SleeperType_