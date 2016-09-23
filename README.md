![](https://github.com/modsim/CADET/blob/master/doc/logo/CADET-GitHub.png)

# CADET-SMB

CADET-SMB is a comprehensive simulator for analysis and design of simulated moving bed (SMB) chromatographic processes. It is developed at the Institute of Bio- and Geosciences 1 (IBG-1) of Forschungszentrum Jülich (FZJ) under supervision of Dr. Eric von Lieres. CADET-SMB uses the simulation engine of the CADET framework, which provides a fast and accurate solver for the general rate model (GRM) of packed bed liquid chromatography.

# Introduction

There are various practical modes of preparative chromatography. Cyclic batch elution chromatography is most frequently applied, and an efficient simulator is provided in the CADET framework (https://github.com/modsim/CADET). In counter-current chromatography, the fluid and solid phases are moved through the column in opposite directions. Since the true moving bed (TMB) process is technically very hard to implement, the simulated moving bed (SMB) process is usually applied. In this repository, we offer an extension of the CADET framework, CADET-SMB, for simulating SMB chromatographic processes.

# Features

Code features are organized into network setup, numerical methods, and inverse problems.

## Network setup

![](https://github.com/modsim/CADET-SMB/blob/master/doc/Network_setup.JPG)

SMB chromatography has originally been developed for binary (two components) separations. This is typically achieved using four distinct zones with one or more column each. Later, SMB variants have been developed for ternary (three components) separations. Two major strategies can be distinguished, both of which have advantages and disadvantages: a) sequential cascade of two conventional SMB units with eight zones in total, and b) integrated SMB units with eight or down to five zones. Moreover, CADET-SMB can be set-up with arbitrary column configurations, e.g., for simulating multicolumn countercurrent solvent gradient purification (MCSGP).

## Numerical methods

![](https://github.com/modsim/CADET-SMB/blob/master/doc/Numerical_computing.JPG)

CADET-SMB provides two classes of numerical solution approaches: a) fixed point iteration (FPI) for computing the cyclic steady state (CSS) of an SMB unit, and b) operator splitting (OSP) for computing the dynamic trajectory (DTR) from any initial system state into the CSS. Two variants are implemented for each approach, standard versions (STD-FPI, STD-OPS) and alternatives with significantly improved numerical efficience, namely fixed point iteration for the one-column analog (OCA-FPI) and lag-aware operator splitting (LAW-OPS). The improved perfornamce of these numerical methods can be particularly useful in optimization settings. Details on all four approaches can be found in the documentation.

## Inverse problems

