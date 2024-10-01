clear all; close all; clc;
im = imread('osito.jpg');
im = imresize(im,[1080 1080]);
[fila,colm,color] = size(im);
table(fila, colm, color)

% Imagen fondo
fondo = imread("img.jpg");
fondo = imresize(fondo, [1080, 1080]);

nC = 2;
Lab_A = rgb2lab(im);
L = im2single(Lab_A(:,:,1)); % Luminancia
ab = im2single(Lab_A(:,:,2:3)); % A*B
pixel_labels = imsegkmeans(ab,nC,NumAttempts=3);
mask = pixel_labels == 1;
a = im.*uint8(mask);
mask = pixel_labels == 2;
b = im.*uint8(mask);
% Representamos la segmentación
figure
imshow(a)
figure
imshow(b)

fondo = fondo.*uint8(1-mask);
figure
imshow(fondo)

%Separamos por lados
im_right = zeros(fila,colm,color, "uint8");
im_left = zeros(fila,colm,color, "uint8");
im_right(:,:,1) = b(:,:,1);% Rojo
im_left(:,:,2) = b(:,:,2); % Verde 
im_left(:,:,3) = b(:,:,3);% Azul

% Movemos la imagen izquierda
separacion = 15;
im_left(:,1:end-separacion+1,:) = im_left(:,separacion:end,:);
im_left(:,end-separacion:end,:) = 0;

% Movemos la imagen derecha
im_right(:,separacion:end,:) = im_right(:,1:end-separacion+1,:);
im_right(:,1:separacion,:) = 0;

% Juntamos imagen
im_3 = fondo+im_right+im_left;

% Representamos
figure
imshow(im);
figure
imshow(im_right)
figure
imshow(im_left)
figure
imshow(im_3)