/PREP7 !start preprocessor
/NOPR

AantalMaterialen = 14
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
MaterialDatabase(1,8) = 'KLP_PE_min_250'
MaterialDatabase(1,9) = 'KLP_PE_330'
MaterialDatabase(1,10) = 'KLP_PE_max_400'
MaterialDatabase(1,11) = 'KLP_HS_min_650'
MaterialDatabase(1,12) = 'KLP_HS_900'
MaterialDatabase(1,13) = 'KLP_HS_max_1250'
MaterialDatabase(1,14) = 'KLP_CustomE'

*USE, '%MaterialFolder(1)%/Macros/LoadMaterials.MAC'

*DEL, AantalMaterialen
*DEL, material_index
*DEL, MaxMatNr
/GO
