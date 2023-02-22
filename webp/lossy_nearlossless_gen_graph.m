#!/usr/bin/octave
% SPDX-FileCopyrightText: 2023 Brian Woods
% SPDX-License-Identifier: GPL-2.0-or-later

graph_file = 'lossy_nearlossless_graph.png';
img_dir = 'lossy_nearlossless_images/';
varname = "nl";
var_values = {'000', '010', '020', '030', ...
              '040', '050', '060', '070', ...
              '080', '090', '100'};

files = {strrep(strcat(img_dir, 'PNG_01-VARN_VAR.webp'), 'VARN', varname), ...
         strrep(strcat(img_dir, 'PNG_02-VARN_VAR.webp'), 'VARN', varname), ...
         strrep(strcat(img_dir, 'PNG_03-VARN_VAR.webp'), 'VARN', varname), ...
         strrep(strcat(img_dir, 'PNG_04-VARN_VAR.webp'), 'VARN', varname)};
files_len = length(files);
var_values_len = length(var_values);
results = zeros(files_len, var_values_len);

for i = 1:files_len
	for j = 1:var_values_len;
		filepath = strrep(files{i}, 'VAR', var_values{j});
		[file, ~,  ~] = stat(filepath);
		results(i,j) = file.size;
	end
end

% normalize
for i = 1:files_len
	results(i,:) = results(i,:)/max(results(i,:));
end

var_values_idx = str2double(var_values);
f = figure('visible','off');
plot(var_values_idx, results(1,:),"b-");
hold on;
plot(var_values_idx, results(2,:), "g-");
plot(var_values_idx, results(3,:), "r-");
plot(var_values_idx, results(4,:), "c-");
xlabel ("near lossless preprocessing (0 is more visual compression)");
ylabel ("normalized file size");
h = legend ("PNG 01", "PNG 02", "PNG 03", "PNG 04");
legend(h, "location", "northeastoutside");
print(graph_file);
