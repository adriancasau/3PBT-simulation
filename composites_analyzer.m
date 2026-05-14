%% Elastic Properties of a Lamina

% Change properties if needed
E1 = 73900;
E2 = 71500;
G12 = 4030;
nu12 = 0.07;

% Calculations
nu21=E2*nu12/E1;

Q11 = E1/(1-nu12*nu21);
Q22 = E2/(1-nu12*nu21);
Q12 = (nu21*E1)/(1-nu12*nu21);
Q66 = G12;

Q = [Q11 Q12 0;
     Q12 Q22 0;
     0   0   Q66]

%% Transformation of elastic parameters (two dimensional)

% We will calculate the [Q]x,y matrix
% First we need the define the [T] matrix
theta = pi/4; % Variable to change

m = cos(theta);
n = sin(theta);

T = [  m^2,    n^2,      2*m*n;
       n^2,    m^2,     -2*m*n;
      -m*n,    m*n,  m^2 - n^2 ];

Q_rewritten = [Q11 Q12 0;
               Q12 Q22 0;
               0    0  2*Q66];

Qxy = T\Q_rewritten*T % The last column is multiplied by 2 

%% Transformation of stress-strain relations in terms of engineering constants

% Transformed compliance terms
inv_Ex   =  m^2/E1*(m^2 - n^2*nu12) + n^2/E2*(n^2 - m^2*nu21) + m^2*n^2/G12;
inv_Ey   =  n^2/E1*(n^2 - m^2*nu12) + m^2/E2*(m^2 - n^2*nu21) + m^2*n^2/G12;
inv_Gxy  =  4*m^2*n^2/E1*(1+nu12) + 4*m^2*n^2/E2*(1+nu21) + (m^2-n^2)^2/G12;
nuxy_Ex  =  m^2/E1*(m^2*nu12 - n^2) + n^2/E2*(n^2*nu21 - m^2) + m^2*n^2/G12;
etaxs_Ex =  2*m^3*n/E1*(1+nu12) - 2*m*n^3/E2*(1+nu21) - m*n*(m^2-n^2)/G12;
etays_Ey =  2*m*n^3/E1*(1+nu12) - 2*m^3*n/E2*(1+nu21) + m*n*(m^2-n^2)/G12;

% Compliance matrix in x-y coordinates
S_xy = [inv_Ex,   -nuxy_Ex,  etaxs_Ex;
       -nuxy_Ex,   inv_Ey,   etays_Ey;
        etaxs_Ex,  etays_Ey, inv_Gxy]
% Significant transformed properties
Ex_lamina = 1/S_xy(1,1)
Ey_lamina = 1/S_xy(2,2)

%% Elastic behaviour of Multidirectional Laminates

M1 = [225e3, 6.68e3, 4.08e3, 0.32, 0.124, 1816, 854, 31.4, 235, 75.4]; %[E1(MPa), E2(MPa), G12(MPa), poisson12, thickness(mm), F1t(Mpa), F1c(MPa), F2t(MPa), F2c(MPa), F6(MPa)]
M2 = [73.9e3, 71.5e3, 4.03e3, 0.07, 0.209, 1106, 969, 776, 738, 117];
% Introduce layup as:
% [angle_ply1, material_ply1;
% angle_ply2, material_ply2;
% ...]
width = 40; % laminate width [mm]
length = 180; % laminate length [mm]
laminate = [0, M1;
            0, M1;
            0, M1;
            0, M1;
            0, M1;
            0, M1;
            0, M1;
            0, M1;];
thk0 = 0;
for i=1:size(laminate, 1)
    thk=laminate(i,6) + thk0;
    thk0=thk;
end
h=thk; % Laminate height
z0=-thk0/2; % z of the first ply (starts from the bottom)

A0 = zeros(3,3);
B0 = zeros(3,3);
D0 = zeros(3,3);
zkm1=z0; % zkm1 = z_(k-1)
for i = 1:size(laminate,1)
theta = laminate(i,1); %The angle 0 is measured positive counterclockwise from the x-axis to the 1-axis.
                  %x-axis: laminate coordinate, 1-axis: Lamina principal axes
E1 = laminate(i,2);
E2 = laminate(i,3);
G12 = laminate(i,4);
poisson12 = laminate(i,5);
poisson21 = E2*poisson12/E1;
zk = zkm1 + laminate(i,6);
m = cosd(theta);
n = sind(theta);

% Mathematical constants
Q11 = E1/(1-poisson12*poisson21);
Q22 = E2/(1-poisson12*poisson21);
Q12 = (poisson21*E1)/(1-poisson12*poisson21);
Q66 = G12;

S11 = 1/E1;
S22 = 1/E2;
S12 = -poisson12/E1;
S66 = 1/G12;

Q = [Q11, Q12, 0;
    Q12, Q22, 0;
    0, 0, Q66];
