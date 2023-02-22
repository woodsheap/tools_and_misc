#!/usr/bin/octave
% SPDX-FileCopyrightText: 2023 Brian Woods
% SPDX-License-Identifier: GPL-2.0-or-later

files = {'lossless_z_images/PNG_01-z_VAR.webp', ...
         'lossless_z_images/PNG_02-z_VAR.webp', ...
         'lossless_z_images/PNG_03-z_VAR.webp', ...
         'lossless_z_images/PNG_04-z_VAR.webp'};
var_values = 0:1:9;
files_len = length(files);
var_values_len = length(var_values);
results = zeros(files_len, var_values_len);

for i = 1:files_len
	for j = 1:var_values_len;
		filepath = strrep(files{i}, 'VAR', num2str(var_values(j), "%d"));
		[file, ~,  ~] = stat(filepath);
		results(i,j) = file.size;
	end
end

% normalize
for i = 1:files_len
	results(i,:) = results(i,:)/max(results(i,:));
end

f = figure('visible','off');
plot(var_values, results(1,:),"b-");
hold on;
plot(var_values, results(2,:), "g-");
plot(var_values, results(3,:), "r-");
plot(var_values, results(4,:), "c-");
xlabel ("z compression level");
ylabel ("normalized file size");
legend ("PNG 01", "PNG 02", "PNG 03", "PNG 04");
print('lossless_z_graph.png');
