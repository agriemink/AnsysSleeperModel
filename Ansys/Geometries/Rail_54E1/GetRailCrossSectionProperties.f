!Boilerplate:
Drive = 'O'
*DIM,BaseFolder,STRING,200
BaseFolder(1) = '%Drive%:\Afstuderen\Ansys\_AnsysModel'
*DIM, Scriptfolder, STRING, 200
Scriptfolder(1) = '%BaseFolder(1)%\Scripts\Shared'
!Load global folder and filenames:
*USE, '%Scriptfolder(1)%/LoadGlobals.MAC'

!Creater rail and gather cross sectional properties:
*USE, 'O:\Afstuderen\Ansys\_AnsysModel\Geometries\Rail_54E1\CreateRail.MAC'
ASUM !https://www.mm.bme.hu/~gyebro/files/ans_help_v182/ans_cmd/Hlp_C_ASUM.html