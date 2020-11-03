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
G_index_file(1) = 'ValidationAnalysis' !Optional Set to current filename to track back the parameters file to this index file.
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
/INPUT, ValidationLoading15_30_60_vertical, f, '%BaseFolder(1)%\Loads' , 0, 1 !Load custom load settings
!K_foundation = K_foundation*1000 !Default. Times 100

! ----------------------------------------------------------
! -------------------- Analysis loading: -------------------

! ------- Bad foundation
WorkingDirectoryNameAddition(1) = '' !'[extra text to differentiate each analysis]' !Directory name addition to general folder:
fundering_Multiplier_size = 3
fundering_Ondersteund_size = 1
*DIM, MultiplierOndersteundArr, ARRAY, fundering_Multiplier_size
*DIM, OndersteundPercentageArr, ARRAY, fundering_Ondersteund_size
MultiplierOndersteundArr(1) = 100, 1000, 10000 
OndersteundPercentageArr(1) = 0.0769 !Gives a center portion of 200 mm


*DO, i_index, 1, fundering_Multiplier_size, 1 !iterate over all the nodes.
	*DO, j_index, 1, fundering_Ondersteund_size, 1 !iterate over all the nodes.
		fundering_MultiplierOndersteund = MultiplierOndersteundArr(i_index) !Global, to be used in the analysis-file
		fundering_OndersteundPercentage = OndersteundPercentageArr(j_index) !Global, to be used in the analysis-file

		*IF, fundering_MultiplierOndersteund, GT, 0.0001, AND, fundering_OndersteundPercentage, GT, 0.0001, THEN
			!Bad foundation to mimic a 3 point bending test.
			W_Divisions = 2
			*USE, %RunAnalysisMacroName(1)%, analysisType_, 'PE_201', 'PE_2D_f_%fundering_OndersteundPercentage%_%fundering_MultiplierOndersteund%', skipsolve_all
			*USE, %RunAnalysisMacroName(1)%, analysisType_, 'HDPE_202', 'HDPE_2D_f_%fundering_OndersteundPercentage%_%fundering_MultiplierOndersteund%', skipsolve_all
			
			K_foundation = K_foundation*10
			*USE, %RunAnalysisMacroName(1)%, analysisType_, 'PE_201', 'PE_2D_10K_f_%fundering_OndersteundPercentage%_%fundering_MultiplierOndersteund%', skipsolve_all
			*USE, %RunAnalysisMacroName(1)%, analysisType_, 'HDPE_202', 'HDPE_2D_10K_f_%fundering_OndersteundPercentage%_%fundering_MultiplierOndersteund%', skipsolve_all
			!W_Divisions = 3
			!*USE, %RunAnalysisMacroName(1)%, analysisType_, 'PE_201', 'PE_201_3D_foundation_%fundering_OndersteundPercentage%_%fundering_MultiplierOndersteund%', skipsolve_all
			!*USE, %RunAnalysisMacroName(1)%, analysisType_, 'HDPE_202', '202_HDPE_3D_foundation_%fundering_OndersteundPercentage%_%fundering_MultiplierOndersteund%', skipsolve_all
		*ENDIF
	*ENDDO
*ENDDO

/GO
T = 'Finished'
