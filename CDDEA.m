
%   CDDEA : Community Detection Based On
%   Differential Evolution Using Modularity Desity

%   Hossein Mohseni


function CDDEA

  % Step 1: Initialize algorithm parameters
  options = initialize_params;

  % Step 2: Initialize population according to section 3.1.1
  population = initialize_population(options);
  modularity_density_history = [];

  % Step 3 to 8
  for gen = 1:options.max_gen

    % Step 3: Perform the mutation scheme
    mutants = mutation(population, options);

    % Step 4: Execute the crossover
    children = crossover(population, mutants, options);

    % Step 5 & 6
    population = selection(population, children);

    % Step 7
    % Track the modularity density of the best individual in each generation
    modularity_densities = zeros(1, options.pop_size);

    for i = 1:options.pop_size
        modularity_densities(i) = calculate_modularity_density(population(i, :));
    endfor

    % Step 8
    [~, idx_best] = max(modularity_densities);
    best_individual = population(idx_best, :);
    modularity_density_history(gen) = calculate_modularity_density(best_individual);

  endfor

  disp("_______BEST INDIVIDUAL_______");
  disp(best_individual);
  disp("_____________________________");


  % Plotting the modularity density trend
  plot(modularity_density_history, 'o-');

  % Title and labels
  title('CDDEA Modularity Density Evolution');
  xlabel('Generation');
  ylabel('Modularity Density');

  % Display the plot
  grid on;  % Add grid for better readability (optional)
  legend('Modularity Density');

  drawplot(best_individual);



endfunction

function options = initialize_params

  % Initialize algorithm parameters
  options.n_vertices = 12;       % n Vertices
  options.max_gen = 100;         % Max generations
  options.pop_size = 50;         % population size
  options.pc = 0.9;              % Crossover prob
  options.F = 0.5;               % Scale factor
  options.omega = 0.7;           % greedy factor

endfunction

function population = initialize_population(options)

  % initialize population
   population = randi([1, options.n_vertices], options.pop_size, options.n_vertices);

endfunction

function mutants = mutation(population, options)

    % Step 3: Select the best individual
    modularity_densities = zeros(1, options.pop_size);

    for i = 1:size(population, 1)
        modularity_densities(i) = calculate_modularity_density(population(i, :));
    endfor

    [~, idx_best] = max(modularity_densities);
    best_individual = population(idx_best, :);

    mutants = zeros(options.pop_size, options.n_vertices);

    for i = 1:options.pop_size
        % Step 3.1: Randomly select three individuals
        rand_indices = randperm(options.pop_size, 3);
        rand_individuals = population(rand_indices, :);

        % Step 3.2: Compute difference vectors
        diff_vector_greedy = options.omega * (best_individual - population(i, :));
        diff_vector_scaled = options.F * (rand_individuals(1, :) - rand_individuals(2, :));

        % Step 3.3: Perform mutation
        mutants(i, :) = round(population(i, :) + diff_vector_greedy + diff_vector_scaled);

        % Ensure mutants are within the valid range of community indices
        mutants(i, :) = mod(mutants(i, :) - 1, options.n_vertices) + 1;
    endfor

endfunction

function modularity_density = calculate_modularity_density(individual)
    % Calculate modularity density for the given individual
    n = size(individual, 2);  % Number of vertices
    adjacency_matrix = zeros(n);

    % Assuming undirected graph, populate the adjacency matrix
    for i = 1:n
        for j = i+1:n
            if individual(i) == individual(j)
                adjacency_matrix(i, j) = 1;
                adjacency_matrix(j, i) = 1;
            endif
        endfor
    endfor

    m = sum(adjacency_matrix(:)) / 2;  % Calculate the number of edges

    % Calculate the difference of internal and external degrees
    internal_degree = sum(sum(adjacency_matrix' * adjacency_matrix));
    external_degree = sum(sum(adjacency_matrix)) - internal_degree;

    % Calculate modularity density using the formula from the paper
    modularity_density = (2 * internal_degree - 2 * external_degree) / m;

    % If needed, you can also use the more general modularity density measure
    % D_lambda = (2*lambda*internal_degree - 2*(1-lambda)*external_degree) / m;
endfunction

function children = crossover(parents, mutants, options)
  children = [];

  for i = 1:2:length(parents)
    parent1 = parents(i, :);
    parent2 = parents(i + 1, :);
    crossover_points = rand(size(parent1)) <= options.pc;
    child1 = parent1 .* crossover_points + mutants(i, :) .* (~crossover_points);
    child2 = parent2 .* crossover_points + mutants(i + 1, :) .* (~crossover_points);
    children(i, :) = child1;
    children(i + 1, :) = child2;
  endfor

endfunction

function new_population = selection(population, children)

  all_individuals = [population; children];  % Concatenate vertically

  % Calculate modularity densities for all individuals
  all_modularity_densities = arrayfun(@(ind) calculate_modularity_density(all_individuals(ind, :)), 1:size(all_individuals, 1));

  % Sort individuals based on modularity density in descending order
  [~, sorted_indexes] = sort(all_modularity_densities, 'descend');
  sorted_individuals = all_individuals(sorted_indexes, :);

  % Select the top individuals to form the new population
  new_population = sorted_individuals(1:size(population, 1), :);

endfunction

function drawplot(best_individual)
  n = size(best_individual, 2);
  adjacency_matrix = zeros(n);

  % Assuming undirected graph, populate the adjacency matrix
  for i = 1:n
      for j = i+1:n
          if best_individual(i) == best_individual(j)
              adjacency_matrix(i, j) = 1;
              adjacency_matrix(j, i) = 1;
          endif
      endfor
  endfor

  % Create coordinates for nodes (circle layout)
  theta = linspace(0, 2*pi, n+1);
  x = cos(theta(1:end-1));
  y = sin(theta(1:end-1));

  % Plot the graph
  figure;
  hold on;

  % Plot edges
  for i = 1:n
      for j = i+1:n
          if adjacency_matrix(i, j) == 1
              plot([x(i), x(j)], [y(i), y(j)], '-k', 'LineWidth', 1.5);
          endif
      endfor
  endfor

  % Plot nodes
  scatter(x, y, 100, best_individual, 'filled');

  % Customize node colors based on communities
  colormap(jet(max(best_individual)));
  caxis([1 max(best_individual)]);

  % Title and colorbar
  title('Community Detection Using CDDEA');
  colorbar;

  hold off;

endfunction



