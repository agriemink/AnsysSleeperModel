close all;clear;clc;

commonFolder = '20190802_Static\';
outputName = 'Foundationdeformations';
%%Parameters:
basefolder = 'O:\Afstuderen\Ansys\_AnsysModelWorkingDirectory\';

SleeperTypes = {'201_PE'; '202_HDPE'};
Names = {'Simple'; 'Standard'};

% analysis_HDPE = {'202_HDPE_Standard'; '202_HDPE_Simple'};
% analysis_PE = {'201_PE_Standard', '201_PE_Simple'};
% 
% folder_HDPE = strcat(basefolder, commonFolder, '\', analysis_HDPE, '\');
% folder_PE = strcat(basefolder, commonFolder, '\', analysis_PE, '\');


LoadCases = [3; 4];

% result = {};
% S1 = zeros(size(LoadCases,1),size(analysis,1));
% S2 = zeros(size(LoadCases,1),size(analysis,1));
% S3 = zeros(size(LoadCases,1),size(analysis,1));
% SEQV = zeros(size(LoadCases,1),size(analysis,1));
for index = 1:size(LoadCases,1)
    loadCase = LoadCases(index);
 
    %% SleeperTypes = rows
    %results = zeros(size(SleeperTypes,1), size(Names,1));       

   for sleeper = 1:size(SleeperTypes,1); %rows
       
       for analysis_index = 1:size(Names,1); %Columns
         name = sprintf('%s_%s',SleeperTypes{sleeper},Names{analysis_index});

         filename = strcat(basefolder, commonFolder, name, '/', name, '_' ,outputName, '_', num2str(loadCase) ,'_Deformations.csv');

        [Node,S1Nm2,S2Nm2,S3Nm2,SEQVNm2, XYNm2,YZNm2, XZNm2, EQVtotalstrain, EQVelasticstrain ]  = importStressesCSV(filename);      

         data = [(1:size(Node,1))', Node, S1Nm2, S2Nm2, S3Nm2, SEQVNm2];

         index_min = analysis_index*2-1;
         index_max = analysis_index*2;
         
         S1(sleeper, index_min) = min(S1Nm2);
         S1(sleeper, index_max) = max(S1Nm2);
         
         S2(sleeper, index_min) = min(S2Nm2);
         S2(sleeper, index_max) = max(S2Nm2);
         
         S3(sleeper, index_min) = min(S3Nm2);
         S3(sleeper, index_max) = max(S3Nm2);
		          
         SEQV(sleeper, index_min) = min(SEQVNm2);
         SEQV(sleeper, index_max) = max(SEQVNm2);
		 
		 XY(sleeper, index_min) = min(XYNm2);
         XY(sleeper, index_max) = max(XYNm2);
         
         YZ(sleeper, index_min) = min(YZNm2);
         YZ(sleeper, index_max) = max(YZNm2);
         
         XZ(sleeper, index_min) = min(XZNm2);
         XZ(sleeper, index_max) = max(XZNm2);
         
         header{1,index_min} = Names{analysis_index};
         subheader{1,index_min} = 'Min';
         subheader{1,index_max} = 'Max';

        
       end
   end    
    tab = strcat('Load case ', num2str(loadCase));
    xlswrite('Stresses',{'SEQV'}, tab, 'A1');
    xlswrite('Stresses',SleeperTypes, tab, 'A3');
    xlswrite('Stresses',header, tab, 'B1');
    xlswrite('Stresses',subheader, tab, 'B2');
    xlswrite('Stresses',SEQV, tab, 'B3');

    xlswrite('Stresses',{'S1'}, tab, 'G1');
    xlswrite('Stresses',SleeperTypes, tab, 'G3');
    xlswrite('Stresses',header, tab, 'H1');
    xlswrite('Stresses',subheader, tab, 'H2');
    xlswrite('Stresses',S1, tab, 'H3');

    xlswrite('Stresses',{'S2'}, tab, 'M1');
    xlswrite('Stresses',SleeperTypes, tab, 'M3');
    xlswrite('Stresses',header, tab, 'N1');
    xlswrite('Stresses',subheader, tab, 'N2');
    xlswrite('Stresses',S2, tab, 'N3');

    xlswrite('Stresses',{'S3'}, tab, 'S1');
    xlswrite('Stresses',SleeperTypes, tab, 'S3');
    xlswrite('Stresses',header, tab, 'T1');
    xlswrite('Stresses',subheader, tab, 'T2');
    xlswrite('Stresses',S3, tab, 'T3');
	
	 xlswrite('Stresses',{'XY'}, tab, 'Y1');
    xlswrite('Stresses',SleeperTypes, tab, 'Y3');
    xlswrite('Stresses',header, tab, 'Z1');
    xlswrite('Stresses',subheader, tab, 'Z2');
    xlswrite('Stresses',XY, tab, 'Z3');

    xlswrite('Stresses',{'YZ'}, tab, 'AE1');
    xlswrite('Stresses',SleeperTypes, tab, 'AE3');
    xlswrite('Stresses',header, tab, 'AF1');
    xlswrite('Stresses',subheader, tab, 'AF2');
    xlswrite('Stresses',YZ, tab, 'AF3');

    xlswrite('Stresses',{'XZ'}, tab, 'AK1');
    xlswrite('Stresses',SleeperTypes, tab, 'AK3');
    xlswrite('Stresses',header, tab, 'AL1');
    xlswrite('Stresses',subheader, tab, 'AL2');
    xlswrite('Stresses',XZ, tab, 'AL3');
end



