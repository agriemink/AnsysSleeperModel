FINISH
/CLEAR
/GO


*DO, Boilerplate, 0, 1
	!Essentials ------------------------------------------------
	Drive = 'O'
	*DIM,BaseFolder,STRING,200
	BaseFolder(1) = '%Drive%:\AnsysSleeperModel\Ansys'
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
G_index_file(1) = 'Index.f' !Set to current filename to track back the parameters file to this index file.
WorkingDirectoryName(1) = 'AnalysisLojda' !Directory name for results

!Do or not solve each model, 'TRUE' skips the solve action.
skipsolve_all = 'FALSE' 


!Type of analysis, 'modal' or 'static'
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
WorkingDirectoryNameAddition(1) = '' !Directory name addition to general folder:

! ----------------------------------------------------------
*DO, Boilerplate, 0, 1
	Working_Directory(1) = '%General_Working_Directory(1)%%WorkingDirectoryNameAddition(1)%'
	/MKDIR, %Working_Directory(1)%	!Make a folder for the different analysis
	/CWD, '%Working_Directory(1)%' 	!Set working directory to default.
	*EXIT
*ENDDO


! ----------------------------------------------------------
! -------------------- Analysis loading: -------------------

! analysis index-file should be a existing file in the analysis-folder. 
! The 'simulatienaam' can be a custom name.
!								 Type analyse, 	analyse index-file, 	simulatienaam,  		skipsolve: true || false
! %RunAnalysisMacroName(1)% is set in LoadGlobals ('%Scriptfolder(1)%/RunAnalysis.MAC')
!*USE, %RunAnalysisMacroName(1)%, analysisType_, '202_HDPE_Simple_2DIV', '202_HDPE_Simple_2DIV', skipsolve_all
!*USE, %RunAnalysisMacroName(1)%, analysisType_, '202_HDPE_2Div', '202_HDPE_2Div', skipsolve_all
!*USE, %RunAnalysisMacroName(1)%, analysisType_, '202_Hout_2Div', '202_Hout_2Div', skipsolve_all
!*USE, %RunAnalysisMacroName(1)%, analysisType_, '202_Beton_2Div', '202_Beton_2Div', skipsolve_all

!*USE, %RunAnalysisMacroName(1)%, analysisType_, '202_HDPE_Simple_3Div', '202_HDPE_Simple_3Div', skipsolve_all
!*USE, %RunAnalysisMacroName(1)%, analysisType_, '202_HDPE_Simple_4Div', '202_HDPE_Simple_4Div', skipsolve_all

*USE, %RunAnalysisMacroName(1)%, analysisType_, '201_PE_Simple_2DIV', '201_PE_Simple_2DIV', skipsolve_all
!*USE, %RunAnalysisMacroName(1)%, analysisType_, '201_PE_2DIV', '201_PE_2DIV', skipsolve_all

! ----------------------------------------------------------------------------------
! ----------------------------------------------------------------------------------
! ------------------------ Bad Foundations single sleepers -------------------------
! ----------------------------------------------------------------------------------
! ----------------------------------------------------------------------------------

! !Create folder for analysis and specify a name.
! ! ----------------------------------------------------------
! ! ------------- Analysis specific parameters: --------------
! WorkingDirectoryNameAddition(1) = 'BadFoundations' !Directory name addition to general folder:

! ! ----------------------------------------------------------
! *DO, Boilerplate, 0, 1
	! Working_Directory(1) = '%General_Working_Directory(1)%%WorkingDirectoryNameAddition(1)%'
	! /MKDIR, %Working_Directory(1)%	!Make a folder for the different analysis
	! /CWD, '%Working_Directory(1)%' 	!Set working directory to default.
	! *EXIT
! *ENDDO

! !								 Type analyse, analyse index-file, simulatienaam,  skipsolve: true || false
! !--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
! fundering_Multiplier_size = 3
! fundering_Ondersteund_size = 4
! *DIM, MultiplierOndersteundArr, ARRAY, fundering_Multiplier_size
! *DIM, OndersteundPercentageArr, ARRAY, fundering_Ondersteund_size
! MultiplierOndersteundArr(1) = 10, 100, 1000
! OndersteundPercentageArr(1) = 0.1, 0.19231, 0.25, 0.5


! *DO, i_index, 1, fundering_Multiplier_size, 1 !iterate over all the nodes.
	! *DO, j_index, 1, fundering_Ondersteund_size, 1 !iterate over all the nodes.
		! fundering_MultiplierOndersteund = MultiplierOndersteundArr(i_index)
		! fundering_OndersteundPercentage = OndersteundPercentageArr(j_index)

		! *IF, fundering_MultiplierOndersteund, GT, 0.0001, AND, fundering_OndersteundPercentage, GT, 0.0001, THEN
			! *USE, %RunAnalysisMacroName(1)%, analysisType_, '202_HDPE_2Div_fundering', '202_HDPE_foundation_%fundering_OndersteundPercentage%_%fundering_MultiplierOndersteund%', skipsolve_all
		! *ENDIF
	! *ENDDO
! *ENDDO
! *DEL, MultiplierOndersteundArr
! *DEL, OndersteundPercentageArr


Finished = 'true'
