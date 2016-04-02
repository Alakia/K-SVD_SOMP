function [a,indx]=omp_single(D,x,errorGoal)
     

	 indx = [];
	 a = [];
     j = 0;
     
      n=length(x);
      maxNumCoef=n/2;
      E2=n*(errorGoal^2);
      
     residual=x;
	 currResNorm2 = sum(residual.^2);
	
    
    while currResNorm2>E2 && j < maxNumCoef,
		j = j+1;
        %�ҳ��в����ֵ���ĸ����ϵ�ϵ�����
        proj=D'*residual;
        pos=find(abs(proj)==max(abs(proj)));
        pos=pos(1);
        %��������ӽ�������ʾx������
        indx(j)=pos;
        
        %�������Щ�ֱ�ʾx��ϵ���Ͳв�
        a=pinv(D(:,indx(1:j)))*x;
        residual=x-D(:,indx(1:j))*a;
		currResNorm2 = sum(residual.^2);
    end
 
    
    %�����ֵ���������ʾx�����ǵ��б�Ͷ�Ӧ��ϵ��
end