function varargout = main(varargin)
% MAIN MATLAB code for main.fig
%      MAIN, by itself, creates a new MAIN or raises the existing
%      singleton*.
%
%      H = MAIN returns the handle to a new MAIN or the handle to
%      the existing singleton*.
%
%      MAIN('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in MAIN.M with the given input arguments.
%
%      MAIN('Property','Value',...) creates a new MAIN or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before main_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to main_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help main

% Last Modified by GUIDE v2.5 16-Mar-2021 18:57:20

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @main_OpeningFcn, ...
                   'gui_OutputFcn',  @main_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT


% --- Executes just before main is made visible.
function main_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to main (see VARARGIN)

% Choose default command line output for main
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes main wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = main_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in btnPilihCitra.
function btnPilihCitra_Callback(hObject, eventdata, handles)
% hObject    handle to btnPilihCitra (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in pushbutton2.
function pushbutton2_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in pushbutton4.
function pushbutton4_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
Img_bw = handles.Img_bw;
Img = handles.Img;
stats = regionprops(Img_bw,'Area','Perimeter','Eccentricity');
area = stats.Area;
perimeter = stats.Perimeter;
metric = 4*pi*area/(perimeter^2);
eccentricity = stats.Eccentricity;
 
ciri_bentuk = cell(2,2);
ciri_bentuk{1,1} = 'Metric';
ciri_bentuk{2,1} = 'Eccentricity';
ciri_bentuk{1,2} = num2str(metric);
ciri_bentuk{2,2} = num2str(eccentricity);
 
Img_gray = rgb2gray(Img);
Img_gray(~Img_bw) = 0;

pixel_dist = 1;
GLCM = graycomatrix(Img_gray,'Offset',[0 pixel_dist; -pixel_dist pixel_dist; -pixel_dist 0; -pixel_dist -pixel_dist]);
stats = graycoprops(GLCM,{'contrast','correlation','energy','homogeneity'});
Contrast = mean(stats.Contrast);
Correlation = mean(stats.Correlation);
Energy = mean(stats.Energy);
Homogeneity = mean(stats.Homogeneity);
 
ciri_total = cell(6,2);
ciri_total{1,1} = ciri_bentuk{1,1};
ciri_total{1,2} = ciri_bentuk{1,2};
ciri_total{2,1} = ciri_bentuk{2,1};
ciri_total{2,2} = ciri_bentuk{2,2};
ciri_total{3,1} = 'Contrast';
ciri_total{4,1} = 'Correlation';
ciri_total{5,1} = 'Energy';
ciri_total{6,1} = 'Homogeneity';
ciri_total{3,2} = num2str(Contrast);
ciri_total{4,2} = num2str(Correlation);
ciri_total{5,2} = num2str(Energy);
ciri_total{6,2} = num2str(Homogeneity);


load ciri_database

ciri = zeros(1,6);
for i = 1:6
    ciri(i) = str2double(ciri_total{i,2});
end
 
[num,~] = size(ciri_database);
 
dist = zeros(1,num);
for n = 1:num
    data_base = ciri_database(n,:);
    jarak = sum((data_base-ciri).^2).^0.5;
    dist(n) = jarak;
end
 
[~,id] = min(dist);
 
if isempty(id)
    set(handles.txtHasil,'String', 'Unknown')
else
    disp(id);
    if id < 64
        set(handles.txtHasil,'String', 'Sukkari')
    elseif id > 64 && id < 74
        set(handles.txtHasil,'String', 'Tunisia')
    elseif id > 74 && id < 250
        set(handles.txtHasil,'String', 'Ajwa')
    end
    
end

% --- Executes on button press in pushbutton3.
function pushbutton3_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[filename,pathname] = uigetfile('*.jpg');
 
if ~isequal(filename,0)
    Img = imread(fullfile(pathname,filename));
    axes(handles.axCitraInput)
    imshow(Img)
    title('Citra RGB')
else
    return
end
 
handles.Img = Img;
guidata(hObject, handles)


% --- Executes on button press in pushbutton6.
function pushbutton6_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
Img = handles.Img;
 
% Color-Based Segmentation Using K-Means Clustering
cform = makecform('srgb2lab');
lab = applycform(Img,cform);
axes(handles.axCitraGrayscale)
imshow(lab)
title('Citra Preprocessing');
 
% -------------------- 2 
ab = double(lab(:,:,2:3));
nrows = size(ab,1);
ncols = size(ab,2);
ab = reshape(ab,nrows*ncols,2);
 
nColors = 2;
[cluster_idx, ~] = kmeans(ab,nColors,'distance','sqEuclidean', ...
    'Replicates',3);
 
pixel_labels = reshape(cluster_idx,nrows,ncols);
 
segmented_images = cell(1,3);
rgb_label = repmat(pixel_labels,[1 1 3]);
 
for k = 1:nColors
    color = Img;
    color(rgb_label ~= k) = 0;
    segmented_images{k} = color;
end
 
area_cluster1 = sum(find(pixel_labels==1));
area_cluster2 = sum(find(pixel_labels==2));
 
[~,cluster_min] = min([area_cluster1,area_cluster2]);
 
Img_bw = (pixel_labels==cluster_min);
Img_bw = imfill(Img_bw,'holes');
Img_bw = bwareaopen(Img_bw,50);
 
tomat = Img;
R = tomat(:,:,1);
G = tomat(:,:,2);
B = tomat(:,:,3);
R(~Img_bw) = 0;
G(~Img_bw) = 0;
B(~Img_bw) = 0;
tomat_rgb = cat(3,R,G,B);
axes(handles.axCitraSegmentasi)
imshow(tomat_rgb)
title('Citra Hasil Segmentasi LBP');
handles.Img_bw = Img_bw;
guidata(hObject, handles);
