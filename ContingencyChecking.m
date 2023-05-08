clc
clear  % B_no Pd Pg
%since bus one is slack, both pd and pg are considered 0
Pdata = [ 1, 0, 0;
    	 2,100,0;
         3,0,75;
         4,130, 0;];
        %sb eb, x
Zdata = [1,3,0.1;
         1,4,0.5;
         3,4,0.2;
         3,2,0.4;
         2,4,0.3;];
nb = length(Pdata(:,1));% number of buses
nbrc = length(Zdata(:,1));% number of branches
delP = (Pdata(:,3) - Pdata(:,2))/100;
delP(1)=[];% originally contained even delP associated with slack bus, so make it NULL
Xmat = zeros(nb,nb);
for k=1:nbrc
    sb = Zdata(k,1);
    eb = Zdata(k,2);
    x = Zdata(k,3);
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
    sb = Zdata(k,1);
    eb = Zdata(k,2);
    x = Zdata(k,3);
    bflow=((Ang(sb)-Ang(eb))/x)*100;
    Pflow = [Pflow;sb eb bflow];
end
Pflow
%till above lines was determining the load flow using DC load flow
 for check = 1:length(Zdata)
     Zcopy = Zdata;
     printstatement = sprintf("\nline %d-%d failure",Zcopy(check,1),Zcopy(check,2));
     disp(printstatement);
     Zcopy(check,:)=[];
     LoadFlow 
     PerfIndex = sum(abs(Pflow(:,3)./100))
     if PerfIndex<length(Zcopy)
         disp("Normal contingency")
     elseif PerfIndex==length(Zcopy)
         disp("Critical contingency")
     else
         disp("Security contingency")
     end
     for i = 1:length(Pflow)
     if Pflow(i,3)>100
         printstatement = sprintf("line %d-%d overloaded",Pflow(i,1),Pflow(i,2));
         disp(printstatement);
     end
     end
 end






