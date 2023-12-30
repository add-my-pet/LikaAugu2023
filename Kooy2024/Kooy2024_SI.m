function Kooy2024_SI(fig)
% Supporting Information for Kooy2024
% Title: Ways to reduce or avoid juvenile-driven cycles in IBM's
% Authors: Kooijman
% Journal: Ecol. Mod
% DOI: 
% Date: 2023/12/03
% 
% Matlab scripts to generate the figures in the publication
%
% To run the scripts you need
% 1) Matlab (the student or Home version will suffice)
% 2) Copy DEBtool from http://www.github.com/add-my-pet/DEBtool_M/ in a directory, set the path in Matlab to this directory.
% 3) Download NetLogo from https://ccl.northwestern.edu/netlogo/ (I used version 6.2.0), and set a path to it
% 4) Download Java from https://www.java.com/nl/download/ie_manual.jsp and set a path to it
% 5) Download a C-compiler and set a path to it; the EBT code is already included in DEBtool_M/popDyn/EBTtool.
%    I used MinGW from https://ics.uci.edu/~pattis/common/handouts/mingweclipse/mingw.html
% The various IBM models are in DEBtool_M/popDyn/IBMnlogo
%
% Set Path in Matlab is in the toolbar of the Command Window of Matlab if full-screen.
% The code changes directories and returns to the original after successfull completion.
% If it got stuck, however, you need to return to the original directory yourself.
% For this reason I advice to start the Matlab session with "WD=pwd;" to later use "cd(WD)" to return, if necessary.
% Load this file in the Matlab Editor
% To run the code for a figure: type in the Matlab window e.g. Kooy2024_SI(2)
%
% Remark:
% This file assumes that you run NetLogo under Matlab (the last input in the call to IBM is 1).
% Although IBM allows to run the code directly under NetLogo, a few simple changes are required in this file.

    close all

    if ~exist('fig','var')
      fig = 1;
    end

    % Set reactor pars
    my_pet = 'Daphnia_magna'; % a random species from the AmP collection
    tJX = 0.001; % mol/d, food input into reactor
    V_X = 1; % L, volume of reactor
    h = [.1 1e-35 5e-4 5e-4 0]; 
      % 1/d, hazard rates [h_X, h_B0b, h_Bbp, h_Bpi, thin]
    t_max = 180; % d, max run time
    tickRate = 24;
    numPar = [];

    path = [set_path2server, 'add_my_pet/entries/', my_pet, '/']; results = ['results_', my_pet, '.mat']; 
    if ismac || isunix
      system(['wget -O results.mat ', path, results]);
    else
      system(['powershell wget -O results.mat ', path, results]);
    end
    load('results', 'metaData', 'metaPar', 'par', 'txtPar');
    close all
 
 switch fig % IBM std, only for checking code
   case 0 % juvenile-driven cycles from DEB2023
    
    % run std
    txN_IBM = IBM(my_pet,[],tJX,[],V_X,h,[],t_max,tickRate,1);
    
    % plot
    title_txt = [strrep(my_pet,'_',' '), ' @ ', datestr(date,26)];

    figure % food
    plot(txN_IBM(:,1),txN_IBM(:,2),'r', 'linewidth',2)
    xlabel('time, d'); ylabel('scaled food density X/K, -'); title(title_txt); 
    set(gca, 'FontSize', 15, 'Box', 'on'); 
    %saveas (gca, 't_x_IBM.png')
 
    figure % numbers
    plot(txN_IBM(:,1),txN_IBM(:,3),'r', 'linewidth',2)
    xlabel('time, d'); ylabel('# of individuals, -'); title(title_txt)
    set(gca, 'FontSize', 15, 'Box', 'on'); 
    %saveas (gca, 't_N_IBM.png')
 
    figure % biomass
    plot(txN_IBM(:,1),txN_IBM(:,7),'r', 'linewidth',2)
    xlabel('time, d'); ylabel('total biomass, g'); title(title_txt)
    set(gca, 'FontSize', 15, 'Box', 'on'); 
    %saveas (gca, 't_W_IBM.png')
     
   case 1 %  Fig 1: ref, IBM compared with EBT

     metaPar.model = 'stdadlt'; % like std, but adults are also counted separately
     data = {metaData, metaPar, par, txtPar};

     % run std in IBM and EBT
     txN_IBM = IBM(data,[],tJX,[],V_X,h,[],t_max,tickRate,1);
     txN_EBT = EBT(my_pet,[],tJX,[],V_X,h,t_max,numPar);
    
     % plot
     title_txt = 'IBM {\it vs} EBT';

     figure % food
     plot(txN_IBM(:,1),txN_IBM(:,2),'r',  txN_EBT(:,1),txN_EBT(:,2),'b', 'linewidth',2)
     xlabel('time, d'); ylabel('scaled food density X/K, -'); title(title_txt); 
     set(gca, 'FontSize', 15, 'Box', 'on'); 
     %saveas (gca, 't_x_ref.png')
 
     figure % numbers
     plot(txN_IBM(:,1),txN_IBM(:,3),'r', txN_IBM(:,1),txN_IBM(:,4),'m', txN_EBT(:,1),txN_EBT(:,3),'b', 'linewidth',2)
     xlabel('time, d'); ylabel('# of individuals, -'); title(title_txt)
     set(gca, 'FontSize', 15, 'Box', 'on'); 
     %saveas (gca, 't_N_ref.png')
 
     figure % biomass
     plot(txN_IBM(:,1),txN_IBM(:,8),'r', txN_EBT(:,1),txN_EBT(:,7),'b', 'linewidth',2) % mass in here in col 8
     xlabel('time, d'); ylabel('total biomass, g'); title(title_txt)
     set(gca, 'FontSize', 15, 'Box', 'on'); 
     %saveas (gca, 't_W_ref.png')
 
     hleg = shllegend({{'-',2,[1 0 0]},'IBM';{'-',2,[0 0 1]},'EBT'});
     %saveas (hleg, 'legend_ref.png')
    
  case 2 % Fig 2: thin, effects of thinning
    % run std as ref
    txN = IBM(my_pet,[],tJX,[],V_X,h,[],t_max,tickRate,1);

    % thinning
    h(end) = 1; % apply thinning
    txN_thin = IBM(my_pet,[],tJX,[],V_X,h,[],t_max,tickRate,1);
   
    % plot
    title_txt = 'thinning';

    figure % food
    plot(txN(:,1),txN(:,2),'r',  txN_thin(:,1),txN_thin(:,2),'b', 'linewidth',2)
    xlabel('time, d'); ylabel('scaled food density X/K, -'); title(title_txt); 
    set(gca, 'FontSize', 15, 'Box', 'on'); 
    %saveas (gca, 't_x_thin.png')
 
    figure % numbers
    plot(txN(:,1),txN(:,3),'r', txN_thin(:,1),txN_thin(:,3),'b', txN_thin(:,1),txN_thin(:,4),'c', 'linewidth',2)
    xlabel('time, d'); ylabel('# of individuals, -'); title(title_txt)
    set(gca, 'FontSize', 15, 'Box', 'on'); 
    %saveas (gca, 't_N_thin.png')
 
    figure % biomass
    plot(txN(:,1),txN(:,8),'r', txN_thin(:,1),txN_thin(:,8),'b', 'linewidth',2)
    xlabel('time, d'); ylabel('total biomass, g'); title(title_txt)
    set(gca, 'FontSize', 15, 'Box', 'on'); 
    %saveas (gca, 't_W_thin.png')

    hleg = shllegend({{'-',2,[1 0 0]},'no thinning';{'-',2,[0 0 1]},'thinning'});
    %saveas (hleg, 'legend_ref.png')

  case 3 % Fig 3: rdn, effects of scatter in E_Hp and p_M
    % run std as ref
    txN = IBM(my_pet,[],tJX,[],V_X,h,[],t_max,tickRate,1);

    % scatter
    metaPar.model = 'stdrnd';
    data = {metaData, metaPar, par, txtPar};
    txN_rnd = IBM(data,[],tJX,[],V_X,h,[],t_max,tickRate,1);
   
    % plot
    title_txt = 'scatter in E_H^p, [p_M]';

    figure % food
    plot(txN(:,1),txN(:,2),'r',  txN_rnd(:,1),txN_rnd(:,2),'b', 'linewidth',2)
    xlabel('time, d'); ylabel('scaled food density X/K, -'); title(title_txt); 
    set(gca, 'FontSize', 15, 'Box', 'on'); 
    %saveas (gca, 't_x_rnd.png')
 
    figure % numbers
    plot(txN(:,1),txN(:,3),'r', txN_rnd(:,1),txN_rnd(:,3),'b', txN_rnd(:,1),txN_rnd(:,4),'c', 'linewidth',2)
    xlabel('time, d'); ylabel('# of individuals, -'); title(title_txt)
    set(gca, 'FontSize', 15, 'Box', 'on'); 
    %saveas (gca, 't_N_rnd.png')
 
    figure % biomass
    plot(txN(:,1),txN(:,8),'r', txN_rnd(:,1),txN_rnd(:,8),'b', 'linewidth',2)
    xlabel('time, d'); ylabel('total biomass, g'); title(title_txt)
    set(gca, 'FontSize', 15, 'Box', 'on'); 
    %saveas (gca, 't_W_rnd.png')

    hleg = shllegend({{'-',2,[1 0 0]},'no scatter';{'-',2,[0 0 1]},'scatter'});
    %saveas (hleg, 'legend_ref.png')

  case 4 % Fig 4: migr, effects of immigration
    % run std as ref
    txN = IBM(my_pet,[],tJX,[],V_X,h,[],t_max,tickRate,1);

    % immigration
    metaPar.model = 'stdmigr';
    % h = [.1 1e-35 5e-4 5e-4 0]; % 1/d, hazard rates [h_X, h_B0b, h_Bbp, h_Bpi, thin]
    par.h_migr = 0.1; h(4) = 0.1;
    data = {metaData, metaPar, par, txtPar};
    txN_migr = IBM(data,[],tJX,[],V_X,h,[],t_max,tickRate,1);

    % plot
    title_txt = 'immigration';

    figure % food
    plot(txN(:,1),txN(:,2),'r', txN_migr(:,1),txN_migr(:,2),'b', 'linewidth',2)
    xlabel('time, d'); ylabel('scaled food density X/K, -'); title(title_txt); 
    set(gca, 'FontSize', 15, 'Box', 'on'); 
    %saveas (gca, 't_x_migr.png')
 
    figure % numbers
    plot(txN(:,1),txN(:,3),'r', txN_migr(:,1),txN_migr(:,3),'b', txN_migr(:,1),txN_migr(:,4),'c', 'linewidth',2)
    xlabel('time, d'); ylabel('# of individuals, -'); title(title_txt)
    set(gca, 'FontSize', 15, 'Box', 'on'); 
    %saveas (gca, 't_N_migr.png')
 
    figure % biomass
    plot(txN(:,1),txN(:,8),'r', txN_migr(:,1),txN_migr(:,7),'b', 'linewidth',2)
    xlabel('time, d'); ylabel('total biomass, g'); title(title_txt)
    set(gca, 'FontSize', 15, 'Box', 'on'); 
    %saveas (gca, 't_W_migr.png')

    hleg = shllegend({{'-',2,[1 0 0]},'no migration';{'-',2,[0 0 1]},'migration'});
    %saveas (hleg, 'legend_ref.png')

  case 5 % Fig 5: osc, effects of oscillating input      
    % run std as ref
    txN = IBM(my_pet,[],tJX,[],V_X,h,[],t_max,tickRate,1);

    % tJX spline
    JX = 2*0.001; % mol/d, food input into reactor; 2 times the previous value, because input is zero for half of the time
    % switching instantaneously between input JX and zero after time interval dt
    dt = 3; n = ceil(t_max/dt); t = (0:n)*dt; t = [t;t]; t=t(:); t(1)=[]; 
    n=1+ceil(n/2); JX = [JX*ones(2,n);zeros(2,n)]; JX=JX(:); JX(end)=[]; tJX = [t,JX(1:length(t))]; 
    txN_osc = IBM(my_pet,[],tJX,[],V_X,h,[],t_max,tickRate,1);
   
    % plot
    title_txt = 'pulsed food input';

    figure % food
    plot(txN(:,1),txN(:,2),'r',  txN_osc(:,1),txN_osc(:,2),'b', 'linewidth',2)
    xlabel('time, d'); ylabel('scaled food density X/K, -'); title(title_txt); 
    set(gca, 'FontSize', 15, 'Box', 'on'); 
    %saveas (gca, 't_x_osc.png')
 
    figure % numbers
    plot(txN(:,1),txN(:,3),'r', txN_osc(:,1),txN_osc(:,3),'b', txN_osc(:,1),txN_osc(:,4),'c', 'linewidth',2)
    xlabel('time, d'); ylabel('# of individuals, -'); title(title_txt)
    set(gca, 'FontSize', 15, 'Box', 'on'); 
    %saveas (gca, 't_N_osc.png')
 
    figure % biomass
    plot(txN(:,1),txN(:,8),'r', txN_osc(:,1),txN_osc(:,8),'b', 'linewidth',2)
    xlabel('time, d'); ylabel('total biomass, g'); title(title_txt)
    set(gca, 'FontSize', 15, 'Box', 'on'); 
    %saveas (gca, 't_W_osc.png')

    hleg = shllegend({{'-',2,[1 0 0]},'no oscillation';{'-',2,[0 0 1]},'oscillation'});
    %saveas (hleg, 'legend_osc.png')

  case 6 % Fig 6: slp, effects of sleep
    % run std as ref
    txN = IBM(my_pet,[],tJX,[],V_X,h,[],t_max,tickRate,1);

    % sleep; check with case 9 that k_Y is low enough to avoid that 
    %   e can become larger than e without sleep for low f
    metaPar.model = 'stdslp';
    par.k_Y = 90; % mol/d^2.cm^3, 1/duration of sleep at max respiration density
    par.F_Y = 10; % L/d, sleep frequency
    data = {metaData, metaPar, par, txtPar};
    txN_slp = IBM(data,[],tJX,[],V_X,h,[],t_max,tickRate,1);

    % plot
    title_txt = 'sleep';

    figure % food
    plot(txN(:,1),txN(:,2),'r', txN_slp(:,1),txN_slp(:,2),'b', 'linewidth',2)
    xlabel('time, d'); ylabel('scaled food density X/K, -'); title(title_txt); 
    set(gca, 'FontSize', 15, 'Box', 'on'); 
    %saveas (gca, 't_x_slp.png')
 
    figure % numbers
    plot(txN(:,1),txN(:,3),'r', txN_slp(:,1),txN_slp(:,3),'b', txN_slp(:,1),txN_slp(:,4),'c',  'linewidth',2)
    xlabel('time, d'); ylabel('# of individuals, -'); title(title_txt)
    set(gca, 'FontSize', 15, 'Box', 'on'); 
    %saveas (gca, 't_N_slp.png')
 
    figure % biomass
    plot(txN(:,1),txN(:,8),'r', txN_slp(:,1),txN_slp(:,8),'b', 'linewidth',2)
    xlabel('time, d'); ylabel('total biomass, g'); title(title_txt)
    set(gca, 'FontSize', 15, 'Box', 'on'); 
    %saveas (gca, 't_W_slp.png')

    hleg = shllegend({{'-',2,[1 0 0]},'no sleep';{'-',2,[0 0 1]},'sleep'});
    %saveas (hleg, 'legend_ref.png')

  case 7 % Fig 7: soc, effects of socialisation
    %t_max = 5 * t_max;  
      
    % run std as ref
    txN = IBM(my_pet,[],tJX,[],V_X,h,[],t_max,tickRate,1);

    % socialisation
    metaPar.model = 'stdsoc';
    par.k_Y = 80;  % 1/d, 1/duration of an interaction
    par.F_Y = 8; % L/d, encounter frequency
    data = {metaData, metaPar, par, txtPar};
    txN_soc = IBM(data,[],tJX,[],V_X,h,[],t_max,tickRate,1);

    % plot
    title_txt = 'socialisation';

    figure % food
    plot(txN(:,1),txN(:,2),'r', txN_soc(:,1),txN_soc(:,2),'b', 'linewidth',2)
    xlabel('time, d'); ylabel('scaled food density X/K, -'); title(title_txt); 
    set(gca, 'FontSize', 15, 'Box', 'on'); 
    %saveas (gca, 't_x_soc.png')
 
    figure % numbers
    plot(txN(:,1),txN(:,3),'r', txN_soc(:,1),txN_soc(:,3),'b', txN_soc(:,1),txN_soc(:,4),'c', 'linewidth',2)
    xlabel('time, d'); ylabel('# of individuals, -'); title(title_txt)
    set(gca, 'FontSize', 15, 'Box', 'on'); 
    %saveas (gca, 't_N_soc.png')
 
    figure % biomass
    plot(txN(:,1),txN(:,8),'r', txN_soc(:,1),txN_soc(:,8),'b', 'linewidth',2)
    xlabel('time, d'); ylabel('total biomass, g'); title(title_txt)
    set(gca, 'FontSize', 15, 'Box', 'on'); 
    %saveas (gca, 't_W_soc.png')

    hleg = shllegend({{'-',2,[1 0 0]},'no socialisation';{'-',2,[0 0 1]},'socialisation'});
    %saveas (hleg, 'legend_ref.png')

  case 8 % Fig 8: 211, effects of 2 types of food with preference
    % t_max = 5 * t_max;

    % run std as ref
    txN = IBM(my_pet,[],tJX,[],V_X,h,[],t_max,tickRate,1);

    % set extra pars
    metaPar.model = 'std211';
    h211 = [.1 .1 1e-35 5e-4 5e-4 0]; % 1/d, hazard rates [h_X1, h_X2, h_B0b, h_Bbp, h_Bpi, thin]
    tJX1 = 0.0005; tJX2 = 0.001; % mol/d, food input into reactor
    par.mu_X1 = par.mu_X;   % J, chemical potential of food 1
    par.mu_X2 = par.mu_X;   % J, chemical potential of food 2
    par.kap_X1 = 0.9;       % -, digestion efficiency for food 1
    par.kap_X2 = 0.4;       % -, digestion efficiency for food 2
    X1_0 = 0; X2_0 = 0; % Mol, initial densities of food 1, 2

    % run std211
    data = {metaData, metaPar, par, txtPar};
    txxN_211 = IBM211(data,[],tJX1,tJX2,X1_0,X2_0,V_X,h211,[],t_max,tickRate,1);

    % plot
    title_txt = '2 food types';

    figure % food
    plot(txN(:,1),txN(:,2),'r',  ...
        txxN_211(:,1),txxN_211(:,2),'b', ...
        txxN_211(:,1),txxN_211(:,3),'k','linewidth',2)
    xlabel('time, d'); ylabel('scaled food densities X/K, -'); title(title_txt); 
    set(gca, 'FontSize', 15, 'Box', 'on'); 
    %saveas (gca, 't_x_211.png')
 
    figure % numbers
    plot(txN(:,1),txN(:,3),'r', txxN_211(:,1),txxN_211(:,4),'b', txxN_211(:,1),txxN_211(:,5),'c', 'linewidth',2)
    xlabel('time, d'); ylabel('# of individuals, -'); title(title_txt)
    set(gca, 'FontSize', 15, 'Box', 'on'); 
    %saveas (gca, 't_N_211.png')
 
    figure % biomass
    plot(txN(:,1),txN(:,8),'r', txxN_211(:,1),txxN_211(:,9),'b', 'linewidth',2)
    xlabel('time, d'); ylabel('total biomass, g'); title(title_txt)
    set(gca, 'FontSize', 15, 'Box', 'on'); 
    %saveas (gca, 't_W_211.png')

    hleg = shllegend({{'-',2,[1 0 0]},'1 food type';
                      {'-',2,[0 0 1]},'2 types, high quality';
                      {'-',2,[0 0 0]},'2 types, low quality'});
    %saveas (hleg, 'legend_ref.png')
   
  case 9 % sleeping at ind level; selected copy-paste from stdslp.nlogo to test Java code

    vars_pull(par); vars_pull(parscomp_st(par)); 
    k_Y = 90; % mol/d^2.cm^3, 1/duration of sleep at max respiration density
    F_Y = 10; % L/d, sleep frequency
    J_XAm = p_Am/ kap_X/ mu_X; % mol/d.cm^2, spec food intake
    J_EAm = p_Am/ mu_E; % mol/d.cm^2, spec assim rate
    f = 0.99; % -, scaled func response
    t = linspace(0,50,100); % d, time
    L_b = L_m * get_lb([g k v_Hb], f); % cm, struc length at birth
    [t, HeL] = ode45(@get_dHeL, t, [E_Hb, 0.9*f, L_b], [], f, K, J_EAm, F_m, F_Y, k_Y, E_Hp, p_Am, p_M, g, v, kap, kap_R, k_J, kap_X, mu_X, mu_E);
    
    figure % reserve density
    plot(t,f*ones(100,1),'r', t,HeL(:,2),'b', 'linewidth',2)
    xlabel('time since birth, d'); ylabel('scaled reserve density, e');
    set(gca, 'FontSize', 15, 'Box', 'on'); 

    figure % struc length
    plot(t, f*L_m-(f*L_m-L_b)*exp(-t*k_M/3/(1+f/g)),'r', t,HeL(:,3),'b', 'linewidth',2)
    xlabel('time since birth, d'); ylabel('structural length, L');
    set(gca, 'FontSize', 15, 'Box', 'on'); 

 end
