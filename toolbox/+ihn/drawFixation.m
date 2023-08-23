function drawFixation(window, color)
windowHeight = window.rectangle(4);
armLength = 2 * windowHeight / 100;
coordinates = armLength * [-1, 1, 0, 0; 0, 0, -1, 1];
widthPixels = 3;
coordinateOrigin = window.rectangle(3:4)/2;
Screen('DrawLines', window.pointer, coordinates, widthPixels, color, coordinateOrigin);
end
