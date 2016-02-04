

classdef SMB < handle
% =============================================================================
% This is the class of the functions of simulated moving bed.
%
% =============================================================================


    methods (Static = true, Access = 'public')
        
        function [opt, interstVelocity, Feed] = getParameters()
% -----------------------------------------------------------------------------
% This is the function to input all the necessary data for simulation
%
% Returns: 
%       1. opt stands for options, which involves the parameter settings
%       for the algorithm, the binding isotherm, and the model equations
%
%       2. interstVelocity is calculated from flowrate of each column and inlet. 
%       interstitial_velocity = flow_rate / (across_area * porosity_Column)
%
%       3. Feed initializes the injection concentration
% -----------------------------------------------------------------------------


%           The parameter setting for simulator
            opt.tolIter         = 1e-4;
            opt.nMaxIter        = 1000;
            opt.nThreads        = 8;
            opt.nCellsColumn    = 40;
            opt.nCellsParticle  = 1;
            opt.switch          = 180;
            opt.timePoints      = 1000;
            opt.ABSTOL          = 1e-10;
            opt.INIT_STEP_SIZE  = 1e-14;
            opt.MAX_STEPS       = 5e6;

            opt.Purity_extract_limit    = 0.99;
            opt.Purity_raffinate_limit  = 0.99;
            opt.Penalty_factor          = 10;

            opt.enableDebug = true;
            opt.nColumn = 4;  % 4,8,12,16- column cases are available
%             opt.nColumn = 8;
%             opt.nColumn = 12;
%             opt.nColumn = 16;

%           Binding: Linear Binding isotherm
            opt.nComponents = 2;
            opt.KA = [5.72 7.7];
            opt.KD = [1, 1];

%           Transport
            opt.dispersionColumn          = 3.8148e-20;     %
            opt.filmDiffusion             = [100 100];      % unknown 
            opt.diffusionParticle         = [1.6e4 1.6e4];  % unknown
            opt.diffusionParticleSurface  = [0.0 0.0];

%           Geometry
            opt.columnLength        = 0.25;      % m
            opt.columnDiameter      = 0.02;      % m
            opt.particleRadius      = 0.0005;    % m % user-defined one in this case
            opt.porosityColumn      = 0.83;
            opt.porosityParticle    = 0.000001;  % unknown

%           Parameter units transformation
%           The flow rate of Zone I was defined as the recycle flow rate
            crossArea = pi * (opt.columnDiameter/2)^2;
            flowRate.recycle    = 9.62e-7;      % m^3/s  
            flowRate.feed       = 0.98e-7;      % m^3/s
            flowRate.raffinate  = 1.40e-7;      % m^3/s
            flowRate.desorbent  = 1.96e-7;      % m^3/s
            flowRate.extract    = 1.54e-7;      % m^3/s
            opt.flowRate_recycle = flowRate.recycle;
            
%           Interstitial velocity = flow_rate / (across_area * opt.porosityColumn)
            interstVelocity.recycle   = flowRate.recycle / (crossArea*opt.porosityColumn);      % m/s 
            interstVelocity.feed      = flowRate.feed / (crossArea*opt.porosityColumn);         % m/s
            interstVelocity.raffinate = flowRate.raffinate / (crossArea*opt.porosityColumn);    % m/s
            interstVelocity.desorbent = flowRate.desorbent / (crossArea*opt.porosityColumn);    % m/s
            interstVelocity.extract   = flowRate.extract / (crossArea*opt.porosityColumn);      % m/s

            concentrationFeed 	= [0.55, 0.55];   % g/m^3 [concentration_compA, concentration_compB]
            opt.FructoseMolMass = 180.16; 	  % g/mol
            opt.GlucoseMolMass  = 180.16; 	  % g/mol
            opt.yLim = max(concentrationFeed ./ [opt.FructoseMolMass opt.GlucoseMolMass]);

%           Feed concentration setup   
            Feed.time = linspace(0, opt.switch, opt.timePoints);
            Feed.concentration = zeros(length(Feed.time), opt.nComponents);

            Feed.concentration(1:end,1) = (concentrationFeed(1) / opt.FructoseMolMass);
            Feed.concentration(1:end,2) = (concentrationFeed(2) / opt.GlucoseMolMass);

        end
        
        function [opt, interstVelocity, Feed] = getParameters2()
% -----------------------------------------------------------------------------
% This is the function to input all the necessary data for simulation
%
% Returns: 
%       1. opt stands for options, which involves the parameter settings
%       for the algorithm, the binding isotherm, and the model equations
%
%       2. interstVelocity is calculated from flowrate of each column and inlet. 
%       interstitial_velocity = flow_rate / (across_area * porosity_Column)
%
%       3. Feed initializes the injection concentration
% -----------------------------------------------------------------------------


%           the parameter setting for simulator
            opt.tolIter         = 1e-4;
            opt.nMaxIter        = 1000;
            opt.nThreads        = 8;
            opt.nCellsColumn    = 40;
            opt.nCellsParticle  = 1;
            opt.switch          = 1552;
            opt.timePoints      = 1000;
            opt.ABSTOL          = 1e-10;
            opt.INIT_STEP_SIZE  = 1e-14;
            opt.MAX_STEPS       = 5e6;

            opt.Purity_extract_limit    = 0.99;
            opt.Purity_raffinate_limit  = 0.99;
            opt.Penalty_factor          = 10;

            opt.enableDebug = true;
            opt.nColumn = 8;  % 4,8,12,16- column cases are available
%             opt.nColumn = 12;
%             opt.nColumn = 16;

%           Binding: Linear Binding isotherm
            opt.nComponents = 2;
            opt.KA = [0.28 0.54];
            opt.KD = [1, 1];

%           Transport
            opt.dispersionColumn          = 3.8148e-6;      % 
            opt.filmDiffusion             = [100 100];      % unknown 
            opt.diffusionParticle         = [1.6e4 1.6e4];  % unknown
            opt.diffusionParticleSurface  = [0.0 0.0];

%           Geometry
            opt.columnLength        = 53.6e-2;        % m
            opt.columnDiameter      = 2.60e-2;        % cm
            opt.particleRadius      = 0.325e-2 /2;    % m
            opt.porosityColumn      = 0.38;
            opt.porosityParticle    = 0.00001;        % unknown

%           Parameter units transformation
%           The flow rate of Zone I was defined as the recycle flow rate
            crossArea = pi * (opt.columnDiameter/2)^2;        % m^2
            flowRate.recycle    = 0.1395e-6;      % m^3/s 
            flowRate.feed       = 0.02e-6  ;      % m^3/s
            flowRate.raffinate  = 0.0266e-6;      % m^3/s
            flowRate.desorbent  = 0.0414e-6;      % m^3/s
            flowRate.extract    = 0.0348e-6;      % m^3/s
            opt.flowRate_recycle = flowRate.recycle;
            
