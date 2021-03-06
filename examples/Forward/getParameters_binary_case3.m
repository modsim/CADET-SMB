function [opt, interstVelocity, Feed, Desorbent] = getParameters(varargin)
% =============================================================================
%   Case 1a, a 4-zone eight-column case for binary separation
%
% This is the function to input all the necessary data for simulation
% Returns:
%       1. opt stands for options, which involves the parameter settings
%       for the algorithm, the binding isotherm, and the model equations
%
%       2. interstVelocity is calculated from flowrate of each column and inlet.
%       interstitial_velocity = flow_rate / (across_area * porosity_Column)
%
%       3. Feed initializes the injection concentration
% =============================================================================


    % The parameter setting for simulator
    opt.tolIter         = 1e-4;
    opt.nMaxIter        = 1000;
    opt.nThreads        = 4;
    opt.nCellsColumn    = 40;
    opt.nCellsParticle  = 1;
    opt.ABSTOL          = 1e-10;
    opt.INIT_STEP_SIZE  = 1e-14;
    opt.MAX_STEPS       = 5e6;
    opt.enableDebug     = true;

    % The parameter setting for the SMB
    opt.switch          = 180; % s
    opt.timePoints      = 1000;
    opt.Purity_limit    = [0.99, 0.99];
    opt.Penalty_factor  = 10;

    % Network configuration
    opt.nZone       = 4;
    opt.nColumn     = 8;
    opt.structID    = [2 2 2 2]; % 8 columns in four-zone, 2 in each zone

    % Binding: Linear Binding isotherm
    opt.BindingModel = 'MultiComponentLangmuirBinding';
    opt.nComponents = 2;
    opt.KA = [5.72, 7.70]; % [comp_A, comp_B], A for raffinate, B for extract
    opt.KD = [1, 1];
    opt.QMAX = [1.0, 1.0];
    opt.compTargID = [2, 1]; % target components at [Extract Raffinate] ports

    % Transport
    opt.dispersionColumn          = ones(1,opt.nZone) .* 3.30e-26;  % D_{ax} m^2/s
    opt.filmDiffusion             = [1e-5, 1e-5];                   % K_f m/s
    opt.diffusionParticle         = [1.6e4, 1.6e4];                 % D_p m^2/s
    opt.diffusionParticleSurface  = [0.0, 0.0];

    % Geometry
    opt.columnLength        = 0.25;      % m
    opt.columnDiameter      = 0.02;      % m
    opt.particleRadius      = 0.0005;    % m
    opt.porosityColumn      = 0.83;
    opt.porosityParticle    = 0.000001;  % e_p very small to ensure e_t = e_c

    % Parameter units transformation
    % The flow rate of Zone I was defined as the recycle flow rate
    crossArea = pi * (opt.columnDiameter/2)^2;  % m^2
    flowRate.recycle    = 9.62e-7;              % m^3/s
    flowRate.feed       = 0.98e-7;              % m^3/s
    flowRate.raffinate  = 1.40e-7;              % m^3/s
    flowRate.desorbent  = 1.96e-7;              % m^3/s
    flowRate.extract    = 1.54e-7;              % m^3/s
    opt.flowRate_extract   = flowRate.extract;
    opt.flowRate_raffinate = flowRate.raffinate;

    % Interstitial velocity = flow_rate / (across_area * opt.porosityColumn)
    interstVelocity.recycle   = flowRate.recycle / (crossArea*opt.porosityColumn);      % m/s
    interstVelocity.feed      = flowRate.feed / (crossArea*opt.porosityColumn);         % m/s
    interstVelocity.raffinate = flowRate.raffinate / (crossArea*opt.porosityColumn);    % m/s
    interstVelocity.desorbent = flowRate.desorbent / (crossArea*opt.porosityColumn);    % m/s
    interstVelocity.extract   = flowRate.extract / (crossArea*opt.porosityColumn);      % m/s

    concentrationFeed   = [0.55, 0.55]; % g/m^3
    opt.molMass         = [1000, 1000]; % g/mol
    opt.yLim            = max(concentrationFeed ./ opt.molMass); % mol/m^3

    % Feed concentration setup
    Feed.time = linspace(0, opt.switch, opt.timePoints);
    Feed.concentration = zeros(length(Feed.time), opt.nComponents);
    Desorbent.concentration = zeros(length(Feed.time), opt.nComponents);

    for i = 1:opt.nComponents
        Feed.concentration(1:end, i) = concentrationFeed(i) / opt.molMass(i); % mol/m^3
    end

% -----------------------------------------------------------------------------
    % Capable of placing a CSTR or DPFR apparatues before and after the calculated column

    % Continuous Stirred Tank Reactor
    opt.enable_CSTR = false;
    opt.CSTR_length = 0.01;

    % Dispersive Plug Flow Reactor
    opt.enable_DPFR = false;

    opt.DPFR_length = 0.0016;
    opt.DPFR_nCells = 50;

    opt.DPFR_velocity   = 0.00315;
    opt.DPFR_dispersion = 2.5e-30;


end
% =============================================================================
%  SMB - The Simulated Moving Bed Chromatography for separation of
%  target compounds, either binary or ternary.
%
%      Copyright © 2008-2017: Eric von Lieres, Qiaole He
%
%      Forschungszentrum Juelich GmbH, IBG-1, Juelich, Germany.
%
%  All rights reserved. This program and the accompanying materials
%  are made available under the terms of the GNU Public License v3.0 (or, at
%  your option, any later version) which accompanies this distribution, and
%  is available at http://www.gnu.org/licenses/gpl.html
% =============================================================================