![](https://github.com/modsim/CADET-SMB/blob/master/doc/Inverse_problems.JPG)

Optimization of the CADET-SMB includes two parts, the optimization of decision variables and the optimization of the column configurations. The optimization of the column configuration part is still in development, so it is not presented yet. Regarding the optimization part of the decision variables, once the column configuration (it can be an arbitrary one, e.g. 1-2-3-1 or 2-1-3-2-4) is confirmed whenever by the structural optimization algorithm or mentally decision, the processing parameters (e.g. flow rates in different zones, switch time, column length) can be optimized with the user-defined objective function, which might aims to improve the productivity, or purity, or operation costs. As for the optimization algorithm, there are four options, a MATLAB build-in deterministic algorithm, the particle swarm optimization (PSO), the differential evolution (DE), and the Metropolis adjusted differential evolution (MADE). 

So far, the standard SMB approach and the one-column analog approach are combined with the optimization functionality, whereas the operator-splitting approach and the advanced operator-splitting approach are not. As the major goal of these two approaches is to approach the true trajectory.

## Feature list

![](https://github.com/modsim/CADET-SMB/blob/master/doc/diagram.JPG)

* Binary separation is available using four-zone scheme; ternary components in binary separation are also possible;

* Ternary separation can be achieved by using integrated five-zone scheme, eight-zone scheme, or cascade scheme; quaternary components in ternary separation are possible;

![](https://github.com/modsim/CADET-SMB/blob/master/doc/scheme.JPG)
*Four-zone scheme and five-zone scheme*

![](https://github.com/modsim/CADET-SMB/blob/master/doc/scheme_8.JPG)
*Eight-zone scheme with internal raffinate and internal extract*

![](https://github.com/modsim/CADET-SMB/blob/master/doc/cascade.JPG)
*Cascade scheme*


![](https://github.com/modsim/CADET-SMB/blob/master/doc/profile_binary.JPG)
![](https://github.com/modsim/CADET-SMB/blob/master/doc/profile_ternary_5.JPG)
*Chromatogram with four-zone and five-zone scheme*

![](https://github.com/modsim/CADET-SMB/blob/master/doc/profile_ternary_8.JPG)
*Chromatogram with eight-zone scheme*

* In both binary and ternary separations, arbitrary column configurations are available, in addition to basic column configurations such as 1-1-1-1, 2-2-2-2-2, 3-3-3-3, and 4-4-4-4-4;

* By using operator-splitting, the true dynamics of the concentration profiles (also, trajectories) can be reproduced. Also using one-column analog, the convergence speed to the cyclic steady state (CSS) could be accelerated.

* Continuous stirred tank reactor (CSTR) and dispersive plug flow reactor (DPFR) models can be placed before and after each column to account for dead volumes in pumps, tubing, and valves;
![](https://github.com/modsim/CADET-SMB/blob/master/doc/dead_volumes.JPG)
*The schematic of the dead volumes consideration*


* In binary separation, the ModiCon process is also available;

* MATLAB interface allows to monitor the dynamic characteristics of each column in the SMB unit;

* Optimization of decision variables for improving, e.g., productivity, purity, operating costs;

* Parameter estimation from experimental data will be implemented in future versions;

* Column models include transport dispersive model, equilibrium dispersive model, and general rate model;

* Wide range of standard equilibrium/isotherm models allow to simulate either pure component or multi-component/competitive behaviour;

* Further features of the CADET framework can be found at https://github.com/modsim/CADET.


# Dependency and Platforms

* Matlab(R2010b or higher);
* CADET (version 2.3.2 or later);
* platforms, please see the Dependencies section in the CADET wiki.

# Tutorial and Instructions

First, download the CADET software from https://github.com/modsim/CADET-SMB/releases, as CADET-SMB is based on the CADET simulator.
Then, download the latest release of CADET-SMB from https://github.com/modsim/CADET-SMB/releases.

## Installation of the CADET

* download the latest release for your platform;
* unzip the archive to your destination directory;
* start MATLAB;
* change directory to the unzipped CADET directory and run installCADET.m (you can save the MATLAB path to avoid calling installCADET.m every time you restart MATLAB);
* Try one of the examples (e.g., examples/forward/loadWashElution.m) to check if everything works.
 
## Installation of the CADET-SMB,

* create a directory, simulatedMovingBed, in your unzipped CADET directory;
* unzip the CADET-SMB archive to the simulatedMovingBed directory;
* Change the working directory to the simulatedMovingBed directory and run isSMBupdateAvailable.m script (Along side checking the existence of the newest version, it also attach the current path the MATLAB path); 
* To test a forward simulation, copy any getParameter_something script from the examples/Forward folder to the simulatedMovingBed folder and change the name to getParameters.m; then run simulatedMovingBed.m.
* To test an optimization, copy any getParameter_something script from the examples/Optimization folder to the simulatedMovingBed folder and also change the name to getParameters.m; then run SMBOptimization.m.

# Demonstration 

Several examples are provided in the repository. 

* The four-column case for binary separation is taken from the paper http://dx.doi.org/10.1016/j.compchemeng.2006.06.013;
* the eight-column case for binary separation is taken from the paper http://dx.doi.org/10.1016/S0959-1524(01)00005-1; 
* the parameters of the ternary component in the binary separation example is made up from the eight-column case artificially;
* the five-column case for ternary separation is taken from the paper http://dx.doi.org/10.1016/j.chroma.2011.09.015; 
* the ten-column case for ternary separation is taken from the paper http://dx.doi.org/10.1016/j.ces.2004.10.007.

By the way, the demonstration cases can directly be run by coping them from the examples directory to the simulatedMovingBed directory, then changing the file name to getParameters.m. Apparently, the examples can also be modified by replacing your own models, operating conditions, and optimization routines. 

* How to write your own getParameters routine?
* How to adopt other isotherm models?

# Documentation 

For more details of the CADET-SMB software, see the file doc.pdf in the repository.

# Further Development 

CADET-SMB is actively developed. Hence, breaking changes and extensive restructuring may occur in any commit and release. For non-developers it is recommended to upgrade from release to release instead of always working with the most recent commit.
