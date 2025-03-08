clc; clear all;
addpath('../');

standard_size = [768,1024];

att = 'train';

dataset_name = 'DroneCrowd';
path = ['/Data/DroneCrowd/' att '_data/images/'];
output_path = '/Data/DroneCrowd/ProcessedData/';
train_path_img = strcat(output_path, dataset_name, '/', att, '/img/');
train_path_den = strcat(output_path, dataset_name, '/', att, '/den/');

gt_path = ['/Data/DroneCrowd/' att '_data/ground_truth/'];

mkdir(output_path);
mkdir(train_path_img);
mkdir(train_path_den);

image_files = dir(fullfile(path, 'img*.jpg'));
num_images = length(image_files);

for idx = 1:num_images
    if mod(idx, 10) == 0
        fprintf(1, 'Processing %3d/%d files\n', idx, num_images);
    end
    
    img_name = image_files(idx).name; % ex: 'img001001.jpg'
    img_basename = img_name(1:end-4); % Enlever ".jpg"

    input_img_name = fullfile(path, img_name);
    im = imread(input_img_name);  
    [h, w, c] = size(im);

    gt_file = fullfile(gt_path, ['GT_' img_basename '.mat']);
    if exist(gt_file, 'file')
        load(gt_file); 
    else
        fprintf('Warning: Ground truth file missing for %s\n', img_name);
        continue;
    end

    annPoints = image_info{1}.location;

    rate_h = standard_size(1) / h;
    rate_w = standard_size(2) / w;
    im = imresize(im, [standard_size(1), standard_size(2)]);
    annPoints(:,1) = annPoints(:,1) * rate_w;
    annPoints(:,2) = annPoints(:,2) * rate_h;

    im_density = get_density_map_gaussian(im, annPoints, 15, 4); 
    im_density = im_density(:,:,1);
    
    imwrite(im, fullfile(train_path_img, [img_basename '.jpg']));
    csvwrite(fullfile(train_path_den, [img_basename '.csv']), im_density);
end
