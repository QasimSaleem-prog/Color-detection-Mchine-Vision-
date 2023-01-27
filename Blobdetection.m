%%
% written by qasimsaleem 2019-mc-26 
% Machine vision project-I

clc;clear;close
q1=imread('coloredChips.png'); %reading the image
imshow(q1); %showing the image
check=0;
while check==0
[x,y] = ginput(1); % allowing only one click
x=floor(x);y=floor(y); %coverting to floor datatype
redV = q1(y,x,1); greenV = q1(y,x,2); blueV = q1(y,x,3); %rgb values from x,y coordinates
R = q1(:,:,1);  G = q1(:,:,2); B = q1(:,:,3); %separating RGB planes
lutR = zeros(1,256); %lookup table for red
lutG = zeros(1,256); %lookup table for green
lutB = zeros(1,256); %lookup table for blue

%applying conditions for different colors
if redV>190 && redV<256 && greenV<60 && blueV>15 && blueV<100 %for red color
     color = 'Red';
    lutR(1,200:256) = 255;
    lutG(1,1:55) = 255;
    lutB(1,11:93) = 255;
    check=1;
elseif redV<60 && greenV>110 && greenV<220 && blueV>55 && blueV<130 %for green color
     color = 'Green';
    lutR(1,1:55) = 255;
    lutG(1,120:215) = 255;
    lutB(1,61:128) = 255;
    check=1;
elseif redV<125 && greenV<175 && blueV>210 && blueV<256 %for blue color
     color = 'Blue';
    lutR(1,1:120) = 255;
    lutG(1,1:170) = 255;
    lutB(1,200:256) = 255;
    check=1;
elseif redV>190 && redV<256 && greenV>190 && greenV<256 && blueV<70 %for yellow color
    color = 'Yellow';
    lutR(1,195:256) = 255;
    lutG(1,195:256) = 255;
    lutB(1,1:65) = 255;
    check=1;
elseif redV>125 && redV<256 && greenV>30 && greenV<110 && blueV<60 %for orange color
    color = 'Orange';
    lutR(1,131:256) = 255;
    lutG(1,40:105) = 255;
    lutB(1,1:55) = 255;
    check=1;
elseif redV<70 && greenV<70 && blueV<60 %for black color
    color = 'Black';
    lutR(1,1:67) = 255;
    lutG(1,1:65) = 255;
    lutB(1,1:55) = 255;
    check=1;
end
if check==0
    disp('Please Click On the Chips Or Pen')
end
if check==1
%changing datatype
lutR = uint8(lutR);
lutG = uint8(lutG);
lutB = uint8(lutB);

% Application of Lookup Tables on each plane
qR = intlut(R,lutR);
qG = intlut(G,lutG);
qB = intlut(B,lutB);
mask = qR.*qG.*qB; 
q2=q1.*mask; %only selected color retain otherwise black

q2=rgb2gray(q2); %converting color image to grayscale image

q3=imbinarize(q2);  %binarize the image
q4=bwareaopen(q3,30); %Remove small objects from binary image,open on basis of area
str_e=strel('disk',3); %defining morphological structuring element
im_dil=imdilate(q4,str_e); %dilatig the image with structuring element above

subplot(121), imshow(im_dil); %plotting dilated image
bboxes=regionprops(q4,'BoundingBox'); %Measure properties of image regions
chipcount=length(bboxes); %getting the count of the regions/objects 
subplot(122), imshow(q1); title([color,' Chips = ', num2str(chipcount)]) %plotting

%specifying width and applying bounding boxes
for i=1:chipcount
    Cr=bboxes(i).BoundingBox;
    rectangle('Position',[Cr(1),Cr(2),Cr(3),Cr(4)],'EdgeColor','black','LineWidth',2)
end
end
end