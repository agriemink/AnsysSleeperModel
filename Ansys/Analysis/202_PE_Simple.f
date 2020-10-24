*DIM, analysisFilename, STRING, 200
analysisFilename(1) = '201_PE_Simple'

! GeometryFile(1) = 'KLP_Rechthoek_Simple'
! SleeperType = '202'

Materiaal_S = Kunststof_PE
Materiaal_W = Staal
Materiaal_RH = Staal
Materiaal_Rail = Staal
AantalSleepers = 1

LoadLocation_X = 0
W_Divisions = 2


MakeUseOfSymmetry = 'false'
*DEL, Sleepers, NOPR
*DIM, Sleepers, Array, 4, AantalSleepers

! Tabel met data voor elke individuele ligger. 1) type-model [1 = KLP_Rechthoek, 2 = KLP_Rechthoek_Simple] 2) type-ligger, 3) divisions, 4) foundation
Sleepers(1,1) = 2, 202, W_Divisions, K_foundation