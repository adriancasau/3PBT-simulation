# Three-Point Bending Simulator for Composite Laminates
3PBT MATLAB analysis of Laminated Composite Materials through Classical Lamination Theory (CLT) and First Shear-Order Deformation Theory (FSDT).

**Bachelor's Thesis · ETSEIB, Universitat Politècnica de Catalunya (UPC) · July 2026**  
Author: Adrián Casaudoumecq Tusquets · Supervisor: Oriol Bové Tous

---

## What is this?

This repository contains a MATLAB script developed as a Bachelor's Thesis at ETSEIB (UPC). Its purpose is to **predict the mechanical behaviour of composite sandwich panels under three-point bending tests** — specifically, the deflection, stress distribution through the thickness, and safety factor against failure.

It was built for the **Bcn eMotorsport Formula Student team**, which uses sandwich panels in the car's monocoque and needs a transparent, reliable tool to evaluate their stiffness and strength without relying on commercial black-box FEA software.

The code implements two theories:
- **Classical Lamination Theory (CLT)** — for thin laminates
- **First-Order Shear Deformation Theory (FSDT)** — for sandwich panels, where the soft core deforms significantly in shear

Failure is evaluated ply by ply using the **Tsai-Wu criterion**, and the results are validated against physical three-point bending tests on CFRP specimens.

---

## How to use it
There is two MATLAB codes, both calculate the same but one is a livescript that explains the equations behind the code.
Open the preferred script in MATLAB and edit the four input blocks: the materials characterization, the laminate stacking sequence, applied forces and the test geometry.

**1. Define the laminate stacking sequence**

Each row is one ply: `[angle(°), E1, E2, G12, nu12, thickness, F1t, F1c, F2t, F2c, F6]` (properties in MPa and mm).

```matlab
% Material properties
M1 = [225e3, 6.68e3, 4.08e3, 0.32, 0.124, 1816, 854, 31.4, 235, 75.4];
M2 = [73.9e3, 71.5e3, 4.03e3, 0.07, 0.209, 1106, 969, 776, 738, 117];

% Stacking sequence: [angle, material properties]
laminate = [  0,  M2;
              0,  M1;
             45,  M2;
             45,  M2;
              0,  M1;
              0,  M2];
```

**2. Set the test geometry and applied forces and run**

```matlab
length = 180;   % span (mm)
width = 40;    % width (mm)

% Set the forces and moments to analyze a laminate under these loads
% For example, the following loads analyze the laminate under a uniaxial test
Nx = 1; % N/mm (force/width)
Ny = 0; % N/mm (force/width)
Ns = 0; % N/mm (force/width)
Mx = 0; % N*mm/mm (moment/width)
My = 0; % N*mm/mm (moment/width)
Ms = 0; % N*mm/mm (moment/width)

% Also you can calculate the force vs displacement graph for a 3pbt.
% This is a different study from the one above. 
F = 1:1:200;   % applied load (N) only for 3PBT. Different force value to map force vs displacement.
```

The script outputs the maximum deflection, the stress distribution across all plies, and the global safety factor against first-ply failure.

No additional MATLAB toolboxes are required.

---

## References

- Daniel & Ishai — *Engineering Mechanics of Composite Materials*, 2nd ed., Oxford University Press, 2006
- Reddy, J.N. — *Mechanics of Laminated Composite Plates and Shells*, 2nd ed., CRC Press, 2004

---

## Contact

**Adrián Casaudoumecq Tusquets**  
📧 adriancasaudoumecq@gmail.com  
🔗 [LinkedIn]([https://www.linkedin.com/in/adri%C3%A1n-casaudoumecq-tusquets-1575612a0/]

*Developed in the context of the Bcn eMotorsport Formula Student team. Built for engineers who want to understand what's inside the black box.*
