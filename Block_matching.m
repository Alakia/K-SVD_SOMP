function  [pos_arr,wei_arr]   =  Block_matching(im,L_look,step,basic_estimate,blocknum)
% global blocksize;
blocksize = 8;
S         =   19; %��������İ뾶��
f         =   blocksize; %patch�ı߳���
alpha     =   0.88;
hp        = quantile_nakagami(L_look, blocksize, alpha) .* blocksize.^2;
s         =   2;%�ο��鲽��
% if L_look <=2
par.nblk  =   blocknum;%ÿ�������������ƿ�ĸ��� sigma>40ʱ par.nblk = 32
% else
%     par.nblk = blocknum/2;
% end
N         =   size(im,1)-f+1; %��Ϊ��patch�����Ͻ���Ϊ�ο��㣬��Ҫ��ֹ����patch�����߽磻
M         =   size(im,2)-f+1;
r         =   [1:s:N];
r         =   [r r(end)+1:N];
c         =   [1:s:M];
c         =   [c c(end)+1:M];
L         =   N*M; %ͼ��506*506�������ص�������
X         =   zeros(f*f, L, 'single');
basic_X   =   zeros(f*f, L, 'single');

k    =  0;
for i  = 1:f
    for j  = 1:f
        k    =  k+1;
        blk  =  im(i:end-f+i,j:end-f+j);
        X(k,:) =  blk(:)'; %ÿһ�о���һ��506*506��ͼ��
    end
end%��һ���ֲ�����⣬�����㷨��˼�룬X��������ȡÿ�����ص�������Ӧ��Patch
k    =  0;
for i  = 1:f
    for j  = 1:f
        k    =  k+1;
        blk  =  basic_estimate(i:end-f+i,j:end-f+j);
        basic_X(k,:) =  blk(:)'; %ÿһ�о���һ��506*506��ͼ��
    end
end
% Index image
I     =   (1:L); 
I     =   reshape(I, N, M); %Ŀ���Ǹ�506*506��ͼ���е�ÿһ������һ��������
N1    =   length(r);
M1    =   length(c);
pos_arr   =  zeros(par.nblk, N1*M1 ); %N1*M1Ӧ��Ϊ���Ƽ��ϵ���Ŀ,par.nblkΪ���Ƽ��ϵ������ƿ����Ŀ��
wei_arr   =  zeros(par.nblk, N1*M1 );
X         =  X'; %ÿһ�о���һ��506*506��ͼ��
basic_X   =  basic_X';

for  i  =  1 : N1               %N1*M1Ӧ�������Ƽ��ϵ���Ŀ������������ͼ��ÿ��step������ȡһ��patch��Ϊ���Ƽ��ϵ����ģ�
    for  j  =  1 : M1
        
        row     =   r(i);       %���Ƽ��ϵ�����patch��top-leftԪ�����ڵ��У�
        col     =   c(j);       %��ǰ���Ƽ�������patch��top-leftԪ�����ڵ��У�
        off     =  (col-1)*N + row;  %��ǰ���Ƽ�������patch��top-leftԪ����ͼ��506*506�����д洢�µ�������
        off1    =  (j-1)*N1 + i;     %��������Ŀ�Ŀ�������ͼ������ͬһ����patchΪ���ĵ����Ƽ�����pos_arr�д������ڵ��У�
                                     %��ÿһ�����Ƽ��Ͽ���һ��Ԫ�أ������Ƽ����γ�һ��N1*M1��86*86���ľ����Ҵ洢��ʽ�ǰ�����ģ�
        rmin    =   max( row-S, 1 );
        rmax    =   min( row+S, N );
        cmin    =   max( col-S, 1 );
        cmax    =   min( col+S, M ); %ȷ���˵�ǰ���Ƽ��ϵ���������
         
        idx     =   I(rmin:rmax, cmin:cmax); %�ҵ���ǰ���Ƽ��ϵ����������ڵ�����Ԫ�ص�������
        idx     =   idx(:);
        % PPB �����Զ���
        B       =   X(idx, :);
        v       =   X(off, :);
        vm      =   repmat(v,length(idx),1);
        A       =   log(B./vm+vm./B);
        
        A(abs(A)<=0)=min(min(A(abs(A)>0)));
        A(isnan(abs(A)))=min(min(A(abs(A)>0)));
                
        if(step == 1)
            dis              =   (2*L_look-1)*sum(A,2);
            [val,ind]        =  sort(dis);
            dis(ind(1))      =  dis(ind(2));
            pos_arr(:,off1)  =  idx( ind(1:par.nblk) ); %�����ʵ������patch��top_leftԪ�ص�������
            wei              =  exp( -dis(ind(1:par.nblk))./hp );
            wei              =  wei./(sum(wei)+eps);
            wei_arr(:,off1)  =  wei;
        else
            B2      =   basic_X(idx, :);
            v2      =   basic_X(off, :);
            vm2     =   repmat(v2,length(idx),1);
            addtion =   ((vm2-B2).^2)./(vm2.*B2);
            dis     =   (2*L_look-1)*sum(A,2) + L_look*sum(addtion,2);
            [val,ind]   =  sort(dis);
            pos_arr(:,off1)  =  idx( ind(1:par.nblk) ); %�����ʵ������patch��top_leftԪ�ص�������
        end
    end
end
end