S = [S11, S12, 0;
    S12, S22, 0;
    0, 0, S66];
T = [m^2, n^2, 2*m*n;
    n^2, m^2, -2*m*n;
    -m*n, m*n, m^2-n^2];

% Transformed mathematical constants
Qxx = m^4*Q11 + n^4*Q22 + 2*m^2*n^2*Q12 + 4*m^2*n^2*Q66;
Qyy = n^4*Q11 + m^4*Q22 + 2*m^2*n^2*Q12 + 4*m^2*n^2*Q66;
Qxy = m^2*n^2*Q11 + m^2*n^2*Q22 + (m^4+n^4)*Q12 - 4*m^2*n^2*Q66;
Qxs = m^3*n*Q11 - m*n^3*Q22 - m*n*(m^2-n^2)*Q12 - 2*m*n*(m^2-n^2)*Q66;
Qys = m*n^3*Q11 - m^3*n*Q22 + m*n*(m^2-n^2)*Q12 + 2*m*n*(m^2-n^2)*Q66;
Qss = m^2*n^2*Q11 + m^2*n^2*Q22 - 2*m^2*n^2*Q12 + (m^2-n^2)^2*Q66;

Sxx = m^4*S11 + n^4*S22 + 2*m^2*n^2*S12 + m^2*n^2*S66;
Syy = n^4*S11 + m^4*S22 + 2*m^2*n^2*S12 + m^2*n^2*S66;
Sxy = m^2*n^2*S11 + m^2*n^2*S22 + (m^4+n^4)*S12 - m^2*n^2*S66;
Sxs = 2*m^3*n*S11 - 2*m*n^3*S22 - 2*m*n*(m^2-n^2)*S12 - m*n*(m^2-n^2)*S66;
Sys = 2*m*n^3*S11 - 2*m^3*n*S22 + 2*m*n*(m^2-n^2)*S12 + m*n*(m^2-n^2)*S66;
Sss = 4*m^2*n^2*S11 + 4*m^2*n^2*S22 - 8*m^2*n^2*S12 + (m^2-n^2)^2*S66;

A = [Qxx*(zk-zkm1), Qxy*(zk-zkm1), Qxs*(zk-zkm1);
    Qxy*(zk-zkm1), Qyy*(zk-zkm1), Qys*(zk-zkm1);
    Qxs*(zk-zkm1), Qys*(zk-zkm1), Qss*(zk-zkm1)] + A0; 

B = 1/2*[Qxx*(zk^2-zkm1^2), Qxy*(zk^2-zkm1^2), Qxs*(zk^2-zkm1^2);
    Qxy*(zk^2-zkm1^2), Qyy*(zk^2-zkm1^2), Qys*(zk^2-zkm1^2);
    Qxs*(zk^2-zkm1^2), Qys*(zk^2-zkm1^2), Qss*(zk^2-zkm1^2)] + B0;

D = 1/3*[Qxx*(zk^3-zkm1^3), Qxy*(zk^3-zkm1^3), Qxs*(zk^3-zkm1^3);
    Qxy*(zk^3-zkm1^3), Qyy*(zk^3-zkm1^3), Qys*(zk^3-zkm1^3);
    Qxs*(zk^3-zkm1^3), Qys*(zk^3-zkm1^3), Qss*(zk^3-zkm1^3)] + D0;

A0 = A;
B0 = B;
D0 = D;
zkm1 = zk;
end

if all(abs(B(:))<10^-10)
    B = zeros(size(B));
    B0 = zeros(size(B));
end

K = A - B * (D \ B);
a = K \ eye(size(K));
axx = a(1,1); axy = a(1,2); axs = a(1,3); 
ayx = a(2,1); ayy = a(2,2); ays = a(2,3);
asx = a(3,1); asy = a(3,2); ass = a(3,3);

% Transformed engineering constants for general laminates
Ex = 1/(h*axx)
Ey = 1/(h*ayy)
Gxy = 1/(h*ass)
poissonxy = -ayx/axx
poissonyx = -axy/ayy;
etasx = axs/ass;
etaxs = asx/axx;
etays = asy;
etasy = ays/ass;

%% Stress and Strain Analysis with Tsai-Wu Failure Criterion

% Set the forces and moments
Nx = 1; % N/mm (force/width)
Ny = 0; % N/mm (force/width)
Ns = 0; % N/mm (force/width)
Mx = 0; % N*mm/mm (moment/width)
My = 0; % N*mm/mm (moment/width)
Ms = 0; % N*mm/mm (moment/width)

midstrains_and_curvatures = [A, B; B, D]\[Nx; Ny; Ns; Mx; My; Ms];
z0=-thk0/2;
zkm1=z0; % zkm1 = z_(k-1)
n_plies = size(laminate,1);
strain_x = zeros(n_plies, 2);
% stress_xy = zeros(n_plies, 2); 
Sfa = zeros(n_plies, 2);
Sfr = zeros(n_plies, 2);

