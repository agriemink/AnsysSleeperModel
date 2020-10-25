/PREP7 !start preprocessor
/NOPR

AantalMaterialen = 7
!*DEL, MaterialDatabase
!*DEL, Materials
*DIM, MaterialDatabase, string, 50, AantalMaterialen
*DIM, Materials, Array, AantalMaterialen

!Entry should be equal to file name.
!And entry itself has to provide the name of the material.
MaterialDatabase(1,1) = 'Staal'
MaterialDatabase(1,2) = 'KLP_PE_Lojda'
MaterialDatabase(1,3) = 'KLP_HS_Lojda'
MaterialDatabase(1,4) = 'Railpad'
MaterialDatabase(1,5) = 'Hout'
MaterialDatabase(1,6) = 'Beton'
MaterialDatabase(1,7) = 'Ballast'


*USE, '%MaterialFolder(1)%/Macros/LoadMaterials.MAC'




! !---------------- Staal --------------------------------
! Staal = 1 !Material number steel
! MaterialDatabase(1,Staal) = 'Staal'
! /INPUT, Staal, f, %MaterialFolder(1)% , 0, 1 

! !---------------- KLP PE -------------------------------
! Kunststof_PE = 2 !Material number kunststof
! MaterialDatabase(1,Kunststof_PE) = 'PE'
! /INPUT, KLP_PE, f, %MaterialFolder(1)% , 0, 1

! !---------------- KLP HDPE -----------------------------
! Kunststof_HDPE = 3 !Material number kunststof
! MaterialDatabase(1,Kunststof_HDPE) = 'HDPE'
! /INPUT, KLP_HS, f, %MaterialFolder(1)% , 0, 1

! !---------------- Staal --------------------------------
! Hout = 4 !Material number hout
! MaterialDatabase(1,Hout) = 'Hout'
! /INPUT, Hout, f, %MaterialFolder(1)% , 0, 1		!An-Isotroop Hout

! !---------------- Staal --------------------------------
! Kunststof_HDPE_weak = 5 !Material number kunststof
! MaterialDatabase(1,Kunststof_HDPE_weak) = 'HDPE_weak'
! /INPUT, Kunststof_HDPE_weak, f, %MaterialFolder(1)% , 0, 1	!Kunststof HS - 5% weakest Youngs' modulus

! !---------------- Staal --------------------------------
! Kunststof_HDPE_stiff = 6 !Material number kunststof
! MaterialDatabase(1,Kunststof_HDPE_stiff) = 'HDPE_stiff'
! /INPUT, Kunststof_HDPE_stiff, f, %MaterialFolder(1)% , 0, 1	!Kunststof HS - 5% toughest Youngs' modulus


! !---------------- KUNSTSTOF_HDPE_1060 ------------------
! KUNSTSTOF_HDPE_1060 = 7 !Material number kunststof 5Hz loading rate
! MaterialDatabase(1,KUNSTSTOF_HDPE_1060) = 'HDPE_1060'
! /INPUT, 'KLP_HS - 1060', f, %MaterialFolder(1)% , 0, 1	!Kunststof HS

! !---------------- Railpad ------------------
! Railpad = 8
! MaterialDatabase(1,Railpad) = 'Railpad'
! /INPUT, 'Railpad', f, %MaterialFolder(1)% , 0, 1	!Kurkachtig elastisch materiaal

! !---------------- Railpad ------------------
! Beton = 9
! MaterialDatabase(1,Beton) = 'Beton'
! /INPUT, 'Beton', f, %MaterialFolder(1)% , 0, 1	


*DEL, AantalMaterialen
*DEL, material_index
*DEL, MaxMatNr
/GO
