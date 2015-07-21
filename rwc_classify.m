function [predicted_label, true_labels,dureeTotal,testLabelTot,accuracy] = rwc_classify(instrument_features)
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
for w=1:length(instrument_features)
    nbfiles=length(instrument_features{w})
    temp=instrument_features{w};
    
    
    [l,~]=size(temp);
    labels=w;
    groups = (ceil(ones(l,1)))*labels;
    [train,test] = crossvalind('HoldOut',groups, 0.5);
    %%Train
    trainSamples=temp(train);
    tailletrainSamples=length(trainSamples);
    trainSamplesTot=[trainSamplesTot;trainSamples];
    trainLabel=groups(train,1);
    trainLabelTot=[trainLabelTot; trainLabel];
    for z=1:tailletrainSamples
        [~,r]=size(trainSamples{z});
        labeltemp=ones(1,r)*w;
        trainLabel1=[trainLabel1 labeltemp];
    end
    %%Test
    testSamples=temp(test);
    tailletestSamples=length(testSamples);
    testSamplesTot=[testSamplesTot;testSamples];
    testLabel=groups(test,1);
    testLabelTot=[testLabelTot;testLabel];
    for z=1:tailletestSamples
        [~,r]=size(testSamples{z});
        labeltemp=ones(1,r)*w;
        true_labels=[true_labels labeltemp];
        dureeTotal=[dureeTotal r];
    end
    
end

trainSamplesTot=cell2mat(trainSamplesTot');
testSamplesTot=cell2mat(testSamplesTot');
%     %Création du modèle
model = svmtrain(trainLabel1', trainSamplesTot' ,'-s 0  -t 2 -c 1 -g 8');
[predicted_label, accuracy,prob_estimates] = svmpredict(true_labels', testSamplesTot', model);

[A1, V]  = confusionmat(true_labels', predicted_label);
