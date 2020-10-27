FINISH
/PREP7 !start preprocessor

*DIM,LoadType,STRING,15
LoadType(1) = 'Force' ! 'Displacement'
SKIPSOLVE = 'FALSE'
DOF,UX,UY,UZ,ROTX,ROTY,ROTZ
!----------------------------------------------------------------------
!------- Parameters ---------------------------------------------------
!----------------------------------------------------------------------
!
! Standaard parameters zijn meters, Newton
!
!Sleeper / dwarsligger
S_Lengte = 2.600
S_Breedte = 0.250
S_Hoogte = 0.150

SleeperDistance = 0.6
AantalSleepers = 1

!Rughellingplaat [TKG047648 BL00 versie C - RUGHELLINGPLAAT 54E1 (UIC54) HELLING 1_40 15-301 (Gewalste rug(helling)platen)]
RH_Dikte = 18 / 1000 	!Verschillende tekeningen, bij alle base plates is de dikte in het midden 18 mm.
RH_Lengte = 360 / 1000 	!lengterichting van de dwarsligger 
RH_Breedte = 170 / 1000 !lengterichting van het spoor

!Rail pad
Railpad_thickness = 4.5 / 1000 !4.5 mm, Railpro site

!Foundation (whole sleeper):
!K_foundation = 45000000 !N/m  !From paper from Dollevoet and Zilli = about eqaul to the results in the TU Munchen tests. Here it is 90e6 N/m3 for 5 cycles at 225 kN
K_foundation = 43800000 !N/m or 43.8 kN/m  
Damping_foundation = 32000000 !Ns/m !From paper from Dollevoet and Zilli

!Set for a 10kN/mm per shoulder
K_shoulder = 10000000 !10 Kn/m = 1e6 N/mm
Damping_shoulder = 32000000 !Take the same as foundation

!More or less fixed parameters:
Spoorwijdte = 1.5 !m
Railwijdte = 0.140 !140 mm (Define here or in railprofile?)
Rail_angle_1_20 = 2.86*(3.14159/180) !Equal to rail angle 1:20 !convert degrees to radians !Degrees
Rail_angle_1_40 = 1.43*(3.14159/180) !Equal to rail angle 1:40 !convert degrees to radians !Degrees
Rail_angle = Rail_angle_1_40 !Variable that is used in loading-files
 
!Utility parameters
S_Halve_Lengte = S_Lengte / 2
S_Halve_Breedte = S_Breedte / 2
S_Halve_Hoogte = S_Hoogte / 2

!Default application of loading:
!Provide the distance from the centre / origin. 
LoadLocation_X = 0 !Default
!LoadLocation_X = 1.25 !Halve asafstand

!----------------------------------------------------------------------
!-------Parameters Mesh -----------------------------------------------
!----------------------------------------------------------------------
MSHKEY, 1 !Mapped meshing

ESIZE_standaard = 0.015
ESIZE_BottomRail = 0.015

realSolids = 10 !Set arbitrary number
r, realSolids 
real, realSolids

!----------------------------------------------------------------------
!------- Materialen ---------------------------------------------------
!----------------------------------------------------------------------
/INPUT, DefineMaterialnumbers, f, '%MaterialFolder(1)%/Macros' , 0, 1


!Options: Kunststof_PE, Kunststof_HDPE, Staal, Hout
!Set defaults, this is probably being overwritten by values set in the index files.
Materiaal_S = Kunststof_HDPE
Materiaal_W = Staal
Materiaal_RH = Staal
Materiaal_Rail = Staal
