function [predicted_label, true_labels,dureeTotal,testLabelTot,accuracy] = rwc_classify(instrument_features)

[m,~]=size(instrument_features);
trainSamplesTot=[];
trainLabel1=[];
testSamples=[];
true_labels=[];
testSamplesTot=[];
trainLabelTot=[];
testLabel=[];
testLabelTot=[];
testfinal=[];
dureeTotal=[];
for i=1:m
    temp=instrument_features(i,:);
    idx = cellfun('isempty',temp);
    temp(idx) = [];
    [~,c]=size(temp);
    labels=i;
    groups = (ceil(ones(c,1)))*labels;
    [train,test] = crossvalind('HoldOut',groups, 0.5);
    %%Train
    trainSamples=temp(train);
    [~,c]=size(trainSamples);
    trainSamplesTot=[trainSamplesTot  trainSamples];
    trainLabel=groups(train,1);
    trainLabelTot=[trainLabelTot; trainLabel];
    for z=1:c
        [~,r]=size(trainSamples{z});
        labeltemp=ones(1,r)*i;
        trainLabel1=[trainLabel1 labeltemp];
    end
    %%Test
    testSamples=temp(test);
    [~,c]=size(testSamples);
    testSamplesTot=[testSamplesTot testSamples];
    testLabel=groups(test,1);
    testLabelTot=[testLabelTot;testLabel]
    for o=1:length(testSamples)
        int=testSamples{o};
        [~,z]=size(int);
        dureeTotal=[dureeTotal z];
    end
    for z=1:c
        [~,r]=size(testSamples{z});
        labeltemp=ones(1,r)*i;
        true_labels=[true_labels labeltemp];
    end

end
trainSamplesTot=cell2mat(trainSamplesTot);
testSamplesTot=cell2mat(testSamplesTot);
%     %Création du modèle
    model = svmtrain(trainLabel1', trainSamplesTot' ,'-s 0  -t 2 -c 1 -g 1');
    [predicted_label, accuracy,prob_estimates] = svmpredict(true_labels', testSamplesTot', model);
   
    [A1, V]  = confusionmat(true_labels, predicted_label);
