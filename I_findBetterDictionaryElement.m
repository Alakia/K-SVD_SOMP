function [betterDictionaryElement,CoefMatrix] = I_findBetterDictionaryElement(Data,Dictionary,BETA,j,CoefMatrix,DA2,Residual)

%�ҳ������ֵ��еĸ��б����Ǽ�������
relevantDataIndices = find(CoefMatrix(j,:));
if (length(relevantDataIndices)<1)
    ERR=BETA.*(Data-Dictionary*CoefMatrix);
    sumerr=sum(ERR.^2);
    [indx]=find(sumerr==max(sumerr));
    pos=indx(1);
    betterDictionaryElement=(Data(:,pos)./BETA(:,pos))/norm((Data(:,pos)./BETA(:,pos)));
    
%      betterDictionaryElement=(Dictionary(:,j));

     CoefMatrix(j,:) = 0;

    return;
end


%�õ��⼸�����ݶ�Ӧ����Ӧ�ֵ��и��е�ϵ��
% tmpCoefMatrix = CoefMatrix(:,relevantDataIndices); 
% 
% %�����ȥ���⼸�����ݵı���еĸ��еĳɷֺ��⼸�����������ǵı��֮������
% tmpCoefMatrix(j,:) = 0;
% Error =(Data(:,relevantDataIndices) - Dictionary*tmpCoefMatrix); 
% Error=imfilter(Error,ones(1,18)/9,'symmetric');
% denoise_blk= blkfirstsdenoise(:,relevantDataIndices)-Dictionary*tmpCoefMatrix;
Error= Residual(:,relevantDataIndices)+Dictionary(:,j)* CoefMatrix(j,relevantDataIndices); 
%���µĸ��У�ʹ����ڼ�ȥ���еı�����С���������Ӧ��ϵ����
% tmpBETA=BETA(:,relevantDataIndices);
% Error= DA2(:,relevantDataIndices)+Dictionary(:,j)* CoefMatrix(j,relevantDataIndices);
[u,s,v]=svds(Error,1);
%%%%%%%%%%%%%%%%%%%%%%%%%%%����
% [IDX C]=kmeans(denoise_blk',3);
%%%%%%%%%%%%%%%%%%%%%%%%%%%
% idx1= IDX==1;
% idx2= IDX==2;
% idx3= IDX==3;
% de1=denoise_blk(:,idx1);
% de2=denoise_blk(:,idx2);
% de3=denoise_blk(:,idx3);
% [u1,s1,v1]=svds(de1,1);
% [u2,s2,v2]=svds(de2,1);
% [u3,s3,v3]=svds(de3,1);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%555
betterDictionaryElement=u;
          betaVector=s*v;
% a=CoefMatrix(j,relevantDataIndices) ;
% [betterDictionaryElement,betaVector]=weirank(tmpBETA,errors,errorGoal,DCT);

%����ϵ������
CoefMatrix(j,relevantDataIndices) =betaVector';% *signOfFirstElem
% disp(j)
end    
