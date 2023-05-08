nb = length(Pdata(:,1));% number of buses
nbrc = length(Zcopy(:,1));% number of branches
delP = (Pdata(:,3) - Pdata(:,2))/100;
delP(1)=[];% originally contained even delP associated with slack bus, so make it NULL
Xmat = zeros(nb,nb);
for k=1:nbrc
    sb = Zcopy(k,1);
    eb = Zcopy(k,2);
    x = Zcopy(k,3);
    Xmat(sb,eb) =  -(1/x);
    Xmat(eb,sb) = -(1/x);
    Xmat(sb,sb) = Xmat(sb,sb) + (1/x);
    Xmat(eb,eb) = Xmat(eb,eb) + (1/x);
end
Xmat(:,1)=[];
Xmat(1,:)=[];
B = Xmat;
inv(B);
Ang = inv(B)*delP;
Ang = [0;Ang];
Pflow = [];
for k = 1: nbrc
    sb = Zcopy(k,1);
    eb = Zcopy(k,2);
    x = Zcopy(k,3);
    bflow=((Ang(sb)-Ang(eb))/x)*100;
    Pflow = [Pflow;sb eb bflow];
end
Pflow