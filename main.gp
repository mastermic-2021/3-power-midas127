encodegln(s,n)={
  my(v);
  v=[if(x==32,0,x-96)|x<-Vec(Vecsmall(s))];
  if(#v>n^2,warning("string truncated to length ",n^2));
  v = Vec(v,n^2);
  return(matrix(n,n,i,j,v[(i-1)*n+j]));
}

entree=readstr("input.txt")[1];

M = encodegln(entree, 12);

ordre(a) = {
	n = 1;
	A = M;
	Id = matid(12);
	while(A!=Id, t = M*A; A = Mod(t, 27); n = n+1;);
	return(n);
}

ascii2str(v)=Strchr(v);
decode(v) = {
  ascii2str([ if(c==0,32,c+96) | c <- v]);
}

k=ordre(M);

\\On calcule d'abord l'ordre de la matrice M

p = eulerphi(k);

\\print(p);

inverse = bezout(65537, k)[1]; \\ on calcule une relation de Bezout

\\Avec q=65537,  M = A^q et la relation de Bezout uk+vq = 1, on obtient A = A^1 = A^(uk+vq) = A^uk * A^vq = Id * M^v, avec A^k = Id car l'ordre de A est surement premier avec q mais pas avec k=ord(M)

\\print(inverse);

expomatricielle(a, n) = { \\exponentielle matricielle, pas besoin d'exponentielle rapide
	r = matid(12);
	for(i=1, n, t = r*a; r = Mod(t, 27););
	return(r);
}

Sol = lift(expomatricielle(M, inverse));

\\print(Sol);

decodegln(M)={
  v= Vec( concat(Vec(M~))~, (matsize(M)[1])*(matsize(M)[1]) - 1);
  return(v);
}

message = decodegln(Sol);

clair = decode(message);

\\print(message);

print(clair);
