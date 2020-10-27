*DIM, analysisFilename, STRING, 200
analysisFilename(1) = '202_HDPE_Presentation'

!Use materials as set in the materials folder [DefineMaterialnumber.f]
Materiaal_S = Kunststof_HDPE
Materiaal_W = Staal
Materiaal_RH = Staal
Materiaal_Rail = Staal
AantalSleepers = 1

LoadLocation_X = 0
W_Divisions = 1

MakeUseOfSymmetry = 'false'
*DEL, Sleepers, NOPR
*DIM, Sleepers, Array, 4, AantalSleepers !Change to 6 for bad foundation analysis.

! Tabel met data voor elke individuele ligger. 1) type-model [1 = KLP_Rechthoek, 2 = KLP_Rechthoek_Simple] 2) type-ligger, 3) divisions, 4) foundation, 
! optional: 5) foundation_center_size_percentage 6) foundation_multiplier

! Sleepers(1,1) = [1 || 2], [201 || 202], [amount of reinforcement divisions, 2 or 3 works best], [k_d total sleeper stiffness N/mm]
Sleepers(1,1) = 2, 202, 2, 200000 !Use K_foundation as it is an provided default.