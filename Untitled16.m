% Parámetros del algoritmo genético
tamano_poblacion = 100; % tamaño de la población
probabilidad_cruce = 0.8; % probabilidad de cruce entre padres
probabilidad_mutacion = 0.01; % probabilidad de mutación de cada gen
numero_generaciones = 100; % número de generaciones a evolucionar

% Distancias entre los lugares (en km)
%distancias = [    0 2 3 4 3 2;    2 0 1 3 2 1;    3 1 0 2 1 2;    4 3 2 0 1 2;    3 2 1 1 0 1;    2 1 2 2 1 0;];
Distancias =[0,15,NULL,NULL,8,12; 15,0,13,9,7,13; NULL,13,0,9,NULL,16; NULL,9,9,0,8,7; 8,7,NULL,8,0,7; 12,13,16,7,7,0];

% Población inicial
poblacion = zeros(tamano_poblacion, 6);
for i = 1:tamano_poblacion
    poblacion(i,:) = randperm(6);
end

% Evolución de la población
for g = 1:numero_generaciones
    % Evaluación de la aptitud de cada individuo
    aptitud = zeros(tamano_poblacion, 1);
    for i = 1:tamano_poblacion
        aptitud(i) = 1 / calcular_distancia(poblacion(i,:), distancias);
    end
    
    % Selección de los padres
    padres = seleccion_torneo(poblacion, aptitud);
    
    % Cruce de los padres para generar hijos
    hijos = cruce_orden(padres, probabilidad_cruce);
    
    % Mutación de los hijos
    hijos_mutados = mutacion_swap(hijos, probabilidad_mutacion);
    
    % Reemplazo de la población por los hijos mutados
    poblacion = hijos_mutados;
end

% Selección del mejor individuo
aptitud = zeros(tamano_poblacion, 1);
for i = 1:tamano_poblacion
    aptitud(i) = 1 / calcular_distancia(poblacion(i,:), distancias);
end
[mejor_aptitud, mejor_individuo] = max(aptitud);

% Resultados
fprintf('Mejor ruta encontrada: ');
fprintf('%d ', poblacion(mejor_individuo,:));
fprintf('\nDistancia total recorrida: %f km\n', 1 / mejor_aptitud);

% Función que calcula la distancia total de una ruta
function distancia_total = calcular_distancia(ruta, distancias)
    distancia_total = 0;
    for i = 1:length(ruta)-1
        distancia_total = distancia_total + distancias(ruta(i), ruta(i+1));
    end
end

% Función de selección por torneo
function padres_seleccionados = seleccion_torneo(poblacion, aptitud)
    tamano_torneo = 5;
    num_padres = size(poblacion, 1);
    padres_seleccionados = zeros(num_padres, size(poblacion, 2));
    for i = 1:num_padres
        indices_torneo = randperm(num_padres, tamano_torneo);
        aptitud_torneo = aptitud(indices_torneo);
        [mejor_aptitud, mejor_individuo] = max(aptitud(indices_torneo));
        padres_seleccionados(i,:) = poblacion(indices_torneo(mejor_individuo),:);
    end
end

% Función de cruce por orden
function hijos_generados = cruce_orden(padres, probabilidad_cruce)
    tamano_poblacion = size(padres, 1);
    num_genes = size(padres, 2);
    hijos_generados = zeros(tamano_poblacion, num_genes);
    for i = 1:2:tamano_poblacion
        if rand < probabilidad_cruce
            % Seleccionar dos puntos de cruce aleatorios
            puntos_cruce = sort(randperm(num_genes, 2));
            % Copiar los genes de los padres en los hijos
            hijo1 = zeros(1, num_genes);
            hijo2 = zeros(1, num_genes);
            hijo1(puntos_cruce(1):puntos_cruce(2)) = padres(i, puntos_cruce(1):puntos_cruce(2));
            hijo2(puntos_cruce(1):puntos_cruce(2)) = padres(i+1, puntos_cruce(1):puntos_cruce(2));
            % Completar los genes restantes en orden
            j1 = puntos_cruce(2) + 1;
            j2 = puntos_cruce(2) + 1;
            while any(hijo1 == 0)
                if ~ismember(padres(i+1,rem(j2-1,num_genes)+1), hijo1)
                    hijo1(rem(j1-1,num_genes)+1) = padres(i+1,rem(j2-1,num_genes)+1);
                    j1 = rem(j1, num_genes) + 1;
                end
                j2 = rem(j2, num_genes) + 1;
            end
            j1 = puntos_cruce(2) + 1;
            j2 = puntos_cruce(2) + 1;
            while any(hijo2 == 0)
                if ~ismember(padres(i,rem(j1-1,num_genes)+1), hijo2)
                    hijo2(rem(j2-1,num_genes)+1) = padres(i,rem(j1-1,num_genes)+1);
                    j2 = rem(j2, num_genes) + 1;
                end
                j1 = rem(j1, num_genes) + 1;
            end
            % Agregar los hijos a la población
            hijos_generados(i,:) = hijo1;
            hijos_generados(i+1,:) = hijo2;
        else
            % Copiar los padres sin cambios
            hijos_generados(i,:) = padres(i,:);
            hijos_generados(i+1,:) = padres(i+1,:);
        end
    end
end


% Función de mutación por swap
function poblacion_mutada = mutacion_swap(poblacion, probabilidad_mutacion)
tamano_poblacion = size(poblacion, 1);
num_genes = size(poblacion, 2);
poblacion_mutada = zeros(tamano_poblacion, num_genes);
for i = 1:tamano_poblacion
if rand < probabilidad_mutacion
% Seleccionar dos posiciones aleatorias para hacer el swap
posiciones_swap = sort(randperm(num_genes, 2));
% Hacer el swap
poblacion_mutada(i,:) = poblacion(i,:);
temp = poblacion_mutada(i,posiciones_swap(1));
poblacion_mutada(i,posiciones_swap(1)) = poblacion_mutada(i,posiciones_swap(2));
poblacion_mutada(i,posiciones_swap(2)) = temp;
else
    % Copiar el individuo sin cambios
poblacion_mutada(i,:) = poblacion(i,:);
end
end
end
