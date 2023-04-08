        %% Parámetros del algoritmo genético
        tamano_poblacion = 100; % tamaño de la población
        probabilidad_cruce = 0.8; % probabilidad de cruce entre padres
        probabilidad_mutacion = 0.01; % probabilidad de mutación de cada gen
        numero_generaciones = 100; % número de generaciones a evolucionar
        matriz_completa = [0 12 36 28 52 44 110 126 94 63 130 102 65 98 132 132 126 120 126;
76687 0 24 75 82 75 108 70 124 86 93 106 58 124 161 161 70 64 70;
0 40951 0 47 71 47 110 73 126 71 95 110 46 127 163 163 73 67 73;
415 4118 3848 0 42 34 148 111 160 52 94 148 49 117 104 109 11 105 111;
545 5767 2524 256 0 42 125 136 102 22 73 125 32 94 130 130 136 130 136;
819 2055 3213 0 0 0 148 11 162 52 96 30 49 117 152 152 111 105 111;
135 1917 2072 0 0 0 0 46 46 136 47 46 108 51 79 79 46 47 41;
1368 2746 4225 0 0 0 0 0 69 141 63 45 119 68 121 121 27 24 36;
819 1097 566 0 47 0 196 0 0 102 34 118 84 23 80 80 69 64 51;
5630 5712 0 829 1655 926 1538 0 1954 0 64 47 29 95 130 130 141 135 141;
0 0 0 128 278 161 196 301 418 0 0 0 56 54 94 94 63 46 24;
3432 0 404 0 0 0 0 0 0 282 1686 0 100 51 89 89 46 40 36;
9082 0 9372 0 42 0 0 0 0 0 0 0 0 77 113 113 119 113 119;
1503 268 0 0 0 0 0 0 0 0 0 0 0 0 79 79 68 62 51;
0 0 972 0 0 0 0 0 0 0 0 0 0 0 0 10 113 107 119;
0 1373 0 0 0 0 0 0 0 0 0 0 0 0 99999 99999 113 107 119;
13732 268 13538 0 226 0 0 0 0 0 226 0 0 0 0 0 0 6 24;
1368 0 1368 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 12;
1783 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0];
        [distancias, flujos] = matriz_distancias_flujos(matriz_completa);

        
        %% Población inicial
        poblacion = zeros(tamano_poblacion, 19);
        for i = 1:tamano_poblacion
            poblacion(i,:) = randperm(19);
        end

        % Evolución de la población
        for g = 1:numero_generaciones
            % Evaluación de la aptitud de cada individuo
            aptitud = zeros(tamano_poblacion, 1);
            for i = 1:tamano_poblacion
                aptitud(i) = calcular_aptitud(poblacion(i,:), distancias, flujos);
            end

            % Selección de los padres
            padres = seleccion_torneo(poblacion, aptitud);

            % Cruce de los padres para generar hijos
            hijos = cruce_orden(padres, probabilidad_cruce);

            % Mutación de los hijos
            hijos_mutados = mutacion_simple(hijos, probabilidad_mutacion);

            % Reemplazo de la población por los hijos mutados
            poblacion = hijos_mutados;
        end

        % Selección del mejor individuo
        aptitud = zeros(tamano_poblacion, 1);
        for i = 1:tamano_poblacion
            aptitud(i) = calcular_aptitud(poblacion(i,:), distancias, flujos);
        end
        [mejor_aptitud, mejor_individuo] = max(aptitud);

        % Resultados
        fprintf('Mejor ruta encontrada: ');
        fprintf('%d ', poblacion(mejor_individuo,:));
        fprintf('\nDistancia total recorrida: %f km\n', mejor_aptitud);

        %% Función de selección por torneo
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
        
        function distancia_total = calcular_aptitud(individuo, distancias, flujos)
            n = length(individuo);
            distancia_total = 0;
            for i = 1:n
                for j = 1:n
                    distancia_total = distancia_total + distancias(i,j) * flujos(individuo(i), individuo(j));
                end
            end
        end
        
        function hijos_mutados = mutacion_simple(hijos, pm)
    n_hijos = size(hijos,1);
    longitud = size(hijos,2);
    hijos_mutados = hijos;
    for i = 1:n_hijos
        if rand() < pm
            % Seleccionar dos posiciones al azar
            posiciones = sort(randperm(longitud,2));
            % Intercambiar los valores en esas posiciones
            hijos_mutados(i,posiciones(1):posiciones(2)) = fliplr(hijos_mutados(i,posiciones(1):posiciones(2)));
        end
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


function [distancias, flujos] = matriz_distancias_flujos(matriz_completa)
    n = size(matriz_completa, 1);
    distancias = triu(matriz_completa, 1);
    flujos = tril(matriz_completa, -1);
end


