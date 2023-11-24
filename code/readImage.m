function img = readImage(path, S)

if isfolder(path)
    FileList = natsortfiles(dir(fullfile(path, '*.png')));
    numOfSlices = length(FileList);
    firstFile = fullfile(FileList(1).folder, FileList(1).name);
    thisSlice = imread(firstFile);
    array3d = zeros(size(thisSlice,1), size(thisSlice,2), numOfSlices);

    for slice = 2 : numOfSlices
        File = fullfile(FileList(slice).folder, FileList(slice).name);
        thisSlice = imread(File);
        array3d(:,:,slice) = thisSlice;
    end

    mask = false(size(array3d));
    pixIndex = array3d > 0;
    mask(pixIndex) = 1;
    
elseif endsWith(path, '.im')
    fid = fopen(path,'r');
    status = fseek(fid, 1024, 'bof');
    mask = fread(fid);
    fclose(fid);
    mask = reshape(mask,S,S,S);

elseif endsWith(path, '.stl')
    TR = stlread(path);
    FV.vertices = TR.Points;
    FV.faces = TR.ConnectivityList;
    meshXmin = min(FV.vertices(:,1));
    meshXmax = max(FV.vertices(:,1));
    meshYmin = min(FV.vertices(:,2));
    meshYmax = max(FV.vertices(:,2));
    meshZmin = min(FV.vertices(:,3));
    meshZmax = max(FV.vertices(:,3));
    meshmin = min([meshXmin, meshYmin, meshZmin]);
    meshmax = max([meshXmax, meshYmax, meshZmax]);
    gridX = linspace(floor(meshmin), ceil(meshmax), S);
    gridY = linspace(floor(meshmin), ceil(meshmax), S);
    gridZ = linspace(floor(meshmin), ceil(meshmax), S);
    [mask,~,~,~] = VOXELISE(gridX, gridY, gridZ, FV, 'xyz');
    
else
    error('Sorry, your file type is not supported.')
end

mask = double(mask);

if S <= 1
    error('Incorrect value of the size.')
end

if mod(S,2)==1
    S = S-1;  % S is an even number
end

if any(size(mask) ~=S )
    resizeScale = S / max([size(mask,1), size(mask,2), size(mask,3)]);
    scaledMask = imresize3(mask, resizeScale);
    img = zeros(S, S, S);
    img(1:size(scaledMask,1), 1:size(scaledMask,2), 1:size(scaledMask,3)) = scaledMask;
else
    img = mask;
end