%           Interstitial velocity = flow_rate / (across_area * opt.porosityColumn)
            interstVelocity.recycle   = flowRate.recycle / (crossArea*opt.porosityColumn);      % m/s 
            interstVelocity.feed      = flowRate.feed / (crossArea*opt.porosityColumn);         % m/s
            interstVelocity.raffinate = flowRate.raffinate / (crossArea*opt.porosityColumn);    % m/s
            interstVelocity.desorbent = flowRate.desorbent / (crossArea*opt.porosityColumn);    % m/s
            interstVelocity.extract   = flowRate.extract / (crossArea*opt.porosityColumn);      % m/s

            concentrationFeed 	= [0.5, 0.5];   % g/m^3 [concentration_compA, concentration_compB]
            opt.FructoseMolMass = 180.16; % g/mol
            opt.GlucoseMolMass  = 180.16; % g/mol
            opt.yLim = max(concentrationFeed ./ [opt.FructoseMolMass opt.GlucoseMolMass]);

%           Feed concentration setup    
            Feed.time = linspace(0, opt.switch, opt.timePoints);
            Feed.concentration = zeros(length(Feed.time), opt.nComponents);

            Feed.concentration(1:end,1) = (concentrationFeed(1) / opt.FructoseMolMass);
            Feed.concentration(1:end,2) = (concentrationFeed(2) / opt.GlucoseMolMass);

        end
        
        function [opt, interstVelocity, Feed] = getParameters3()
% -----------------------------------------------------------------------------
% This is the function to input all the necessary data for simulation
%
% Returns: 
%       1. opt stands for options, which involves the parameter settings
%       for the algorithm, the binding isotherm, and the model equations
%
%       2. interstVelocity is calculated from flowrate of each column and inlet. 
%       interstitial_velocity = flow_rate / (across_area * porosity_Column)
%
%       3. Feed initializes the injection concentration
% -----------------------------------------------------------------------------


%           The parameter setting for simulator
            opt.tolIter         = 1e-4;
            opt.nMaxIter        = 1000;
            opt.nThreads        = 8;
            opt.nCellsColumn    = 40;
            opt.nCellsParticle  = 1;
            opt.switch          = 607;
            opt.timePoints      = 1000;
            opt.ABSTOL          = 1e-10;
            opt.INIT_STEP_SIZE  = 1e-14;
            opt.MAX_STEPS       = 5e6;

            opt.Purity_extract_limit    = 0.99;
            opt.Purity_raffinate_limit  = 0.99;
            opt.Penalty_factor          = 10;

            opt.enableDebug = true;
            opt.nColumn = 4;  % 4,8,12,16- column cases are available
%             opt.nColumn = 8;
%             opt.nColumn = 12;
%             opt.nColumn = 16;

%           Binding: Linear Binding isotherm
            opt.nComponents = 3;
            opt.KA = [0.18, 0.29, 0.336];
            opt.KD = [1, 1, 1];

%           Transport
            opt.dispersionColumn          = 3.8148e-20;     %
            opt.filmDiffusion             = [100 100 100];      % unknown 
            opt.diffusionParticle         = [1.6e4 1.6e4 1.6e4];  % unknown
            opt.diffusionParticleSurface  = [0.0 0.0 0.0];

%           Geometry
            opt.columnLength        = 45e-2;      % m
            opt.columnDiameter      = 1.5e-2;      % m
            opt.particleRadius      = 320e-6;    % m % macrometer to meter
            opt.porosityColumn      = 0.389;
            opt.porosityParticle    = 0.000001;  % unknown

%           Parameter units transformation
%           The flow rate of Zone I was defined as the recycle flow rate
            crossArea = pi * (opt.columnDiameter/2)^2;
            flowRate.recycle    = 9.62e-8;      % m^3/s  
            flowRate.feed       = 0.98e-8;      % m^3/s
            flowRate.raffinate  = 1.40e-8;      % m^3/s
            flowRate.desorbent  = 1.96e-8;      % m^3/s
            flowRate.extract    = 1.54e-8;      % m^3/s
            opt.flowRate_recycle = flowRate.recycle;

%           Interstitial velocity = flow_rate / (across_area * opt.porosityColumn)
            interstVelocity.recycle   = flowRate.recycle / (crossArea*opt.porosityColumn);      % m/s 
            interstVelocity.feed      = flowRate.feed / (crossArea*opt.porosityColumn);         % m/s
            interstVelocity.raffinate = flowRate.raffinate / (crossArea*opt.porosityColumn);    % m/s
            interstVelocity.desorbent = flowRate.desorbent / (crossArea*opt.porosityColumn);    % m/s
            interstVelocity.extract   = flowRate.extract / (crossArea*opt.porosityColumn);      % m/s

            concentrationFeed 	= [180e3 180e3 180e3];   % g/m^3 [concentration_compA, concentration_compB]
            opt.MaltoseMolMass  = 342.30; 	  % g/mol
            opt.FructoseMolMass = 180.16; 	  % g/mol
            opt.GlucoseMolMass  = 180.16; 	  % g/mol
            opt.yLim = max(concentrationFeed ./ [opt.MaltoseMolMass opt.FructoseMolMass opt.GlucoseMolMass]);

%           Feed concentration setup   
            Feed.time = linspace(0, opt.switch, opt.timePoints);
            Feed.concentration = zeros(length(Feed.time), opt.nComponents);
            MolMass = [opt.MaltoseMolMass opt.FructoseMolMass opt.GlucoseMolMass];

            for i = 1:opt.nComponents
               Feed.concentration(1:end,i) = (concentrationFeed(i) / MolMass(i));
            end
            
            
        end
        
        function [outletProfile, lastState] = secColumn(inletProfile, params, lastState)
% -----------------------------------------------------------------------------
% Simulation of the single column
%
% Parameters:
%       - inletProfile. Inlet time and corresponding concentration
%       - params. Get parameters for simulation
%       - lastState. The recorded last STATE from previous simulation
%       of next simulation
% 
% Returns:
%       - outletProfile. outlet time and corresponding concentration
%       - lastState. Record the last STATE which used as the initial state
% -----------------------------------------------------------------------------


            if nargin < 3
                lastState = [];
            end

            if isempty(params.initMobilCon) && isempty(params.initSolidCon) && isempty(lastState)
                warning('There are no Initial Conditions / Boundary Conditions for the Simulator');
            end

%           Get parameters
            [opt, ~, ~] = getParameters();
%             [opt, ~, ~] = SMB.getParameters(); % the default parameters setup

            model = ModelGRM();
            model.nComponents = opt.nComponents;
            model.kineticBindingModel = false;
            model.bindingModel = LinearBinding();

%           Adsorption parameters
            model.bindingParameters.LIN_KA         = opt.KA;
            model.bindingParameters.LIN_KD         = opt.KD;

            if nargin >= 3 && ~isempty(lastState)
                model.initialState = lastState;
            else      
                model.initialMobileConcentration = params.initMobilCon;
                model.initialSolidConcentration  = params.initSolidCon;
            end

%           Transport
            model.dispersionColumn          = opt.dispersionColumn;
            model.filmDiffusion             = opt.filmDiffusion;
            model.diffusionParticle         = opt.diffusionParticle;
            model.diffusionParticleSurface  = opt.diffusionParticleSurface;
            model.interstitialVelocity      = params.interstitialVelocity;

