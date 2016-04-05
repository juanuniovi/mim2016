for t=1:length(validos),
  x07=expm(A*0.7)*validos(t,:)';
  y07=sign(c*x07);
  if (y07 == 1) positivos=positivos+1; end 
  if (y07 == -1) negativos=negativos+1; end 
  if (y07 == 0) ceros=ceros+1; end 
end 