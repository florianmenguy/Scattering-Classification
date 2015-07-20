function [mean_accuracy, confusion_matrix,matrixDeci] = rwc_evaluate(predicted_label, true_labels,dureeTotal,testLabelTot)


position=0;
 matrixDeci=[];
% 
comp=[];
for i=1:length(dureeTotal)
    for j=(1+position):sum(dureeTotal(1:i))
        
        comp=[comp predicted_label(j)];
        
        
    end
    matrixDeci(i)=mode(comp,2);
    comp=[ ];
     position=sum(testLabelTot(1:i));
end
 mean_accuracy=(mean(grp2idx(matrixDeci)==grp2idx(testLabelTot)))*100;%Mesure de l'erreur moyenne sur la sortie du classifieur
%                                                 %par rapport à l'ensemble
%                                                 %de test de départ
   [confusion_matrix,order] = confusionmat(matrixDeci,testLabelTot); 