%           Geometry
            model.columnLength        = opt.columnLength;
            model.particleRadius      = opt.particleRadius;
            model.porosityColumn      = opt.porosityColumn;
            model.porosityParticle    = opt.porosityParticle;

%           Apply the inlet profile to the CADET model
            Time = repmat({inletProfile.time}, 1, 2);
            Profile = [{inletProfile.concentration(:,1)}, {inletProfile.concentration(:,2)}];
            model.setInletsFromData(Time, Profile);

%           Turn off the warnings of the interpolation
            warning('off', 'MATLAB:interp1:ppGriddedInterpolant');
            warning('off', 'MATLAB:interp1:UsePCHIP');

%           Discretization
            disc = DiscretizationGRM();
            disc.nCellsColumn   = opt.nCellsColumn;
            disc.nCellsParticle = opt.nCellsParticle;

%           Solving options
            sim = Simulator(model, disc);
            sim.nThreads = opt.nThreads;
            sim.solutionTimes = inletProfile.time;
            sim.solverOptions.time_integrator.ABSTOL         = opt.ABSTOL;
            sim.solverOptions.time_integrator.INIT_STEP_SIZE = opt.INIT_STEP_SIZE;
            sim.solverOptions.time_integrator.MAX_STEPS      = opt.MAX_STEPS;
            sim.solverOptions.WRITE_SOLUTION_ALL    = false;
            sim.solverOptions.WRITE_SOLUTION_LAST   = true;
            sim.solverOptions.WRITE_SENS_LAST       = false;
            sim.solverOptions.WRITE_SOLUTION_COLUMN_OUTLET = true;
            sim.solverOptions.WRITE_SOLUTION_COLUMN_INLET  = true;


%           Run the simulation
            try
                result = sim.simulate();
            catch e
                error('CADET:simulationFailed', 'Check your settings and try again.\n%s',e.message);
            end

%           Extract the outlet profile
            outletProfile.time = result.solution.time;
            outletProfile.concentration = result.solution.outlet(:,:);
            lastState =  result.solution.lastState;


        end
        
        function column = massConservation(currentData, interstVelocity, Feed, opt, sequence, index)
% -----------------------------------------------------------------------------
% This is the function to calculate the concentration changes on each node.
%
%              4-column SMB                                       8-column SMB
% Extract                          Feed       |    Extract                           Feed
%       \                          /          |         \                            /
%        --------Zone II(b)--------           |          --------Zone II(c/d)--------
%        |                        |           |          |                          | 
% Zone I(a)                  Zone III(c)      |     Zone I(a/b)               Zone III(e/f)
%        |                        |           |          |                          | 
%        --------Zone IV(d)--------           |          --------Zone IV(h/g)--------
%       /                          \          |         /                            \
% Desorbent                       Raffinate   |   Desorbent                         Raffinate
%
%             12-column SMB                                       16-column SMB
% Extract                            Feed       |    Extract                         Feed
%       \                            /          |         \                          /
%        -- ----Zone II(d/e/f)-------           |          -----Zone II(e/f/g/h)-----
%        |                          |           |          |                        | 
% Zone I(c/b/a)                Zone III(g/h/i)  |  Zone I(a/b/c/d)           Zone III(i/j/k/l)
%        |                          |           |          |                        | 
%        -------Zone IV(l/k/j)-------           |          -----Zone IV(p/o/n/m)-----
%       /                            \          |         /                          \
% Desorbent                         Raffinate   |   Desorbent                       Raffinate
%
% Fluid goes from Zone I to Zone II to Zone III, while the switch direction
% is from Zone I to Zone IV to Zone III;
%
% Parameters:
%       - currentData. Which includes each column's outlet concentration
%       (time-dependent), and the last state (which records every component's concentration 
%        in bulk phase and stationary phase, and used as the initial state for the next simulation).
%       - interstVelocity. The interstitial velocity of each column
%       - Feed. The initialied injection 
%       - opt. Options
%       - sequence. During switching, the structure used for storing the
%       sequence of columns
%       - index. It is a character. It tell this subroutine to calculate the specified column 
% 
% Returns: column
%   Preparation for next column simulation
%       - column.inlet. The new inlet concentration of each column, which is
%       obtained from mass conservation on each node.
%       - column.lastState. 
%       - column.params. Set the initial Mobile and Solid concentration to the
%       Simulator (if there is no lastState given), and also store the
%       interstitial velocity.
% -----------------------------------------------------------------------------


%           Time points
            column.inlet.time = linspace(0, opt.switch, opt.timePoints);

%           Get the interstitial velocity of each columns and initial condition
            params = SMB.getParams(sequence, interstVelocity, opt);


            if opt.nColumn == 4

                switch index

%                   The calculation of the column in the Zone I
%                   node DESORBENT (index a)
                    case 'a' 

                        column.params = params{sequence.a};
                        column.initialState = currentData{sequence.a}.lastState;

                        %   C_a^in = Q_d * C_d^out / Q_a
                        concentration = zeros(length(Feed.time), 2);

                        column.inlet.concentration = concentration .* params{sequence.d}.interstitialVelocity...
                            ./ params{sequence.a}.interstitialVelocity; 


%                   The calculation of the column in the Zone II
%                   node EXTRACT (index b)
                    case 'b'

                        column.params = params{sequence.b};
                        column.initialState = currentData{sequence.b}.lastState;

                        %   C_b^in = C_a^out
                        column.inlet.concentration = currentData{sequence.a}.outlet.concentration;


%                   The calculation of the column in the Zone III
%                   node FEED (index c)
                    case 'c' 
                        column.params = params{sequence.c};
                        column.initialState = currentData{sequence.c}.lastState;

                        %   C_c^in = (Q_b * C_b^out + Q_F * C_F) / Q_c
                        column.inlet.concentration = (currentData{sequence.b}.outlet.concentration .* ...
                            params{sequence.b}.interstitialVelocity + Feed.concentration .* interstVelocity.feed) ...
                            ./ params{sequence.c}.interstitialVelocity; 


%                   The calculation of the column in the Zone IV
%                   node RAFFINATE (index d)
                    case 'd' 

                        column.params = params{sequence.d};
                        column.initialState = currentData{sequence.d}.lastState;

                        %   C_d^in = C_c^out
                        column.inlet.concentration = currentData{sequence.c}.outlet.concentration;
                end


%     ------------------------------------------------------------------------------------    
            elseif opt.nColumn == 8

                switch index

%                   The calculation of the column in the Zone I
%                   node DESORBENT (index a)
                    case 'a'  

                        column.params = params{sequence.a};
                        column.initialState = currentData{sequence.a}.lastState;

                        %   C_a^in = Q_h * C_h^out / Q_a
                        concentration = zeros(length(Feed.time), 2);

                        column.inlet.concentration = concentration .* params{sequence.h}.interstitialVelocity...
                            ./ params{sequence.a}.interstitialVelocity;


