FINISH
/CLEAR
/GO

!Essentials ------------------------------------------------
Drive = 'O' !Change to own local drive letter
*DIM,GitBaseFolder,STRING,200
GitBaseFolder(1) = '%Drive%:\AnsysSleeperModel' !Change to own path

*DO, Boilerplate, 0, 1
	!These folders should be fine and do not have to be changed
	*DIM,BaseFolder,STRING,200
	BaseFolder(1) = '%GitBaseFolder(1)%\Ansys'
	*DIM, Scriptfolder, STRING, 200
	Scriptfolder(1) = '%BaseFolder(1)%\Scripts\General'
	!Load global folder and filenames:
	*USE, '%Scriptfolder(1)%/LoadGlobals.MAC'

	! ----------------------------------------------------------
	! -------------------- Init variables: ---------------------
	*DIM, G_index_file, STRING, 80
	*DIM,WorkingDirectoryNameAddition,STRING,80
	
	*get,Date_,active,,date	! GET current DATE
	*EXIT
*ENDDO

! ----------------------------------------------------------
! ------------- General adjustable parameters: -------------
G_index_file(1) = 'MultipleSleeperVerification' !Optional Set to current filename to track back the parameters file to this index file.
![Custom name for directory]
WorkingDirectoryName(1) = 'Validation' !Directory name for results

!Do or not solve each model, 'TRUE' skips the solve action and only generates the geometry.
skipsolve_all = 'FALSE' 
!skipsolve_all = 'TRUE' 

!Type of analysis, 'modal' or 'static'
!analysisType_ = 'modal' 
analysisType_ = 'static' 
! ----------------------------------------------------------
! ----------------------------------------------------------

*DO, Boilerplate, 0, 1
	! -------- Folder name of general working directory --------
	General_Working_Directory(1) = '%GlobalWorkingDirectory(1)%%Date_%_%analysisType_%_%WorkingDirectoryName(1)%'
	*EXIT
*ENDDO

! ----------------------------------------------------------
! ------------- Analysis specific parameters: --------------
WorkingDirectoryNameAddition(1) = '' !'[extra text to differentiate each analysis]' !Directory name addition to general folder:

! ----------------------------------------------------------
*DO, Boilerplate, 0, 1
	Working_Directory(1) = '%General_Working_Directory(1)%_%WorkingDirectoryNameAddition(1)%'
	/MKDIR, %Working_Directory(1)%	!Make a folder for the different analysis
	/CWD, '%Working_Directory(1)%' 	!Set working directory to default.
	*EXIT
*ENDDO

! ----------------------------------------------------------
! ---------------- Global parameter loading: ---------------
!/INPUT, ValidationLoading15_30_60_vertical, f, '%BaseFolder(1)%\Loads' , 0, 1 !Load custom load settings
!K_foundation = K_foundation*1000 !Default. Times 100
W_Divisions = 2
K_foundation = 90*1000000 !N/m !Equal to an foundation modulus C of 0.1385 N/mm3 !90 N/m



fundering_OndersteundPercentage = 1 !Standard foundation
fundering_MultiplierOndersteund = 1 !Standard foundation
! -------------------------------------------------------------
! --------------- General tests multiple sleepers: ------------
! -------------------------------------------------------------
WorkingDirectoryNameAddition(1) = 'MultipleSleeperVerification'
*DO, Boilerplate, 0, 1
	Working_Directory(1) = '%General_Working_Directory(1)%_%WorkingDirectoryNameAddition(1)%'
	/MKDIR, %Working_Directory(1)%	!Make a folder for the different analysis
	/CWD, '%Working_Directory(1)%' 	!Set working directory to default.
	*EXIT
*ENDDO

/INPUT, MultipleSleeperVerificationLoads, f, '%BaseFolder(1)%\Loads' , 0, 1 !Load custom load settings

/INPUT, parameters_202, f, '%BaseFolder(1)%\Parameters' , 0, 1 !Load 202 sleeper type variables
Materiaal_S = Kunststof_E ! Set to custom material.
Custom_E = 1000e6 !
*USE, %RunAnalysisMacroName(1)%, analysisType_, 'MultipleSleeper', '202_multiple', skipsolve_all

/INPUT, parameters_201, f, '%BaseFolder(1)%\Parameters' , 0, 1 !Load 201 sleeper type variables
Materiaal_S = Kunststof_E ! Set to custom material.
Custom_E = 400e6
*USE, %RunAnalysisMacroName(1)%, analysisType_, 'MultipleSleeper', '201_multiple', skipsolve_all




/GO
T = 'Finished'
