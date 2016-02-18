function [ubm_results,error_ubm]=populateUBMfolder(folder_name,workers,full,varargin)

% hard set iterations at 10 and ds_factor at 1
iterations = 10;
ds_factor = 1;

% user can specify or there is a default
if ( nargin == 4 )
    mixtures = varargin{1};
else
    mixtures = [2,4,8,16,32,64,128,256];
end
mixture_count = numel(mixtures);

% gather train files
train_files = findDirectoryMatch('train',folder_name);
test_files = findDirectoryMatch('test',folder_name);
if(  isempty(train_files) )
    train_files = findDirectoryMatch('data_',folder_name);
end
if( isempty(test_files) )
    test_files = train_files;
end
train_count = numel(train_files);

% setup variables
error_ubm = zeros(train_count,mixture_count);
ubm_results = cell(train_count,mixture_count);

for k=1:train_count
    input_file = [folder_name,'/',train_files{k}];
    test_file = [folder_name,'/',test_files{k}];
    for i=1:mixture_count
        if( full == 1 )
        [ubm_results{k,i}, error_ubm(k,i)]=makeUBM(folder_name,...
            input_file, test_file, mixtures(i), iterations, ds_factor, workers);
        else
            ubm_results{k,i} = makeUBMonly(folder_name, input_file,...
                mixtures(i), iterations, ds_factor, workers);
        end
    end
end

save( [folder_name,'/','ubm_structs.mat'], 'ubm_results');
if( full ~= 0 )
    save( [folder_name,'/','ubm_errors.mat'], 'error_ubm');
end
end