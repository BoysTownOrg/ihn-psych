function x = generateRandomIntegers(lowerLimit, upperLimit, count)
stream = RandStream("mt19937ar", "Seed", 'shuffle');
x = stream.randi([lowerLimit, upperLimit], [1, count]);
end
