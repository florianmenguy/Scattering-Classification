clear all;
clc;
close all;

 rng(0)
load('nomaxScale.mat');
instrument={'Ba' 'Bo' 'Cl' 'Co' 'Fh' 'Fl' 'Ob' 'Pn' 'Sa' 'Ta' 'Tb' 'Tr' 'Va' 'Vl'};

S_MatrixStdTestTotal=[];
testLabelTotal=[];
finalvoteTotal=[];
S_MatrixStdTrainTotal=[];
trainLabelTotal=[];
testLabelfinal=[];

%Test
for ii=1:length(instrument)
nomFichier = [instrument{1,ii}];
finalvoteTotal=[finalvoteTotal , eval(['finalvote' nomFichier])];
testLabelTotal=[testLabelTotal ,  ones(1,length(eval(['S_matrixStdTest' nomFichier])))*ii];
S_MatrixStdTestTotal=[S_MatrixStdTestTotal , eval(['S_matrixStdTest' nomFichier])];
testLabelfinal=[testLabelfinal ; eval(['testLabel' nomFichier])];
end

%Train
for zz=1:length(instrument)
nomFichier = [instrument{1,zz}];
S_MatrixStdTrainTotal=[S_MatrixStdTrainTotal , eval(['S_matrixStdTrain' nomFichier])];
trainLabelTotal=[trainLabelTotal , ones(1,length(eval(['S_matrixStdTrain' nomFichier])))*zz];
end
S_MatrixStdTrainTotal=S_MatrixStdTrainTotal';
S_MatrixStdTestTotal=S_MatrixStdTestTotal';
% trainSamples=dataTrain';%Création des données d'entrainement 
% trainLabel=labelTrain;%Création des labels d'entrainement 
% testSamples=dataTest';%Création des données de test 
% testLabel=labelTest;%Création des labels de test
% Test=ones(1,length(testLabel));
imagesc(testLabelTotal')
%folds=4;
% cv_acc= svmtrain(trainLabel, trainSamples, ...
%                      sprintf('-c 1 -g 4 -v %d ',  folds));

model = svmtrain(trainLabelTotal', S_MatrixStdTrainTotal,'-s 0  -t 2 -c 1 -g 1');
%svm_savemodel(model, 'mymodel.model');
% 
 [predicted_label, accuracy,prob_estimates] = svmpredict(testLabelTotal', S_MatrixStdTestTotal, model);
predicted_label=predicted_label';
[A1, V]  = confusionmat(testLabelTotal', predicted_label);
% 
 position=0;
 cor=[];
% 
comp=[];
for i=1:length(finalvoteTotal)
    for j=(1+position):sum(finalvoteTotal(1:i))
        
        comp=[comp predicted_label(j)];
        
        
    end
    cor(i)=mode(comp,2);
    comp=[ ];
     position=sum(finalvoteTotal(1:i));
end
 acc=(mean(grp2idx(cor)==grp2idx(testLabelfinal)))*100;%Mesure de l'erreur moyenne sur la sortie du classifieur
%                                                 %par rapport à l'ensemble
%                                                 %de test de départ
   [A2,order] = confusionmat(cor,testLabelfinal); 
% 

