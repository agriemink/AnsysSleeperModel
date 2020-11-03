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
G_index_file(1) = '[Filename]' !Optional Set to current filename to track back the parameters file to this index file.
![Custom name for directory]
WorkingDirectoryName(1) = 'ResultsMultiple' !Directory name for results, can be any name

!Do or not solve each model, 'TRUE' skips the solve action and only generates the geometry.
skipsolve_all = 'FALSE' 
skipsolve_all = 'TRUE' 

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
! Directory name addition to general folder, can be altered inbetween analysis to seperate them into different folders.
WorkingDirectoryNameAddition(1) = 'Demo' !'[extra text to differentiate each analysis]' 

! ----------------------------------------------------------
*DO, Boilerplate, 0, 1
	Working_Directory(1) = '%General_Working_Directory(1)%_%WorkingDirectoryNameAddition(1)%'
	/MKDIR, %Working_Directory(1)%	!Make a folder for the different analysis
	/CWD, '%Working_Directory(1)%' 	!Set working directory to default.
	*EXIT
*ENDDO

! ----------------------------------------------------------
! ---------------- Global parameter loading: ---------------
fundering_MultiplierOndersteund = 0
fundering_OndersteundPercentage = 0
/INPUT, Loads2LoadCases, f, '%BaseFolder(1)%\Loads' , 0, 1 !Load custom load settings



! ----------------------------------------------------------
! -------------------- Analysis loading: -------------------


! analysis index-file should be a existing file in the analysis-folder. 
! The 'simulatienaam' can be a custom name.
!								 Type analyse, 	analyse index-file, 	simulatienaam,  		skipsolve: true || false
*USE, %RunAnalysisMacroName(1)%, analysisType_, 'MultipleSleeperFoundationExample', '3SleeperExample', skipsolve_all


! Example with changing foundation parameters:
! This example creates 66 analysis
! WorkingDirectoryNameAddition(1) = 'BadFoundation' !'[extra text to differentiate each analysis]' !Directory name addition to general folder:
! fundering_Multiplier_size = 2
! fundering_Ondersteund_size = 2
! *DIM, MultiplierOndersteundArr, ARRAY, fundering_Multiplier_size
! *DIM, OndersteundPercentageArr, ARRAY, fundering_Ondersteund_size
! MultiplierOndersteundArr(1) = 100, 1000 
! OndersteundPercentageArr(1) = 0.5, 0.333


! *DO, i_index, 1, fundering_Multiplier_size, 1 !iterate over all the nodes.
	! *DO, j_index, 1, fundering_Ondersteund_size, 1 !iterate over all the nodes.
		! fundering_MultiplierOndersteund = MultiplierOndersteundArr(i_index) !Global, to be used in the analysis-file
		! fundering_OndersteundPercentage = OndersteundPercentageArr(j_index) !Global, to be used in the analysis-file

		! *IF, fundering_MultiplierOndersteund, GT, 0.0001, AND, fundering_OndersteundPercentage, GT, 0.0001, THEN
			! *USE, %RunAnalysisMacroName(1)%, analysisType_, 'MultipleSleeperFoundationExample', '202_HDPE_foundation_%fundering_OndersteundPercentage%_%fundering_MultiplierOndersteund%', skipsolve_all
		! *ENDIF
	! *ENDDO
! *ENDDO


/GO
T = 'Finished'
