a = 0;
b = 255;
row=50;
column=50;
r = uint8(a + (b-a).*rand(row,column));
r_reshaped=reshape(transpose(r),[row*column,1]);
r_fp=fi(r_reshaped,0,12,0);
r_bin=r_fp.bin;
dlmwrite('input_image.mem',r_bin,'delimiter','');
% fileID = fopen('input_image.txt','w');
% fwrite(fileID,r_reshaped);
% fclose(fileID);
f= [0 0 0 0 0;
    0 1 2 1 0;
    0 0 0 0 0;
    0 -1 -2 -1 0;
    0 0 0 0 0;];
c=filter2(r,f,'same')


