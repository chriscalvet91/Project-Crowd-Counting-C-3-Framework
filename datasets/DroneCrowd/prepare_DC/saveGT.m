clear, clc, close all;
setName = 'train'; % train set or test set
seqList = importdata([setName 'list.txt']);

for k = 1:length(seqList)
    disp(['processing the ' num2str(k) '-th sequence...']);
    trainID = seqList(k);
    seqName = sprintf('%05d',trainID);
    annoPath = 'annotations\'; % annotation path
    newPath = [setName '_data\'];
    [anno, countNum, label] = xml2mat(annoPath, seqName);
    for i = 1:300
        idx = anno(:,1)==i-1;
        image_info = cell(1);
        number = nnz(idx);
        location = [(anno(idx,3)+anno(idx,5))/2, (anno(idx,4)+anno(idx,6))/2, anno(idx,2)+1];
        image_info{1}.location = location;
        image_info{1}.number = number;
        save([newPath '\ground_truth\GT_' sprintf('img%03d%03d',trainID,i) '.mat'], 'image_info');
    end
end