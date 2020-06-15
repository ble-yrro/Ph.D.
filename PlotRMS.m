function PlotRMS(RMS)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  FONCTION POUR VISUALISER LE RMS                                        %                                                                 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
RMS=RMS';

[xRMS yRMS]=size(RMS);
    plot(1:yRMS,RMS,'-','Linewidth',2)
    ylabel('RMS (%)')
    xlim([0 yRMS])
    ylim([0 max(RMS)+1])
    grid on; %set(gca,'xtick',0:2:yRMS,'ytick',0:0.1:max(RMS)+1,'Layer','top')
end