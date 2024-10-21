clear all; clc; close all;
% Cargar la imagen y convertirla a escala de grises
img = imread('Prof_0.jpg');
gray_img = rgb2gray(img);

% Aplicar la segmentación utilizando k-means
num_clusters = 5;
L = imsegkmeans(gray_img, num_clusters);

% Redimensionar la imagen para que coincida con el tamaño de HOS
[rows, cols] = size(gray_img);

% Generar el mapa HOS (Estadísticas de Orden Superior) usando wavelet
[cA, cH, cV, cD] = dwt2(double(gray_img), 'haar'); % Transformada wavelet

% El tamaño de HOS será la mitad de la imagen original debido a la wavelet
HOS_map = sqrt(cH.^2 + cV.^2 + cD.^2); % Magnitud de alta frecuencia

% Ajustar el tamaño del mapa HOS al tamaño de la imagen original
HOS_map_resized = imresize(HOS_map, [rows, cols]);

% Inicializar el mapa de profundidad
depth_map = zeros(size(L));

% Asignar profundidad a cada región basada en el promedio del HOS en cada región segmentada
for i = 1:num_clusters
    region_mask = (L == i); % Máscara de la región i
    if any(region_mask(:)) % Verificar si la región tiene píxeles
        % Calcular la media del HOS en la región actual
        depth_value = mean(HOS_map_resized(region_mask)); % Usar el mapa HOS redimensionado
        % Asignar el valor de profundidad a la región
        depth_map(region_mask) = depth_value;
    end
end

% Normalizar el mapa de profundidad para visualizar mejor
depth_map = mat2gray(depth_map);

% Mostrar el mapa de profundidad
figure;
imagesc(depth_map);
title('Mapa de profundidad estimado');
colorbar;

% Parámetros del paralaje
max_parallax = 16; % Máximo valor de paralaje
depth_min = min(depth_map(:));
depth_max = max(depth_map(:));

% Normalizar el mapa de profundidad entre 0 y 1
normalized_depth = (depth_map - depth_min) / (depth_max - depth_min);

% Calcular el paralaje (desplazamiento) para las imágenes izquierda y derecha
[height, width] = size(depth_map);
left_img = zeros(size(img));
right_img = zeros(size(img));

for i = 1:height
    for j = 1:width
        shift = round(max_parallax * normalized_depth(i,j));
        if j - shift > 0
            left_img(i,j,:) = img(i,j-shift,:);
        end
        if j + shift <= width
            right_img(i,j,:) = img(i,j+shift,:);
        end
    end
end

% Mostrar las imágenes de vista izquierda y derecha
figure;
subplot(1,2,1);
imshow(uint8(left_img));
title('Vista izquierda');

subplot(1,2,2);
imshow(uint8(right_img));
title('Vista derecha');

% Unimos partes
Imagen_U = (left_img + right_img)/(255+255);
Imagen_U = imresize(Imagen_U, [1080, 1080]);
figure
imshow(Imagen_U);
title("Imagen unida")