%                   node DESORBENT (index b)
                    case 'b'  

                        column.params = params{sequence.b};
                        column.initialState = currentData{sequence.b}.lastState;

                        %   C_b^in = C_a^out
                        column.inlet.concentration = currentData{sequence.a}.outlet.concentration;


%                   The calculation of the column in the Zone II  
%                   node EXTRACT (index c)
                    case 'c'  

                        column.params = params{sequence.c};
                        column.initialState = currentData{sequence.c}.lastState;

                        %   C_c^in = C_b^out
                        column.inlet.concentration = currentData{sequence.b}.outlet.concentration;


%                   node EXTRACT (index d)
                    case 'd'  

                        column.params = params{sequence.d};
                        column.initialState = currentData{sequence.d}.lastState;

                        %   C_d^in = C_c^out
                        column.inlet.concentration = currentData{sequence.c}.outlet.concentration;


%                   The calculation of the column in the Zone III
%                   node FEED (index e)
                    case 'e' 

                        column.params = params{sequence.e};
                        column.initialState = currentData{sequence.e}.lastState;

                        %   C_e^in = (Q_d * C_d^out + Q_F * C_F) / Q_e
                        column.inlet.concentration = (currentData{sequence.d}.outlet.concentration .* ...
                        params{sequence.d}.interstitialVelocity + Feed.concentration .* interstVelocity.feed) ...
                        ./ params{sequence.e}.interstitialVelocity;


%                   node FEED (index f)
                    case 'f' 

                        column.params = params{sequence.f};
                        column.initialState = currentData{sequence.f}.lastState;

                        %   C_f^in = C_e^out
                        column.inlet.concentration = currentData{sequence.e}.outlet.concentration;


%                   The calculation of the column in the Zone IV 
%                   node RAFFINATE (index g)
                    case 'g'  

                        column.params = params{sequence.g};
                        column.initialState = currentData{sequence.g}.lastState;

                        %   C_g^in = C_f^out
                        column.inlet.concentration = currentData{sequence.f}.outlet.concentration;


%                   node RAFFINATE (index h)
                    case 'h' 

                        column.params = params{sequence.h};
                        column.initialState = currentData{sequence.h}.lastState;

                        %   C_h^in = C_g^out
                        column.inlet.concentration = currentData{sequence.g}.outlet.concentration;

                end
                
%     ------------------------------------------------------------------------------------    
            elseif opt.nColumn == 12

                switch index

%                   The calculation of the column in the Zone I
%                   node DESORBENT (index a)
                    case 'a'  

                        column.params = params{sequence.a};
                        column.initialState = currentData{sequence.a}.lastState;

                        %   C_a^in = Q_l * C_l^out / Q_a
                        concentration = zeros(length(Feed.time), 2);

                        column.inlet.concentration = concentration .* params{sequence.l}.interstitialVelocity...
                            ./ params{sequence.a}.interstitialVelocity;


%                   node DESORBENT (index b)
                    case 'b'  

                        column.params = params{sequence.b};
                        column.initialState = currentData{sequence.b}.lastState;

                        %   C_b^in = C_a^out
                        column.inlet.concentration = currentData{sequence.a}.outlet.concentration;


%                   node DESORBENT (index c)
                    case 'c'  

                        column.params = params{sequence.c};
                        column.initialState = currentData{sequence.c}.lastState;

                        %   C_c^in = C_b^out
                        column.inlet.concentration = currentData{sequence.b}.outlet.concentration;
                   
                        
%                   The calculation of the column in the Zone II  
%                   node EXTRACT (index d)
                    case 'd'  

                        column.params = params{sequence.d};
                        column.initialState = currentData{sequence.d}.lastState;

                        %   C_d^in = C_c^out
                        column.inlet.concentration = currentData{sequence.c}.outlet.concentration;


%                   node EXTRACT (index e)
                    case 'e'  

                        column.params = params{sequence.e};
                        column.initialState = currentData{sequence.e}.lastState;

                        %   C_e^in = C_d^out
                        column.inlet.concentration = currentData{sequence.d}.outlet.concentration;


%                   node EXTRACT (index f)
                    case 'f'  

                        column.params = params{sequence.f};
                        column.initialState = currentData{sequence.f}.lastState;

                        %   C_f^in = C_e^out
                        column.inlet.concentration = currentData{sequence.e}.outlet.concentration;
                        
                        
%                   The calculation of the column in the Zone III
%                   node FEED (index g)
                    case 'g' 

                        column.params = params{sequence.g};
                        column.initialState = currentData{sequence.g}.lastState;

                        %   C_g^in = (Q_f * C_f^out + Q_F * C_F) / Q_g
                        column.inlet.concentration = (currentData{sequence.f}.outlet.concentration .* ...
                        params{sequence.f}.interstitialVelocity + Feed.concentration .* interstVelocity.feed) ...
                        ./ params{sequence.g}.interstitialVelocity;


%                   node FEED (index h)
                    case 'h' 

                        column.params = params{sequence.h};
                        column.initialState = currentData{sequence.h}.lastState;

                        %   C_h^in = C_g^out
                        column.inlet.concentration = currentData{sequence.g}.outlet.concentration;


%                   node FEED (index i)
                    case 'i' 

                        column.params = params{sequence.i};
                        column.initialState = currentData{sequence.i}.lastState;

                        %   C_i^in = C_h^out
                        column.inlet.concentration = currentData{sequence.h}.outlet.concentration;
                        
                        
%                   The calculation of the column in the Zone IV 
%                   node RAFFINATE (index j)
                    case 'j'  

                        column.params = params{sequence.j};
                        column.initialState = currentData{sequence.j}.lastState;

                        %   C_j^in = C_i^out
                        column.inlet.concentration = currentData{sequence.i}.outlet.concentration;


%                   node RAFFINATE (index k)
                    case 'k' 

                        column.params = params{sequence.k};
                        column.initialState = currentData{sequence.k}.lastState;

                        %   C_k^in = C_j^out
                        column.inlet.concentration = currentData{sequence.j}.outlet.concentration;
                        
                        
%                   node RAFFINATE (index l)
                    case 'l' 

                        column.params = params{sequence.l};
                        column.initialState = currentData{sequence.l}.lastState;

                        %   C_l^in = C_k^out
                        column.inlet.concentration = currentData{sequence.k}.outlet.concentration;
                        
                end
                
%     ------------------------------------------------------------------------------------    
            elseif opt.nColumn == 16

                switch index

%                   The calculation of the column in the Zone I
%                   node DESORBENT (index a)
                    case 'a'  

                        column.params = params{sequence.a};
                        column.initialState = currentData{sequence.a}.lastState;

                        %   C_a^in = Q_p * C_p^out / Q_a
                        concentration = zeros(length(Feed.time), 2);

                        column.inlet.concentration = concentration .* params{sequence.p}.interstitialVelocity...
                            ./ params{sequence.a}.interstitialVelocity;


%                   node DESORBENT (index b)
                    case 'b'  

                        column.params = params{sequence.b};
                        column.initialState = currentData{sequence.b}.lastState;

                        %   C_b^in = C_a^out
                        column.inlet.concentration = currentData{sequence.a}.outlet.concentration;


