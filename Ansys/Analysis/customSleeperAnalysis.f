*DIM, analysisFilename, STRING, 200
analysisFilename(1) = 'customSleeperAnalysis' !Optional name. This gets saved as parameter so it is possible to track the results back to this file.

!Use materials as set in the materials folder [DefineMaterialnumber.f]
*IF, Materiaal_S, LT, 0.001, THEN
	Materiaal_S = Kunststof_HDPE
*ENDIF

Materiaal_W = Staal
Materiaal_RH = Staal
Materiaal_Rail = Staal
AantalSleepers = 1 !This is on one side + the middle sleeper, so: 2n - 1 !

LoadLocation_X = 0 !Location of load application.

*IF, W_Divisions, LT, 1, THEN,
	!Default value:
	W_Divisions = 2 !Defines the amount of reinforcement divisions, 2 or 3 works best.
*ENDIF

MakeUseOfSymmetry = 'false' !Option to use only half of the models {Not well tested) 
*DEL, Sleepers, NOPR
*DIM, Sleepers, Array, 6, AantalSleepers !Change to 6 for bad foundation analysis.

! Tabel met data voor elke individuele ligger. 1) type-model [1 = KLP_Rechthoek, 2 = KLP_Rechthoek_Simple] 2) type-ligger, 3) divisions, 4) foundation, 
! optional: 5) foundation_center_size_percentage 6) foundation_multiplier

! Sleepers(1,1) = [1 (circular)|| 2 (octagonal)], [201 || 202], [amount of reinforcement divisions, 2 or 3 works best], [k_d total sleeper stiffness]
Sleepers(1,1) = 1, 0, W_Divisions, K_foundation, fundering_OndersteundPercentage, fundering_MultiplierOndersteund !Use K_foundation as it is an provided default.Other values set in index-file. 

