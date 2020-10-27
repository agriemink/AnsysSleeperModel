FINISH
/CLEAR
/GO
!Essentials ------------------------------------------------
Drive = 'O' !Change to own local drive letter
*DIM,GitBaseFolder,STRING,200
GitBaseFolder(1) = '%Drive%:\AnsysSleeperModel' !Change to own path

*DO, Boilerplate, 0, 1
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
! ------------- General changeable parameters: -------------
G_index_file(1) = '[Filename]' !Set to current filename to track back the parameters file to this index file.
WorkingDirectoryName(1) = 'PresentationExample' !Directory name for results

!Do or not solve each model, 'TRUE' skips the solve action.
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
WorkingDirectoryNameAddition(1) = '' !Optional directory name addition to general folder:

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
!								 Type analyse, 	analyse index-file, 	simulatienaam,  		skipsolve: true || false
/INPUT, Loads2LoadCases, f, '%BaseFolder(1)%\Loads' , 0, 1 !Load custom load settings
*USE, %RunAnalysisMacroName(1)%, analysisType_, '202_HDPE_Presentation', 'PresentationExample', skipsolve_all
! fundering_MultiplierOndersteund = 1
! fundering_OndersteundPercentage = 1
! *USE, %RunAnalysisMacroName(1)%, analysisType_, '202_HDPE_PresentationFoundation', '202_HDPE_Multiple', skipsolve_all



! ! Example with changing foundation parameters:
! fundering_Multiplier_size = 3
! fundering_Ondersteund_size = 3
! *DIM, MultiplierOndersteundArr, ARRAY, fundering_Multiplier_size
! *DIM, OndersteundPercentageArr, ARRAY, fundering_Ondersteund_size
! MultiplierOndersteundArr(1) = 10, 100, 1000 
! OndersteundPercentageArr(1) = 0.5, 0.19123, 0.01 


! *DO, i_index, 1, fundering_Multiplier_size, 1 !iterate over all the nodes.
	! *DO, j_index, 1, fundering_Ondersteund_size, 1 !iterate over all the nodes.
		! fundering_MultiplierOndersteund = MultiplierOndersteundArr(i_index) !Global, to be used in the analysis-file
		! fundering_OndersteundPercentage = OndersteundPercentageArr(j_index) !Global, to be used in the analysis-file

		! *IF, fundering_MultiplierOndersteund, GT, 0.0001, AND, fundering_OndersteundPercentage, GT, 0.0001, THEN
			! *USE, %RunAnalysisMacroName(1)%, analysisType_, '202_HDPE_PresentationFoundation', '202_HDPE_foundation_%fundering_OndersteundPercentage%_%fundering_MultiplierOndersteund%', skipsolve_all
		! *ENDIF
	! *ENDDO
! *ENDDO