%                   node DESORBENT (index c)
                    case 'c'  

                        column.params = params{sequence.c};
                        column.initialState = currentData{sequence.c}.lastState;

                        %   C_c^in = C_b^out
                        column.inlet.concentration = currentData{sequence.b}.outlet.concentration;
                        
                        
%                   node DESORBENT (index d)
                    case 'd'  

                        column.params = params{sequence.d};
                        column.initialState = currentData{sequence.d}.lastState;

                        %   C_d^in = C_c^out
                        column.inlet.concentration = currentData{sequence.c}.outlet.concentration;
                   
                        
%                   The calculation of the column in the Zone II  
%                   node EXTRACT (index e)
                    case 'e'  

                        column.params = params{sequence.e};
                        column.initialState = currentData{sequence.e}.lastState;

                        %   C_e^in = C_d^out
                        column.inlet.concentration = currentData{sequence.d}.outlet.concentration;


%                   node EXTRACT (index f)
                    case 'f'  

                        column.params = params{sequence.f};
                        column.initialState = currentData{sequence.f}.lastState;

                        %   C_f^in = C_e^out
                        column.inlet.concentration = currentData{sequence.e}.outlet.concentration;


%                   node EXTRACT (index g)
                    case 'g'  

                        column.params = params{sequence.g};
                        column.initialState = currentData{sequence.g}.lastState;

                        %   C_g^in = C_f^out
                        column.inlet.concentration = currentData{sequence.f}.outlet.concentration;
                        
                        
%                   node EXTRACT (index h)
                    case 'h'  

                        column.params = params{sequence.h};
                        column.initialState = currentData{sequence.h}.lastState;

                        %   C_h^in = C_g^out
                        column.inlet.concentration = currentData{sequence.g}.outlet.concentration;
                        
                        
%                   The calculation of the column in the Zone III
%                   node FEED (index i)
                    case 'i' 

                        column.params = params{sequence.i};
                        column.initialState = currentData{sequence.i}.lastState;

                        %   C_i^in = (Q_h * C_h^out + Q_F * C_F) / Q_i
                        column.inlet.concentration = (currentData{sequence.h}.outlet.concentration .* ...
                        params{sequence.h}.interstitialVelocity + Feed.concentration .* interstVelocity.feed) ...
                        ./ params{sequence.i}.interstitialVelocity;


%                   node FEED (index j)
                    case 'j' 

                        column.params = params{sequence.j};
                        column.initialState = currentData{sequence.j}.lastState;

                        %   C_j^in = C_i^out
                        column.inlet.concentration = currentData{sequence.i}.outlet.concentration;


%                   node FEED (index k)
                    case 'k' 

                        column.params = params{sequence.k};
                        column.initialState = currentData{sequence.k}.lastState;

                        %   C_k^in = C_j^out
                        column.inlet.concentration = currentData{sequence.j}.outlet.concentration;
                        
                        
%                   node FEED (index l)
                    case 'l' 

                        column.params = params{sequence.l};
                        column.initialState = currentData{sequence.l}.lastState;

                        %   C_l^in = C_k^out
                        column.inlet.concentration = currentData{sequence.k}.outlet.concentration;
                        
                        
%                   The calculation of the column in the Zone IV 
%                   node RAFFINATE (index m)
                    case 'm'  

                        column.params = params{sequence.m};
                        column.initialState = currentData{sequence.m}.lastState;

                        %   C_m^in = C_l^out
                        column.inlet.concentration = currentData{sequence.l}.outlet.concentration;


%                   node RAFFINATE (index n)
                    case 'n' 

                        column.params = params{sequence.n};
                        column.initialState = currentData{sequence.n}.lastState;

                        %   C_n^in = C_m^out
                        column.inlet.concentration = currentData{sequence.m}.outlet.concentration;
                        
                        
%                   node RAFFINATE (index o)
                    case 'o' 

                        column.params = params{sequence.o};
                        column.initialState = currentData{sequence.o}.lastState;

                        %   C_o^in = C_n^out
                        column.inlet.concentration = currentData{sequence.n}.outlet.concentration;
                        
                        
%                   node RAFFINATE (index p)
                    case 'p' 

                        column.params = params{sequence.p};
                        column.initialState = currentData{sequence.p}.lastState;

                        %   C_p^in = C_o^out
                        column.inlet.concentration = currentData{sequence.o}.outlet.concentration;
                        
                end

            end

        end

        function params = getParams(sequence, interstVelocity, opt)
%-----------------------------------------------------------------------------------------
% After each swtiching, the value of velocities and initial conditions are
% changed 
%-----------------------------------------------------------------------------------------
	

            global string;

            params = cell(1, opt.nColumn);
            for k = 1:opt.nColumn
                params{k} = struct('initMobilCon', [], 'initSolidCon', [], 'interstitialVelocity', []);
            end

            for j = 1:opt.nColumn
%               set the initial conditions to the solver, but when lastState is used, this setup will be ignored        
                params{eval(['sequence' '.' string(j)])}.initMobilCon = zeros(1,opt.nComponents);
                params{eval(['sequence' '.' string(j)])}.initSolidCon = zeros(1,opt.nComponents);
            end

            if opt.nColumn == 4

                for i = 1: opt.nColumn
%                   Interstitial velocity of each ZONE
                    if strcmp('a', string(i))
                        params{eval(['sequence' '.' string(i)])}.interstitialVelocity = interstVelocity.recycle;
                    elseif strcmp('b', string(i))
                        params{eval(['sequence' '.' string(i)])}.interstitialVelocity = interstVelocity.recycle - interstVelocity.extract;
                    elseif strcmp('c', string(i))
                        params{eval(['sequence' '.' string(i)])}.interstitialVelocity = interstVelocity.recycle - interstVelocity.extract + interstVelocity.feed;
                    elseif strcmp('d', string(i))
                        params{eval(['sequence' '.' string(i)])}.interstitialVelocity = interstVelocity.recycle - interstVelocity.desorbent;
                    end
                end

            elseif opt.nColumn == 8

                for i = 1: opt.nColumn
%                   Interstitial velocity of each ZONE
                    if strcmp('a', string(i)) || strcmp('b', string(i))
                        params{eval(['sequence' '.' string(i)])}.interstitialVelocity = interstVelocity.recycle;
                    elseif strcmp('c', string(i)) || strcmp('d', string(i))
                        params{eval(['sequence' '.' string(i)])}.interstitialVelocity = interstVelocity.recycle - interstVelocity.extract;
                    elseif strcmp('e', string(i)) || strcmp('f', string(i))
                        params{eval(['sequence' '.' string(i)])}.interstitialVelocity = interstVelocity.recycle - interstVelocity.extract + interstVelocity.feed;
                    elseif strcmp('g', string(i)) || strcmp('h', string(i))
                        params{eval(['sequence' '.' string(i)])}.interstitialVelocity = interstVelocity.recycle - interstVelocity.desorbent;
                    end
                end

            elseif opt.nColumn == 12
                
                for i = 1: opt.nColumn
