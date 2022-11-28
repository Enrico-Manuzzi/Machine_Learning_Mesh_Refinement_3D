function plot_meshes(meshes,boom,row_names,col_names,my_title)
[R,C] = size(meshes);
if nargin < 2
    boom = false;
end
if length(boom)==1
    boom = boom | false([R C]);
end

tiledlayout(R,C, 'Padding', 'tight', 'TileSpacing', 'tight');

for i = 1:R
    for j = 1:C
        id = (i-1)*C+j;
        nexttile(id)
        if boom(i,j)
            explode(meshes{i,j})
        else
            plot(meshes{i,j})
        end
    end
end

if nargin > 2
    font = 11;    
    for i = 1:C
        nexttile(i)
        title(col_names{i},'fontweight','bold','fontsize',font)
    end
    for i = 1:R
        nexttile((i-1)*C+1);
        ax = gca;
        ax.ZLabel.Visible = 'on';
        zlabel(row_names{i},'fontweight','bold','fontsize',font)
    end
end

if nargin == 5
    sgtitle([my_title,""],'fontweight','bold','fontsize',font+2)
end
% f = gcf;
% f.WindowState = 'maximized';