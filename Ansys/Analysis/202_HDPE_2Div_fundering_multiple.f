*DIM, analysisFilename, STRING, 200
analysisFilename(1) = '202_HDPE_2Div_fundering_multiple'

! GeometryFile(1) = 'KLP_Rechthoek'
! SleeperType = '202'

Materiaal_S = Kunststof_HDPE
Materiaal_W = Staal
Materiaal_RH = Staal
Materiaal_Rail = Staal
AantalSleepers = 10

LoadLocation_X = 0
W_Divisions = 2

MakeUseOfSymmetry = 'false'
*DEL, Sleepers, NOPR
*DIM, Sleepers, Array, 6, AantalSleepers

! Tabel met data voor elke individuele ligger. 1) type-model [1 = KLP_Rechthoek, 2 = KLP_Rechthoek_Simple] 2) type-ligger, 3) divisions, 4) foundation
Sleepers(1,1) = 1, 202, W_Divisions, K_foundation, fundering_OndersteundPercentage, fundering_MultiplierOndersteund

!Octagonal reinforcement from here on:
Sleepers(1,2) = 2, 202, 2, K_foundation, fundering_OndersteundPercentage, fundering_MultiplierOndersteund
Sleepers(1,3) = 2, 202, 2, K_foundation, fundering_OndersteundPercentage, fundering_MultiplierOndersteund
Sleepers(1,4) = 2, 202, 1, K_foundation, fundering_OndersteundPercentage, fundering_MultiplierOndersteund
Sleepers(1,5) = 2, 202, 1, K_foundation, fundering_OndersteundPercentage, fundering_MultiplierOndersteund
Sleepers(1,6) = 2, 202, 1, K_foundation, fundering_OndersteundPercentage, fundering_MultiplierOndersteund
Sleepers(1,7) = 2, 202, 1, K_foundation, fundering_OndersteundPercentage, fundering_MultiplierOndersteund
Sleepers(1,8) = 2, 202, 1, K_foundation, fundering_OndersteundPercentage, fundering_MultiplierOndersteund
Sleepers(1,9) = 2, 202, 1, K_foundation, fundering_OndersteundPercentage, fundering_MultiplierOndersteund
Sleepers(1,10) = 2, 202, 1, K_foundation, fundering_OndersteundPercentage, fundering_MultiplierOndersteund