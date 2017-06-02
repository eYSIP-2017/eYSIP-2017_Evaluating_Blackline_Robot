%% Read Video File
function [movie, height, width, frameRate, numOfFrame] = readVideo(file)

movie = mmread(file);
width = movie.width;
height = movie.height;
frameRate = movie.rate;
numOfFrame = movie.nrFramesTotal;

end