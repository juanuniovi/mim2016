for y0=-10:0.1:10,
  for x0=-10:0.1:10,
    x04=expm(A*0.4)*[x0;y0];
    y04=sign(c*x04);
    x12=expm(A*1.2)*[x0;y0];
    y12=sign(c*x12);
    x38=expm(A*3.8)*[x0;y0];
    y38=sign(c*x38);
    if ((y04 == 1) & (y12 == -1) & (y38 == 1))
      plot(x0,y0);              
      validos(n,:)=[x0 y0];    
      n=n+1;                    
    end
  end
end

