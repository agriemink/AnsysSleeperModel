FINISH
/CLEAR
/GO


*DO, Boilerplate, 0, 1
	!Essentials ------------------------------------------------
	Drive = 'O'
	*DIM,BaseFolder,STRING,200
	BaseFolder(1) = '%Drive%:\Afstuderen\Ansys\_AnsysModel'
	*DIM, Scriptfolder, STRING, 200
	Scriptfolder(1) = '%BaseFolder(1)%\Scripts\Shared'
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
! ------------- General changeable parameters: -------------
G_index_file(1) = 'Index_debug.f' !Set to current filename to track back the parameters file to this index file.
WorkingDirectoryName(1) = 'Debug' !Directory name for results

!Do or not solve each model, 'TRUE' skips the solve action.
skipsolve_all = 'FALSE' 
!skipsolve_all = 'TRUE' 

!Type of analysis, 'modal' or 'static'
analysisType_ = 'modal'  
! ----------------------------------------------------------
! ----------------------------------------------------------


*DO, Boilerplate, 0, 1
	! -------- Folder name of general working directory --------
	General_Working_Directory(1) = '%GlobalWorkingDirectory(1)%%Date_%_%analysisType_%_%WorkingDirectoryName(1)%'
	*EXIT
*ENDDO


! ----------------------------------------------------------
! ------------- Analysis specific parameters: --------------
WorkingDirectoryNameAddition(1) = '' !Directory name addition to general folder:

! ----------------------------------------------------------
*DO, Boilerplate, 0, 1
	Working_Directory(1) = '%General_Working_Directory(1)%_%WorkingDirectoryNameAddition(1)%'
	/MKDIR, %Working_Directory(1)%	!Make a folder for the different analysis
	/CWD, '%Working_Directory(1)%' 	!Set working directory to default.
	*EXIT
*ENDDO

! ----------------------------------------------------------
! -------------------- Analysis loading: -------------------

! analysis index-file should be a existing file in the analysis-folder. 
! The 'simulatienaam' can be a custom name.
*USE, %RunAnalysisMacroName(1)%, analysisType_, 'debug', '202_HDPE_Simple_1Div', skipsolve_all

!*USE, %RunAnalysisMacroName(1)%, analysisType_, '202_HDPE_1Div', '202_HDPE_1Div', skipsolve_all

