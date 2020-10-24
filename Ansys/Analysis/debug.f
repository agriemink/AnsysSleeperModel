*DIM, analysisFilename, STRING, 200
analysisFilename(1) = 'debug'

!GeometryFile(1) = 'KLP_Rechthoek_Simple'
!SleeperType = '202'

Materiaal_S = Kunststof_PE
Materiaal_W = Staal
Materiaal_RH = Staal
Materiaal_Rail = Staal
AantalSleepers = 2

LoadLocation_X = 0.3
W_Divisions = 3


MakeUseOfSymmetry = 'false'
*DEL, Sleepers, NOPR
*DIM, Sleepers, Array, 6, AantalSleepers

! Tabel met data voor elke individuele ligger. 
!1) type-model [1 = KLP_Rechthoek, 2 = KLP_Rechthoek_Simple]
!2) type-ligger, 
!3) divisions, 
!4) foundation K-discrete total sleeper stiffness
!5) foundation_supported_area_factor center-piece of the foundation as factor of the total length. E.g. for a value of 0.4, the center portion [0.4 * S_lengte] is supported by K_d/length times the foundation_supported_area_multiplier
!6) foundation_supported_area_multiplier 
Sleepers(1,1) = 2, 202, 2, K_foundation, 0.5, 1.1
Sleepers(1,2) = 1, 202, W_Divisions, K_foundation, 0.5, 1.1

!--------------------------------
! Materiaal_S = Kunststof_HDPE
! Materiaal_W = Staal
! Materiaal_RH = Staal
! Materiaal_Rail = Staal

! LoadLocation_X = 0
! !AantalSleepers = 10 !2N -1 = 19 liggers
! !W_Divisions = 2 

! SKIPSOLVE = 'FAlse'
! !SKIPSOLVE = 'TRUE'


! !TEST:
! AantalSleepers = 1
! MakeUseOfSymmetry = ''
! !MakeUseOfSymmetry = 'true'
! *DEL, Sleepers, NOPR
! *DIM, Sleepers, Array, 4, AantalSleepers

! ! Tabel met data voor elke individuele ligger. 1) type-model [1 = KLP_Rechthoek, 2 = KLP_Rechthoek_Simple] 2) type-ligger, 3) divisions, 4) foundation
! Sleepers(1,1) = 2, 201, 2, K_foundation
! !Sleepers(1,2) = 1, 201, 2, K_foundation
! !Sleepers(1,3) = 2, 201, 2, K_foundation
! !Sleepers(1,4) = 2, 201, 1, K_foundation
! !Sleepers(1,2) = 2, 202, 2, K_foundation
! !Sleepers(1,3) = 2, 202, 2, K_foundation
! !Sleepers(1,4) = 2, 202, 1, K_foundation
! !Sleepers(1,5) = 2, 202, 1, K_foundation
! !AantalSleepers = 1
! !*DEL, Sleepers
! !AantalSleepers = 2
! !*DIM, Sleepers, Array, 4, AantalSleepers

! !Sleepers(1,1) = 1, 202, 2, K_foundation
! !Sleepers(1,2) = 2, 202, 4, K_foundation

! ! 1) SleeperModel, simple (1) or standard (2)
! !t = %Sleepers(4,1)%
! !

! !
! !
! ! TODO, create option to insert specific sleepers on specific places. E.g. the middle sleeper of type standaard and the rest simple 2DIV.