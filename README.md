# **2D differential conductance from quantum (electron) transmissions**

## Overview
This repository contains Fortran code designed to accept DFT + NEGF-produced quantum electron transmission curves of a material (such as armchair graphene nanoribbon) at varying bias voltages (say, from -1 V to +1 V). It finds the current per the Landauer-Buttikker formalism and makes the 2D differential conductance spectrum. The two dimensions are the bias and gate voltages.

Transport calculations are based on density functional theory (DFT) with single-particle Green’s function method (DFT-NEGF) as implemented in the `PosTrans` plugin on the `SIESTA` package.

The Landauer-Büttiker formalism is utilized to calculate the current:

$I(E_F,V_b)=\frac{2e}{h}\int \tau (E, V_b) [f(E,μ_s) – f(E,μ_d)] dE$ 

where $\tau = Tr[\Gamma_L G \Gamma_R G^{\dagger}]$ represents the transmission. $μ_{s/d} = E_F ± V_b/2$. $E_F$ changes when the gate voltage $V_g$ is applied. The $V_g$ is applied using a virtual sweeping of $[f(E,μ_s) – f(E,μ_d)]$ to the given energy point.

## Prerequisites
Before using this package, ensure the following software/files is installed/available:
- **Python**
- **Fortran 90** compiler: `ifort` or `gfortran`

## How to run the script?
- Ensure that the parameter file `current-and-conductance.in` is correct.
- Keep all transmission files at regular intervals of $V_b$, as per the parameter file (see T(in)).

You can simply run:

```bash
ifort current-and-conductance_highprecision.f90
```

Once the postprocessing is complete, the Python scripts will automatically render the 2D differential conductance spectrum.

Data file: `2d-diff-g.dat`

Image file: `2d-diff-g.jpg`

## More information
The 2D differential conductance spectra calculated using this code can be found in our paper: [A. C. Rajan et al. ACS nano 2014](https://pubs.acs.org/doi/full/10.1021/nn4062148).

## License
&copy; Arun Rajan
