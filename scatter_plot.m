function scatter_plot(res,metric)
vec = [];
for fold=1:5
    vec = [vec; res{1,fold}];
end
Data{1} = vec;

vec = [];
for fold=1:5
    vec = [vec; res{2,fold}];
end
Data{2} = vec;


group =[];
for i=1:length(Data)
    group = [group; i*ones(size(Data{i}))];
end
figure;
hold on
h = boxplot(cell2mat(Data),group); 
xCenter = 1:numel(Data); 
spread = 0.7; % 0=no spread; 0.5=random spread within box bounds (can be any value)
for i = 1:numel(Data)
    s = scatter(rand(size(Data{i}))*spread -(spread/2) + xCenter(i), Data{i},'filled','SizeData',1);
    alpha(s,.5)
end
ylabel(metric, 'fontsize', 20);
color = get(gca,'ColorOrder');
mymap = color(1:length(Data),:);
colormap(mymap);
set(h, 'linewidth' ,1.5)
set(gca,'XTickLabel', {'FIST';  'Spatial-NN'},'fontsize', 15);    
hold off;

grid on;
box on;

end