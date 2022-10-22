 N = 150;
  m = [1-logspace(0,log(eps),N-1), 1]; # m near 1
  m = [0, logspace(log(eps),0,N-1)];   # m near 0
   m = linspace (0,1,N);                # m equally spaced
 u = linspace (-20, 20, N);
  M = ones (length (u), 1) * m;
  U = u' * ones (1, length (m));
  [sn, cn, dn] = ellipj (U,M);

 ## Plotting
 data = {sn,cn,dn};
 dname = {"sn","cn","dn"};
 for i=1:3
   subplot (1,3,i);
    data{i}(data{i} > 1) = 1;
    data{i}(data{i} < -1) = -1;
    image (m,u,32*data{i}+32);
    title (dname{i});
  endfor
  colormap (hot (64));
 