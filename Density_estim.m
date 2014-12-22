function q = Density_estim(T,Lmap,k,H,W,graph)
q = zeros(Lmap,1);
colour = linspace(1,Lmap,Lmap);
for x=1:W
    for y=1:H 
        q(T(y,x)+1) = q(T(y,x)+1)+k(y,x);
    end
end

% πÈ“ªªØ
C = 1/sum(sum(k));
q = C.*q;

if graph==1
    figure
    plot(colour,q);
end