end
 
% subfunction
function dHeL = get_dHeL (t, HeL, f, K, J_EAm, F_m, F_Y, k_Y, E_Hp, p_Am, p_M, g, v, kap, kap_R, k_J, kap_X, mu_X, mu_E)
    persistent L_p
    E_H = HeL(1); e = HeL(2); L = HeL(3); 
    
    L_m = kap * p_Am/ p_M; % cm, max struc length
    E_m = p_Am/ v; % J/cm^3, max reserve density 
    X = K/ (1.000001 - f);
    % f = X/ (K + X); -, scaled functional response

    r = v * (e / L - 1 / L_m) / (e + g) ; % 1/d, positive spec growth rate
    p_C = e * E_m * L * L * L * (v / L - r) ; % J/d, reserve mobilisation rate
    dE_H = (1 - kap) * p_C - k_J * E_H ; % J/d, change in maturation

    p_A = p_M * f * L_m / kap / L; % J/d.cm^3, vol-spec assim rate
    if E_H < E_Hp
      L_p = L; 
      p_D = p_M * (1 + (1 - kap) / kap * e * (g * L_m / L + 1) / (g + e)) ; % J/d.cm^3, vol-spec dissipation rate
    else
      p_D = p_M * (1 + (1 - kap) / kap * (kap_R * (L_p / L) ^ 3 + (1 - kap_R) * e * (g * L_m / L + 1) / (g + e))) ; % J/d.cm^3, vol-spec dispation rate
    end
    p_G = p_M * (e * L_m / L - 1) / (e / g + 1) ; % J/d.cm^3, vol-spec growth rate
    J_O = (0.0198 * p_A + 0.1977 * p_D + 0.0012 * p_G) ; % mol/d.cm^3, vol-spec O2 consumption rate
    %k_E = J_XAm * L * L ; % dissociation rate of E with SU
    k_E = J_EAm * L * L ; % dissociation rate of E with SU
    b_X = mu_X/ mu_E * kap_X * X * F_m * L * L ; % association rate of X with SU
    b_Y = F_Y ; % association rate of sleep with SU
    k_YO = k_Y / J_O ; % dissociation rate of sleep with SU
    th_X = 1 / (1 + k_E / b_X + b_Y * k_E / b_X / k_YO + b_Y / (k_E + k_YO) * (1 + k_E / k_YO + k_E / b_X + k_E * b_Y / k_YO / b_X));
    % J_X =  th_X * (k_E + b_Y * k_E / (k_E + k_YO)) ; % Mol/d, food consumption
    de = (th_X * (1 + b_Y / (k_E + k_YO)) - e) * v / L ; % 1/d, change in scaled reserve density
 
    dL = L * r / 3 ; % cm/d, change in structural length
    
    dHeL = [dE_H; de; dL];
end