for i = 1:size(laminate,1)
theta = laminate(i,1); %The angle 0 is measured positive counterclockwise from the x-axis to the 1-axis.
                       %x-axis: laminate coordinate, 1-axis: Lamina principal axes
E1 = laminate(i,2);
E2 = laminate(i,3);
G12 = laminate(i,4);
poisson12 = laminate(i,5);
poisson21 = E2*poisson12/E1;
m = cosd(theta);
n = sind(theta);

% Mathematical constants
Q11 = E1/(1-poisson12*poisson21);
Q22 = E2/(1-poisson12*poisson21);
Q12 = (poisson21*E1)/(1-poisson12*poisson21);
Q66 = G12;

zk = zkm1 + laminate(i,6);
strain_bottom_ply_xy = midstrains_and_curvatures(1:3) + zkm1*midstrains_and_curvatures(4:6);
strain_top_ply_xy = midstrains_and_curvatures(1:3) + zk*midstrains_and_curvatures(4:6);

T = [m^2, n^2, 2*m*n;
    n^2, m^2, -2*m*n;
    -m*n, m*n, m^2-n^2];

strain_bottom_ply_12 = T*([1, 0, 0; 0, 1, 0; 0, 0, 0.5]*strain_bottom_ply_xy); % gives [epsilon1; epsilon2; 0.5*gamma6]
strain_top_ply_12 = T*([1, 0, 0; 0, 1, 0; 0, 0, 0.5]*strain_top_ply_xy);

Q = [Q11, Q12, 0;
    Q12, Q22, 0;
    0, 0, Q66];

stress_bottom_ply_12 = Q*([1, 0, 0; 0, 1, 0; 0, 0, 2]*strain_bottom_ply_12); %gives [sigma1; sigma2; tau6]
sigma1_bottom = stress_bottom_ply_12(1);
sigma2_bottom = stress_bottom_ply_12(2);
tau6_bottom = stress_bottom_ply_12(3);

stress_top_ply_12 = Q*([1, 0, 0; 0, 1, 0; 0, 0, 2]*strain_top_ply_12);
sigma1_top = stress_top_ply_12(1);
sigma2_top = stress_top_ply_12(2);
tau6_top = stress_top_ply_12(3);

% Tsai-Wu Failure Criterion
F1t = laminate(i, 7);
F1c = laminate(i, 8);
F2t = laminate(i, 9);
F2c = laminate(i, 10);
F6 = laminate(i, 11);

f1 = 1/F1t-1/F1c;
f2 = 1/F2t-1/F2c;
f11 = 1/(F1t*F1c);
f22 = 1/(F2t*F2c);
f66 = 1/(F6)^2;
f12 = -0.5*(f11*f22)^0.5;

a_bottom = f11*sigma1_bottom^2+f22*sigma2_bottom^2+f66*tau6_bottom^2+2*f12*sigma1_bottom*sigma2_bottom;
b_bottom = f1*sigma1_bottom+f2*sigma2_bottom;
Sfka_bottom = (-b_bottom+sqrt(b_bottom^2+4*a_bottom))/(2*a_bottom);
Sfkr_bottom = abs((-b_bottom-sqrt(b_bottom^2+4*a_bottom))/(2*a_bottom));

a_top = f11*sigma1_top^2+f22*sigma2_top^2+f66*tau6_top^2+2*f12*sigma1_top*sigma2_top;
b_top = f1*sigma1_top+f2*sigma2_top;
Sfka_top = (-b_top+sqrt(b_top^2+4*a_top))/(2*a_top);
Sfkr_top = abs((-b_top-sqrt(b_top^2+4*a_top))/(2*a_top));

strain_x(i,:) = [strain_bottom_ply_xy(1), strain_top_ply_xy(1)];
Sfa(i,:) = [Sfka_bottom, Sfka_top];
Sfr(i,:) = [Sfkr_bottom, Sfkr_top];

zkm1 = zk;
end

Sfa_min = min(Sfa, [], "all")
Sfr_min = min(Sfr, [], "all")

%% Axial Test
Max_actual_strain_x = max(strain_x, [], "all") % Max strain for this Nx
Max_force_x = Sfa_min*Nx*width/1000 % Max resistible force [kN]
Max_displacement_x = Sfa_min*Max_actual_strain_x*length % Displacement for the max resistible force [mm]

%% 3-Point Bending Test (simply supported)

% For a simply supported 3pbt with a force F [N]
F = 0:0.5:140; 
d = inv(D);
d11 = d(1,1);
wmax = d11*F*length^3/(width*48);
plot(wmax, F)
datos = [wmax; F];
writematrix(datos', 'archivo.xlsx', 'Sheet', 1, 'Range', 'A1', 'WriteMode', 'overwritesheet');