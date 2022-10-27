
clc;
clear all;
close all;
warning off all;

%% Read input image

[f,p] = uigetfile('*.jpg;*.bmp');
I = imread([p f]);
I = imresize(I,[256 256]);

%% Image segmentation

%% rgb to lab color space conversion

im = I;
R = im(:,:,1);
G = im(:,:,2);
B = im(:,:,3);

[L, a, b] = RGB2Lab(R, G, B);


labb = cat(3,L,a,b);
cform = makecform('srgb2lab');
lab = applycform(I,cform); 

ll = lab(:,:,1);
aa = lab(:,:,2);
bb = lab(:,:,3);

%% K-Means segmentation

 cl = 8;
 [ABC,c] = k_means(ll,cl);
 [d,e]=size(c);
 for i=1:d
     for j=1:e
         if c(i,j)==3
             new(i,j)=0;
         else
             new(i,j)=c(i,j);
         end
     end
 end
 
 [m1,s5] = size(new);
 for i = 1:m1
     for j = 1:s5
         if new(i,j) == 0
             new1(i,j,1:3) = I(i,j,1:3);
         else
             new1(i,j,1:3) = 0;
         end
     end
 end

 
 %% feature extraction

 %% Color Coherence Vector (CCV)
 
 c = ccv(im);
 
 %% LBP
 
 a = ll;
 [m,n] = size(a);
 for i = 2:m-1
     for j = 2:n-1
         b = a(i-1:i+1,j-1:j+1);
         B(i-1:i+1,j-1:j+1) = LBP(b);
     end
 end
 
 lbp = mean(mean(B))
 data = lbp;
 s5 = data;
 save s5 s5
 
 figure('name','Input Image result');
subplot(3,5,1);imshow(I,[]);title('Input Image');
subplot(3,5,2);imshow(R,[]);title('Red band Image');
subplot(3,5,3);imshow(G,[]);title('Green band Image');
subplot(354);imshow(B,[]);title('Blue Image');
subplot(3,5,5);imshow(L,[]);title('L color space result');
subplot(3,5,6);imshow(a,[]);title('a color space result');
subplot(3,5,7);imshow(b,[]);title('b color space result');
subplot(3,5,8);imshow(I,[]);title('Input RGB image');
subplot(3,5,9);imshow(lab);title('L*a*b color space result');
subplot(3,5,10);imshow(new,[]);title('K-means Result');
subplot(3,5,11);imshow(uint8(new1),[]);title('K-means result on input image');
 subplot(3,5,12);imhist(R);title('Red band histogram');
 subplot(3,5,13);imhist(G);title('Green band histogram');
 subplot(3,5,14);imhist(B);title('Blue band histogram');
 subplot(3,5,15);imshow(B);title('Binary');
 
 
 %% classification
 
 load net1
 y = round(sim(net1,data))
 if y == 0
     msgbox('Apple Normal','Result');
 elseif y == 1
     msgbox('Apple Blotch','Result');
 elseif y == 2
     msgbox('Apple Rot','Result');
 elseif y == 3
     msgbox('Apple Rust','Result');
 elseif y == 4
     msgbox('Apple Scab','Result');
 elseif y == 5
     msgbox('Error', 'Result');
 end
 
