function [anno, countNum, label] = xml2mat(annoPath, seqName) 

matfile = [annoPath seqName '.mat'];
if(exist(matfile, 'file'))
    load(matfile);
    return;
end

xmlfilename = [annoPath, seqName '.xml'];
xDoc = xmlread(xmlfilename);
xRoot = xDoc.getDocumentElement();
track = xRoot.getElementsByTagName('track');
count = char(xRoot.getAttribute('count'));
countNum = str2double(count);
anno = [];
for i = 0:countNum-1
    thisItem = track.item(i);
    label = char(thisItem.getAttribute('label')); 
    id = str2double(char(thisItem.getAttribute('id')));        
    childNode = thisItem.getFirstChild;
    childNode = childNode.getNextSibling;
    while ~isempty(childNode)   
        frame = str2double(char(childNode.getAttribute('frame')));
        xtl =  str2double(char(childNode.getAttribute('xtl')));
        ytl =  str2double(char(childNode.getAttribute('ytl')));
        xbr =  str2double(char(childNode.getAttribute('xbr')));
        ybr =  str2double(char(childNode.getAttribute('ybr')));
        outside =  str2double(char(childNode.getAttribute('outside')));
        occluded = str2double(char(childNode.getAttribute('occluded')));
        if(outside~=1 && occluded~=1)
            anno = cat(1, anno, [frame id xtl ytl xbr ybr]);
        end 
        childNode = childNode.getNextSibling;
        childNode = childNode.getNextSibling; 
    end  % End WHILE        
end

save(matfile, 'anno', 'countNum', 'label');