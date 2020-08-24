function varargout = window(varargin)
% WINDOW MATLAB code for window.fig
%      WINDOW, by itself, creates a new WINDOW or raises the existing
%      singleton*.
%
%      H = WINDOW returns the handle to a new WINDOW or the handle to
%      the existing singleton*.
%
%      WINDOW('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in WINDOW.M with the given input arguments.
%
%      WINDOW('Property','Value',...) creates a new WINDOW or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before window_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to window_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help window

% Last Modified by GUIDE v2.5 30-Oct-2019 20:21:15

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @window_OpeningFcn, ...
                   'gui_OutputFcn',  @window_OutputFcn, ...
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


% --- Executes just before window is made visible.
function window_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to window (see VARARGIN)

% Choose default command line output for window
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes window wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = window_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;



function movname_Callback(hObject, eventdata, handles)
% hObject    handle to movname (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of movname as text
%        str2double(get(hObject,'String')) returns contents of movname as a double


% --- Executes during object creation, after setting all properties.
function movname_CreateFcn(hObject, eventdata, handles)
% hObject    handle to movname (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in loadmov.
function loadmov_Callback(hObject, eventdata, handles)
% hObject    handle to loadmov (see GCBO)
%data_1_str=get(handles.loadmov,'string');
%set(handles.loadmov,'enable','off');
mov=loadfile;
save mov mov;
set(handles.pushbutton2,'enable','on');
set(handles.pushbutton1_1,'enable','on');
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in pushbutton2.
function pushbutton2_Callback(hObject, eventdata, handles)
Watermark;
save water_mov w_mov;
set(handles.pushbutton2_2,'enable','on');
% hObject    handle to pushbutton2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in pushbutton1_1.
function pushbutton1_1_Callback(hObject, eventdata, handles)
load mov mov
mplay(mov);
% hObject    handle to pushbutton1_1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)



% --- Executes on button press in pushbutton2_2.
function pushbutton2_2_Callback(hObject, eventdata, handles)
 playlast(1);
% hObject    handle to pushbutton2_2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in pushbutton2_3.
function pushbutton2_3_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton2_3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
figure();
nc_test1;

% --- Executes on button press in pushbutton2_4.
function pushbutton2_4_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton2_4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
figure();
psnr_test1;


% --- Executes on button press in pushbutton7.
function pushbutton7_Callback(hObject, eventdata, handles)
load water_salt;
w_mov=SaltPepper;
ExtractWatermark;
% hObject    handle to pushbutton7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in pushbutton2_5.
function pushbutton2_5_Callback(hObject, eventdata, handles)
load water_mov;
ExtractWatermark;
% hObject    handle to pushbutton2_5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in pushbutton3_1.
function pushbutton3_1_Callback(hObject, eventdata, handles)
Salt_and_Pepper;
load water_salt;
figure();
imshow(frame2im(SaltPepper(1)));
% hObject    handle to pushbutton3_1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in pushbutton4_1.
function pushbutton4_1_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton4_1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
gaussian;
load Gaussian;
figure();
imshow(frame2im(Gaussian(1)));
% --- Executes on button press in pushbutton4_2.
function pushbutton4_2_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton4_2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
load Gaussian;
w_mov=Gaussian;
ExtractWatermark;


% --- Executes on button press in pushbutton6_2.
function pushbutton6_2_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton6_2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
load Crap;
w_mov=Crap;
ExtractWatermark;

% --- Executes on button press in pushbutton6_1.
function pushbutton6_1_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton6_1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
crap;
load Crap;
w_mov=Crap;
imshow(frame2im(Crap(1)));

% --- Executes on button press in pushbutton5_1.
function pushbutton5_1_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton5_1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
Filter;
load MedFilter;
figure();
imshow(frame2im(MedFilter(1)));

% --- Executes on button press in pushbutton5_2.
function pushbutton5_2_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton5_2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
load MedFilter;
w_mov=MedFilter;
ExtractWatermark;

% --- Executes on button press in pushbutton22.
function pushbutton22_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton22 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
load compr;
w_mov=compr;
ExtractWatermark;

% --- Executes on button press in pushbutton23.
function pushbutton23_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton23 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
figure();
nc_test2;

% --- Executes on button press in pushbutton24.
function pushbutton24_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton24 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
figure();
psnr_test;

% --- Executes on button press in pushbutton7_1.
function pushbutton7_1_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton7_1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
main;


% --- Executes on button press in pushbutton7_2.
function pushbutton7_2_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton7_2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
 playlast(2);


% --- Executes on button press in pushbutton28.
function pushbutton28_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton28 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
close all;
