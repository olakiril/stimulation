function out = getPerm(c0, n)
% ensures the correct randomization such that in a 4x4 (imNum x statistical variant) Block there is only one variant in each direction
% LG 07/23/13

A = c0(1);
B = c0(2);
C = c0(3);
D = c0(4);

% 9 compatible columns
c1 = [B A D C];
c2 = [B C D A];
c3 = [B D A C];
c4 = [C A D B];
c5 = [C D A B];
c6 = [C D B A];
c7 = [D A B C];
c8 = [D C A B];
c9 = [D C B A];

%24 compatible combinations of columns 6 x 4
comb(1).struct = [c0; c1; c5; c9];
comb(2).struct = comb(1).struct(:,[1 4 2 3]);
comb(3).struct = comb(1).struct(:,[1 3 4 2]);
comb(4).struct = comb(1).struct(:,[1 2 4 3]);
comb(5).struct = comb(1).struct(:,[1 3 2 4]);
comb(6).struct = comb(1).struct(:,[1 4 3 2]);

comb(7).struct = [c0; c1; c6; c8];
comb(8).struct = comb(7).struct(:,[1 4 2 3]);
comb(9).struct = comb(7).struct(:,[1 3 4 2]);
comb(10).struct = comb(7).struct(:,[1 2 4 3]);
comb(11).struct = comb(7).struct(:,[1 3 2 4]);
comb(12).struct = comb(7).struct(:,[1 4 3 2]);

comb(13).struct = [c0; c2; c5; c7];
comb(14).struct = comb(13).struct(:,[1 4 2 3]);
comb(15).struct = comb(13).struct(:,[1 3 4 2]);
comb(16).struct = comb(13).struct(:,[1 2 4 3]);
comb(17).struct = comb(13).struct(:,[1 3 2 4]);
comb(18).struct = comb(13).struct(:,[1 4 3 2]);

comb(19).struct = [c0; c3; c4; c9];
comb(20).struct = comb(19).struct(:,[1 4 2 3]);
comb(21).struct = comb(19).struct(:,[1 3 4 2]);
comb(22).struct = comb(19).struct(:,[1 2 4 3]);
comb(23).struct = comb(19).struct(:,[1 3 2 4]);
comb(24).struct = comb(19).struct(:,[1 4 3 2]);

out = comb(n).struct;
end