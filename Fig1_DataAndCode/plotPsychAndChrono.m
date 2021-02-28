function plotPsychAndChrono(summary)
%
%
% Chand, February 2021

params = summary.params;
figure; set(gcf, 'color', [1 1 1],'units','normalized','position',params.position);

summary.pRed = squeeze(nanmean(summary.rawdata.pRed));
summary.pRedError = squeeze(nanstd(summary.rawdata.pRed))./sqrt(size(summary.rawdata.pRed,1));


summary.RT = squeeze(nanmean(summary.rawdata.RT));
summary.RTe = squeeze(nanstd(summary.rawdata.RT))./sqrt(size(summary.rawdata.pRed,1));


vLabOffset = 10;
width = 0.4;
height = 0.4;

width = 0.4;
pos = [0.05 0.55 width width];
aH = getAxes(pos);
hold on;
axis([-10 110 -10 105]); axis square;
[hAxesParams,vAxesParams] = getAxesP([-100 100],[-100:50:100],params.hAxesOffsetPC,-5,'Signed Coherence (%)',...
    [0 100],[0:50:100],vLabOffset,-105,'Percent Red');
set(gca,'visible','off');

errorbar(summary.signedColorCoherence,summary.pRed,params.CI*summary.pRedError,'o-','color',params.Color, 'linewidth',params.lineWidth,'markersize',params.markerSize, 'MarkerFaceColor',[0.4 0.4 0.4]);

text(40, 0, sprintf('%3.2f(%3.2f)',nanmean(summary.thresholds), nanstd(summary.thresholds)));
text(40, 10, sprintf('%3.2f sessions (%8.0f trials)',length(summary.thresholds), size(summary.combined,1)));

line([1-100 100],[50 50],'color','k','linestyle','--');
line([0 0],[0 100],'color','k','linestyle','--');
axis tight;
setAxes(aH, pos);

text(-100,104,['Monkey:' summary.monkey],'color','k','fontsize',12);


pos = [0.55 0.55 width width];
aH = getAxes(pos);
hold on;
axis([-110 110 min(summary.RT-4*summary.RTe) max(summary.RT + 4*summary.RTe)]); axis square;
set(gca,'visible','off');
vLims = roundn([ceil(min(summary.RT - (3*params.CI)*summary.RTe)), ceil(max(summary.RT+(3*params.CI)*summary.RTe))],1);
T = roundn([linspace(vLims(1),vLims(2),4)],1);
delta = max(diff(T));
vLims(2) = vLims(1) + 3*delta;
vLims = [410 570];
T = roundn([linspace(vLims(1),vLims(2),4)],1);

[hAxesParams,vAxesParams] = getAxesP([-100 100],[-100:50:100],params.hAxesOffsetRT, 400,'Coherence',...
    vLims,T,vLabOffset,-110,'RT (ms)');
axis tight;
errorbar(summary.signedColorCoherence, summary.RT, params.CI*summary.RTe,'o-','color',params.Color, 'linewidth',params.lineWidth,'markersize',params.markerSize, 'MarkerFaceColor',[0.4 0.4 0.4]); hold on;
line([0 0],vLims,'color','k','linestyle','--');
set(gcf, 'DefaultAxesFontName', 'Arial');
setAxes(aH, pos);


function aH = getAxes(pos)
%
%
aH = axes('position',pos);



function setAxes(aH, pos)
%
%
set(aH,'position',pos);
axis square;
set(aH,'visible','off');
axis tight;
box off;
