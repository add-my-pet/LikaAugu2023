
    close all
    clear all
    
    shstat_options('default');
    shstat_options('x_transform', 'none');
    shstat_options('y_transform', 'none');
    vars = read_allStat('E_Hb', 'E_Hp', 'L_b', 'L_p', 'del_Ub'); 
    sHL = vars(:,1) ./ vars(:,2) .* (vars(:,4)./vars(:,3)).^3; del_Ub = vars(:,5);
    xtxt = '\delta_U^b, -';
    ytxt = 's_{HL}^{bp}, -';
    v1 = del_Ub; v2 = sHL; vtxt = 'delUb_sH';

    figure(1)
    legend_RXSE = {...
        {'o', 8, 3, [1 0 0], [1 0 0]}, 'Echinodermata'; ....
        {'o', 8, 3, [0 0 0], [0 0 0]}, 'Radiata'; ...
        {'o', 8, 3, [0 0 0], [0 0 1]}, 'Xenacoelomorpha'; ...
        {'o', 8, 3, [0 0 1], [0 0 1]}, 'Spiralia'; ...
        {'o', 8, 3, [1 0 1], [1 0 1]}, 'Ecdysozoa'; ....
    };
    [Hfig Hleg] = shstat([v1, v2], legend_RXSE, 'invertebrates', 1); 
    figure(Hfig)
    xlabel(xtxt)      
    ylabel(ytxt)
    %saveas(gca,[vtxt, '_RXSE.png'])
    %saveas(Hleg,['legend_', vtxt, '_RXSE.png'])
    
    figure(3)
    legend_fish = {...
        {'o', 8, 3, [0 0 0], [0 0 0]}, 'Agnatha'; ...
        {'o', 8, 3, [1 0 0], [1 0 0]}, 'Chondrichthyes'; ...
        {'o', 8, 3, [0 0 1], [0 0 1]}, 'Actinopterygii'; ...
        {'o', 8, 3, [1 0 1], [0 0 1]}, 'Latimeria'; ....
        {'o', 8, 3, [1 0 1], [1 0 0]}, 'Dipnoi'; ....
        {'o', 8, 3, [1 0 1], [1 0 1]}, 'Amphibia'; ....
    };
    [Hfig Hleg] = shstat([v1, v2], legend_fish, 'fish & amphibia', 3); 
    figure(Hfig)
    xlabel(xtxt)      
    ylabel(ytxt)
    %saveas(gca,[vtxt, '_fish.png'])
    %saveas(Hleg,['legend_', vtxt, '_fish.png'])

    figure(5)
    legend_aves = {...
        {'o', 8, 3, [0 0 0], [0 0 0]}, 'Lepidosauria'; ....
        {'o', 8, 3, [1 0 0], [1 0 0]}, 'Aves'; ....
        {'o', 8, 3, [0 0 1], [0 0 1]}, 'Testudines'; ....
        {'o', 8, 3, [1 0 1], [0 0 1]}, 'Crocodilia'; ....
        {'o', 8, 3, [1 0 1], [1 0 1]}, 'Avemetatarsalia'; ....
    };
    [Hfig Hleg] = shstat([v1, v2], legend_aves, 'sauropsids', 5); 
    figure(Hfig) 
    figure(Hfig)
    xlabel(xtxt)      
    ylabel(ytxt)
    %saveas(gca,[vtxt, '_aves.png'])
    %saveas(Hleg,['legend_', vtxt, '_aves.png'])

    figure(7)
    legend_mamm = {...
       {'o', 8, 3, [0 0 0], [0 0 0]}, 'Prototheria'; ...  
       {'o', 8, 3, [0 0 1], [0 0 0]}, 'Marsupialia'; ...
       {'o', 8, 3, [0 0 1], [0 0 1]}, 'Xenarthra'; ...
       {'o', 8, 3, [0 0 1], [1 0 1]}, 'Afrotheria'; ....
       {'o', 8, 3, [0 0 1], [1 0 0]}, 'Laurasiatheria'; ....
       {'o', 8, 3, [1 0 1], [1 0 1]}, 'Gliriformes'; ....
       {'o', 8, 3, [1 0 1], [1 0 0]}, 'Scandentia'; ....
       {'o', 8, 3, [1 0 0], [1 0 0]}, 'Dermoptera'; ....
       {'o', 8, 3, [1 0 0], [1 .5 .5]}, 'Primates'; ....
    };
    [Hfig Hleg] = shstat([v1, v2], legend_mamm, 'mammals', 7); 
    figure(Hfig)
    xlabel(xtxt)      
    ylabel(ytxt)
    %saveas(gca,[vtxt, '_mamm.png'])
    %saveas(Hleg,['legend_', vtxt, '_mamm.png'])
