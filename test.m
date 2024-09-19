clear all; close all; clc;
im = imread('peppers.png');
[fila,colm,color] = size(im);
table(fila, colm, color)
%Separamos por lados
im_right = zeros(fila,colm,color, "uint8");
im_left = zeros(fila,colm,color, "uint8");
im_right(:,:,1) = im(:,:,1);% Rojo
im_left(:,:,2) = im(:,:,2); % Verde 
im_left(:,:,3) = im(:,:,3);% Azul

% Movemos la imagen izquierda
separacion = 50;
im_left(1:end-separacion,1:end-separacion,:) = im_left(separacion:end-(separacion-1),separacion:end-(separacion-1),:);
im_left(end-separacion+1:end,end-separacion+1:end,:) = 0;

% Juntamos imagen
im_3 = im_right+im_left;

% Representamos
imshow(im);
figure
imshow(im_right)
figure
imshow(im_left)
figure
imshow(im_3)
disp("Modificacion de Hector")
disp("Modificacion 2")