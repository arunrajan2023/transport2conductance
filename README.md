# **2D differential conductance from quantum (electron) transmissions**

## Overview
This repository contains Fortran code designed to accept DFT + NEGF-produced quantum electron transmission curves of a material (such as armchair graphene nanoribbon) at varying bias voltages (say, from -1 V to +1 V). It finds the current per the Landauer-Buttikker formalism and makes the 2D differential conductance spectrum. 

The two dimensions are the bias and gate voltages. The gate voltage $V_g$ is applied by means of a virtual sweeping of $[f(E,μ_s) – f(E,μ_d)]$ to the given energy point

Given DFT + NEGF produced quantum electron transmission curves of armchair graphene nanoribbon at varying bias voltages (say from -1 V to +1 V), the 2D differential conductance plots can be found, as described in our paper: https://pubs.acs.org/doi/full/10.1021/nn4062148 (A. C. Rajan et al. ACS nano 2014)

# Main code (Written in Fortran 90)

current-and-conductance_highprecision.f90

# Parameter file:

current-and-conductance.in

# Input files

All transmission files (i.e., with *.t extension)

# Main output (2D differential conductance spectrum)

Data file: 2d-diff-g.dat

Image file: 2d-diff-g.jpg