%                   Interstitial velocity of each ZONE
                    if strcmp('a', string(i)) || strcmp('b', string(i)) || strcmp('c', string(i))
                        params{eval(['sequence' '.' string(i)])}.interstitialVelocity = interstVelocity.recycle;
                    elseif strcmp('d', string(i)) || strcmp('e', string(i)) || strcmp('f', string(i))
                        params{eval(['sequence' '.' string(i)])}.interstitialVelocity = interstVelocity.recycle - interstVelocity.extract;
                    elseif strcmp('g', string(i)) || strcmp('h', string(i)) || strcmp('i', string(i))
                        params{eval(['sequence' '.' string(i)])}.interstitialVelocity = interstVelocity.recycle - interstVelocity.extract + interstVelocity.feed;
                    elseif strcmp('j', string(i)) || strcmp('k', string(i)) || strcmp('l', string(i))
                        params{eval(['sequence' '.' string(i)])}.interstitialVelocity = interstVelocity.recycle - interstVelocity.desorbent;
                    end
                end
                
            elseif opt.nColumn == 16
                
                for i = 1: opt.nColumn
%                   Interstitial velocity of each ZONE
                    if strcmp('a', string(i)) || strcmp('b', string(i)) || strcmp('c', string(i)) || strcmp('d', string(i))
                        params{eval(['sequence' '.' string(i)])}.interstitialVelocity = interstVelocity.recycle;
                    elseif strcmp('e', string(i)) || strcmp('f', string(i)) || strcmp('g', string(i)) || strcmp('h', string(i))
                        params{eval(['sequence' '.' string(i)])}.interstitialVelocity = interstVelocity.recycle - interstVelocity.extract;
                    elseif strcmp('i', string(i)) || strcmp('j', string(i)) || strcmp('k', string(i)) || strcmp('l', string(i))
                        params{eval(['sequence' '.' string(i)])}.interstitialVelocity = interstVelocity.recycle - interstVelocity.extract + interstVelocity.feed;
                    elseif strcmp('m', string(i)) || strcmp('n', string(i)) || strcmp('o', string(i)) || strcmp('p', string(i))
                        params{eval(['sequence' '.' string(i)])}.interstitialVelocity = interstVelocity.recycle - interstVelocity.desorbent;
                    end
                end 
                
            end

        end
        
        function Results = Purity_Productivity(plotData, opt)
%-----------------------------------------------------------------------------------------
% Calculation of the performance index of SMB, such Purity and Productivity
%
% 
%-----------------------------------------------------------------------------------------


            Nominator = pi * (opt.columnDiameter/2)^2 * opt.columnLength * (1-opt.porosityColumn);

%           using column 1 to calculate the integral of purity
            if opt.nColumn == 4
                position_ext = 1; position_raf = 3;
            elseif opt.nColumn == 8
                position_ext = 8; position_raf = 4;
            elseif opt.nColumn == 12
                position_ext = 11; position_raf = 5;
            elseif opt.nColumn == 16
                position_ext = 14; position_raf = 6;
            end
            
%           Extract ports
            Purity_extract = trapz(plotData{1,position_ext}.outlet.time, plotData{1,position_ext}.outlet.concentration(:,2)) /...
                ( trapz(plotData{1,position_ext}.outlet.time, plotData{1,position_ext}.outlet.concentration(:,2)) +...
                trapz(plotData{1,position_ext}.outlet.time, plotData{1,position_ext}.outlet.concentration(:,1)) );

%           Raffinate ports  	
            Purity_raffinate = trapz(plotData{1,position_raf}.outlet.time, plotData{1,position_raf}.outlet.concentration(:,1)) / ...
                ( trapz(plotData{1,position_raf}.outlet.time, plotData{1,position_raf}.outlet.concentration(:,2)) +...
                trapz(plotData{1,position_raf}.outlet.time, plotData{1,position_raf}.outlet.concentration(:,1)) );	

            
%           per switching time, in the tank of extract port, such (unit: g/m^3) amount of target component was collected.
            MolMass = opt.FructoseMolMass;
            Productivity_extract = trapz(plotData{1,position_ext}.outlet.time, plotData{1,position_ext}.outlet.concentration(:,2))...
                * MolMass * opt.flowRate_recycle / Nominator;

            MolMass = opt.GlucoseMolMass;
            Productivity_raffinate = trapz(plotData{1,position_raf}.outlet.time, plotData{1,position_raf}.outlet.concentration(:,1))...
                * MolMass * opt.flowRate_recycle / Nominator;


            if opt.enableDebug
                fprintf('Purity (Extract): %g %% \n', Purity_extract * 100);
                fprintf('Purity (Raffinate): %g %% \n', Purity_raffinate * 100)
                fprintf('Productivity (Extract) in each switching time: %g g/m^3 \n', Productivity_extract);
                fprintf('Productivity (Raffinate) in each switching time: %g g/m^3 \n', Productivity_raffinate);
            end

            Results = struct('Purity_extract', Purity_extract, 'Purity_raffinate', Purity_raffinate, ...
                'Productivity_extract', Productivity_extract, 'Productivity_raffinate', Productivity_raffinate);
            Results.Data = plotData;

        end

        function objective = objectiveFunction(Results, opt)
%-----------------------------------------------------------------------------------------
% The objective function for the optimizers
% You can also define your own objective function here. The default function is: 
%
% Max Productivity_extract + Productivity_raffinate
% s.t. Purity_extract   >= 99% for more retained component
%      Purity_raffinate >= 99% for less retained component
%      other implicit constraints, such as upbound on Desorbent consumption
%-----------------------------------------------------------------------------------------


%           Construct the Penalty Function for the objective function
            penalty = abs( min(Results.Purity_extract - opt.Purity_extract_limit, 0) ) * opt.Penalty_factor ...
                + abs( min(Results.Purity_raffinate - opt.Purity_raffinate_limit, 0) ) * opt.Penalty_factor;

%           (-)Since in the optimizer, the defined programme is of optimization of minimum.    
            objective = -(Results.Productivity_extract + Results.Productivity_raffinate) + penalty;

            if opt.enableDebug
                fprintf('**** The objective value:  %g \n', objective);
            end

        end

        function plotFigures(opt, plotData)
