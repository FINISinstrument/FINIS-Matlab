function showVideo(cube, endAt)
% 
global video;
global v;
clims = [0, 1];
for i = 1:endAt-1
   imagesc(cube(:,:,i,1), clims),colormap('gray')
   grid on
   title(['Frame: ', num2str(i)])
   frame = getframe(gcf);
   if (video == 1)
      writeVideo(v,frame)
   end
end