%-----------------------------------------------------------------------------------------
%  This is the plot function 
%  The numbers in the figure() represent the number of the columns
%-----------------------------------------------------------------------------------------


            if nargin < 2
                disp('Error: there are no enough input data for the function, plotFigures');
            else
                if isempty(opt)
                    disp('Error in plotFigures: the options of the parameters are missing');
                elseif isempty(plotData)
                    disp('Error in plotFigures: the data for figures plotting are missing');
                end
            end

            if opt.enableDebug                        

                if opt.nColumn == 4

                    for j = 1:opt.nColumn

                        figure(j);clf

                        y = [plotData{j,1}.outlet.concentration; plotData{j,2}.outlet.concentration;...
                            plotData{j,3}.outlet.concentration; plotData{j,4}.outlet.concentration];

                        FigSet = plot(y); axis([0,opt.nColumn*opt.timePoints, 0,opt.yLim])
                        ylabel('Concentration [Mol]', 'FontSize', 10);
                        legend('comp 1', 'comp 2');

                        set(FigSet, 'LineWidth', 2);
                        set(gca, 'FontName', 'Times New Roman', 'FontSize', 10);
                        set(gca, 'XTick', opt.timePoints/2:opt.timePoints:(opt.nColumn-0.5)*opt.timePoints);
                        set(gca, 'ygrid', 'on');

                        switch j
                            case 1
                                set(gca, 'XTickLabel', {'Zone I','Zone IV','Zone III','Zone II'});
                            case 2
                                set(gca, 'XTickLabel', {'Zone II','Zone I','Zone IV','Zone III'});
                            case 3
                                set(gca, 'XTickLabel', {'Zone III','Zone II','Zone I','Zone IV'});
                            case 4
                                set(gca, 'XTickLabel', {'Zone IV','Zone III','Zone II','Zone I'});
                        end

                        for i = 1: (opt.nColumn-1)
                            line([i*opt.timePoints,i*opt.timePoints], [0, opt.yLim], 'color', 'k', 'LineStyle', '-.');
                        end

                    end

                elseif opt.nColumn == 8

                    for j = 1:opt.nColumn

                        figure(j);clf

                        y = [plotData{j,1}.outlet.concentration; plotData{j,2}.outlet.concentration;...
                            plotData{j,3}.outlet.concentration; plotData{j,4}.outlet.concentration;...
                            plotData{j,5}.outlet.concentration; plotData{j,6}.outlet.concentration;...
                            plotData{j,7}.outlet.concentration; plotData{j,8}.outlet.concentration];

                        FigSet = plot(y); axis([0,opt.nColumn*opt.timePoints, 0,opt.yLim])
                        ylabel('Concentration [Mol]', 'FontSize', 10);
                        legend('comp 1', 'comp 2');

                        set(FigSet, 'LineWidth', 2);
                        set(gca, 'FontName', 'Times New Roman', 'FontSize', 10);
                        set(gca, 'ygrid', 'on');

                        switch j
                            case 1
                                set(gca, 'XTick', (0:2:opt.nColumn).*opt.timePoints);
                                set(gca, 'XTickLabel', {'Zone I','Zone IV','Zone III','Zone II','Zone I'});
                            case 2
                                set(gca, 'XTick', (1:2:(opt.nColumn-1)).*opt.timePoints);
                                set(gca, 'XTickLabel', {'Zone I','Zone IV','Zone III','Zone II'});
                            case 3
                                set(gca, 'XTick', (0:2:opt.nColumn).*opt.timePoints);
                                set(gca, 'XTickLabel', {'Zone II','Zone I','Zone IV','Zone III','Zone II'});
                            case 4
                                set(gca, 'XTick', (1:2:(opt.nColumn-1)).*opt.timePoints);
                                set(gca, 'XTickLabel', {'Zone II','Zone I','Zone IV','Zone III'});
                            case 5
                                set(gca, 'XTick', (0:2:opt.nColumn).*opt.timePoints);
                                set(gca, 'XTickLabel', {'Zone III','Zone II','Zone I','Zone IV','Zone III'});
                            case 6
                                set(gca, 'XTick', (1:2:(opt.nColumn-1)).*opt.timePoints);
                                set(gca, 'XTickLabel', {'Zone III','Zone II','Zone I','Zone IV'});
                            case 7
                                set(gca, 'XTick', (0:2:opt.nColumn).*opt.timePoints);
                                set(gca, 'XTickLabel', {'Zone IV','Zone III','Zone II','Zone I','Zone IV'});
                            case 8
                                set(gca, 'XTick', (1:2:(opt.nColumn-1)).*opt.timePoints);
                                set(gca, 'XTickLabel', {'Zone IV','Zone III','Zone II','Zone I'});
                        end

                        for i = 1: (opt.nColumn-1)
                            line([i*opt.timePoints,i*opt.timePoints], [0, opt.yLim], 'color', 'k', 'LineStyle', '-.');
                        end

                    end
                    
                elseif opt.nColumn == 12
                    
                    for j = 1:opt.nColumn

                        figure(j);clf

                        y = [plotData{j,1}.outlet.concentration; plotData{j,2}.outlet.concentration;...
                            plotData{j,3}.outlet.concentration; plotData{j,4}.outlet.concentration;...
                            plotData{j,5}.outlet.concentration; plotData{j,6}.outlet.concentration;...
                            plotData{j,7}.outlet.concentration; plotData{j,8}.outlet.concentration;...
                            plotData{j,9}.outlet.concentration; plotData{j,10}.outlet.concentration;...
                            plotData{j,11}.outlet.concentration; plotData{j,12}.outlet.concentration];

                        FigSet = plot(y); axis([0,opt.nColumn*opt.timePoints, 0,opt.yLim])
                        ylabel('Concentration [Mol]', 'FontSize', 10);
                        legend('comp 1', 'comp 2');

                        set(FigSet, 'LineWidth', 2);
                        set(gca, 'FontName', 'Times New Roman', 'FontSize', 10);
                        set(gca, 'ygrid', 'on');

                        switch j
                            case 1
                                set(gca, 'XTick', ((opt.nColumn/8+1) : 3: opt.nColumn).*opt.timePoints);
                                set(gca, 'XTickLabel', {'Zone IV','Zone III','Zone II','Zone I'});
                            case 2
                                set(gca, 'XTick', ((opt.nColumn/8-1) : 3: (opt.nColumn-opt.nColumn/8)).*opt.timePoints);
                                set(gca, 'XTickLabel', {'Zone I','Zone IV','Zone III','Zone II'});
                            case 3
                                set(gca, 'XTick', (opt.nColumn/8 : 3: (opt.nColumn-opt.nColumn/8)).*opt.timePoints);
                                set(gca, 'XTickLabel', {'Zone I','Zone IV','Zone III','Zone II'});
                            case 4
                                set(gca, 'XTick', ((opt.nColumn/8+1) : 3: opt.nColumn).*opt.timePoints);
                                set(gca, 'XTickLabel', {'Zone I','Zone IV','Zone III','Zone II'});
                            case 5
                                set(gca, 'XTick', ((opt.nColumn/8-1) : 3: (opt.nColumn-opt.nColumn/8)).*opt.timePoints);
                                set(gca, 'XTickLabel', {'Zone II','Zone I','Zone IV','Zone III'});
                            case 6
                                set(gca, 'XTick', (opt.nColumn/8 : 3: (opt.nColumn-opt.nColumn/8)).*opt.timePoints);
                                set(gca, 'XTickLabel', {'Zone II','Zone I','Zone IV','Zone III'});
                            case 7
                                set(gca, 'XTick', ((opt.nColumn/8+1) : 3: opt.nColumn).*opt.timePoints);
                                set(gca, 'XTickLabel', {'Zone II','Zone I','Zone IV','Zone III'});
                            case 8
                                set(gca, 'XTick', ((opt.nColumn/8-1) : 3: (opt.nColumn-opt.nColumn/8)).*opt.timePoints);
                                set(gca, 'XTickLabel', {'Zone III','Zone II','Zone I','Zone IV'});
                            case 9
                                set(gca, 'XTick', (opt.nColumn/8 : 3: (opt.nColumn-opt.nColumn/8)).*opt.timePoints);
                                set(gca, 'XTickLabel', {'Zone III','Zone II','Zone I','Zone IV'});
                            case 10
                                set(gca, 'XTick', ((opt.nColumn/8+1) : 3: opt.nColumn).*opt.timePoints);
                                set(gca, 'XTickLabel', {'Zone III','Zone II','Zone I','Zone IV'});
                            case 11
                                set(gca, 'XTick', ((opt.nColumn/8-1) : 3: (opt.nColumn-opt.nColumn/8)).*opt.timePoints);
                                set(gca, 'XTickLabel', {'Zone IV','Zone III','Zone II','Zone I'});
                            case 12
                                set(gca, 'XTick', (opt.nColumn/8 : 3: (opt.nColumn-opt.nColumn/8)).*opt.timePoints);
                                set(gca, 'XTickLabel', {'Zone IV','Zone III','Zone II','Zone I'});
                        end

                        for i = 1: (opt.nColumn-1)
                            line([i*opt.timePoints,i*opt.timePoints], [0, opt.yLim], 'color', 'k', 'LineStyle', '-.');
                        end

                    end
                    
                elseif opt.nColumn == 16
                    
                    for j = 1:opt.nColumn

                        figure(j);clf

                        y = [plotData{j,1}.outlet.concentration; plotData{j,2}.outlet.concentration;...
                            plotData{j,3}.outlet.concentration; plotData{j,4}.outlet.concentration;...
                            plotData{j,5}.outlet.concentration; plotData{j,6}.outlet.concentration;...
                            plotData{j,7}.outlet.concentration; plotData{j,8}.outlet.concentration;...
                            plotData{j,9}.outlet.concentration; plotData{j,10}.outlet.concentration;...
                            plotData{j,11}.outlet.concentration; plotData{j,12}.outlet.concentration;...
                            plotData{j,13}.outlet.concentration; plotData{j,14}.outlet.concentration;...
                            plotData{j,15}.outlet.concentration; plotData{j,16}.outlet.concentration];

                        FigSet = plot(y); axis([0,opt.nColumn*opt.timePoints, 0,opt.yLim])
                        ylabel('Concentration [Mol]', 'FontSize', 10);
                        legend('comp 1', 'comp 2');

                        set(FigSet, 'LineWidth', 2);
                        set(gca, 'FontName', 'Times New Roman', 'FontSize', 10);
                        set(gca, 'ygrid', 'on');

                        switch j
                            case 1
                                set(gca, 'XTick', (opt.nColumn/8+1 : 4: opt.nColumn).*opt.timePoints);
                                set(gca, 'XTickLabel', {'Zone IV','Zone III','Zone II','Zone I'});
                            case 2
                                set(gca, 'XTick', (0:4:opt.nColumn).*opt.timePoints);
                                set(gca, 'XTickLabel', {'Zone I','Zone IV','Zone III','Zone II','Zone I'});
                            case 3
                                set(gca, 'XTick', (opt.nColumn/8-1 : 4: opt.nColumn).*opt.timePoints);
                                set(gca, 'XTickLabel', {'Zone I','Zone IV','Zone III','Zone II'});
                            case 4
                                set(gca, 'XTick', (opt.nColumn/8 : 4: opt.nColumn).*opt.timePoints);
                                set(gca, 'XTickLabel', {'Zone I','Zone IV','Zone III','Zone II'});
                            case 5
                                set(gca, 'XTick', (opt.nColumn/8+1 : 4: opt.nColumn).*opt.timePoints);
                                set(gca, 'XTickLabel', {'Zone I','Zone IV','Zone III','Zone II'});
                            case 6
                                set(gca, 'XTick', (0:4:opt.nColumn).*opt.timePoints);
                                set(gca, 'XTickLabel', {'Zone II','Zone I','Zone IV','Zone III','Zone II'});
                            case 7
                                set(gca, 'XTick', (opt.nColumn/8-1 : 4: opt.nColumn).*opt.timePoints);
                                set(gca, 'XTickLabel', {'Zone II','Zone I','Zone IV','Zone III'});
                            case 8
                                set(gca, 'XTick', (opt.nColumn/8 : 4: opt.nColumn).*opt.timePoints);
                                set(gca, 'XTickLabel', {'Zone II','Zone I','Zone IV','Zone III'});
                            case 9
                                set(gca, 'XTick', (opt.nColumn/8+1 : 4: opt.nColumn).*opt.timePoints);
                                set(gca, 'XTickLabel', {'Zone II','Zone I','Zone IV','Zone III'});
                            case 10
                                set(gca, 'XTick', (0:4:opt.nColumn).*opt.timePoints);
                                set(gca, 'XTickLabel', {'Zone III','Zone II','Zone I','Zone IV','Zone III'});
                            case 11
                                set(gca, 'XTick', (opt.nColumn/8-1 : 4: opt.nColumn).*opt.timePoints);
                                set(gca, 'XTickLabel', {'Zone III','Zone II','Zone I','Zone IV'});
                            case 12
                                set(gca, 'XTick', (opt.nColumn/8 : 4: opt.nColumn).*opt.timePoints);
                                set(gca, 'XTickLabel', {'Zone III','Zone II','Zone I','Zone IV'});
                            case 13
                                set(gca, 'XTick', (opt.nColumn/8+1 : 4: opt.nColumn).*opt.timePoints);
                                set(gca, 'XTickLabel', {'Zone III','Zone II','Zone I','Zone IV'});
                            case 14
                                set(gca, 'XTick', (0:4:opt.nColumn).*opt.timePoints);
                                set(gca, 'XTickLabel', {'Zone IV','Zone III','Zone II','Zone I','Zone IV'});
                            case 15
                                set(gca, 'XTick', (opt.nColumn/8-1 : 4: opt.nColumn).*opt.timePoints);
                                set(gca, 'XTickLabel', {'Zone IV','Zone III','Zone II','Zone I'});
                            case 16
                                set(gca, 'XTick', (opt.nColumn/8 : 4: opt.nColumn).*opt.timePoints);
                                set(gca, 'XTickLabel', {'Zone IV','Zone III','Zone II','Zone I'});
                        end

                        for i = 1: (opt.nColumn-1)
                            line([i*opt.timePoints,i*opt.timePoints], [0, yLim], 'color', 'k', 'LineStyle', '-.');
                        end

                    end

                end

            end

        end
        
    end
    
end
% =============================================================================
%  SMB - The Simulated Moving Bed Chromatography for separation of
%  target compounds, such as fructose and glucose.
%  
%  Author: QiaoLe He   E-mail: q.he@fz-juelich.de
%                                      
%  Institute: Forschungszentrum Juelich GmbH, IBG-1, Juelich, Germany.
%  
%  All rights reserved. Please see the license of CADET.
% =============================================================================