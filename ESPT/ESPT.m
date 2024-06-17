function varargout = ESPT(varargin)
%ESPT MATLAB code file for ESPT.fig
%      ESPT, by itself, creates a new ESPT or raises the existing
%      singleton*.
%
%      H = ESPT returns the handle to a new ESPT or the handle to
%      the existing singleton*.
%
%      ESPT('Property','Value',...) creates a new ESPT using the
%      given property value pairs. Unrecognized properties are passed via
%      varargin to ESPT_OpeningFcn.  This calling syntax produces a
%      warning when there is an existing singleton*.
%
%      ESPT('CALLBACK') and ESPT('CALLBACK',hObject,...) call the
%      local function named CALLBACK in ESPT.M with the given input
%      arguments.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help ESPT

% Last Modified by GUIDE v2.5 29-May-2023 11:46:26

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @ESPT_OpeningFcn, ...
                   'gui_OutputFcn',  @ESPT_OutputFcn, ...
                   'gui_LayoutFcn',  [], ...
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


% --- Executes just before ESPT is made visible.
function ESPT_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   unrecognized PropertyName/PropertyValue pairs from the
%            command line (see VARARGIN)

% Choose default command line output for ESPT
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes ESPT wait for user response (see UIRESUME)
% uiwait(handles.figure1);
i = imread('brain2.png');
imshow(i);

% --- Outputs from this function are returned to the command line.
function varargout = ESPT_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in pushbutton1.
function pushbutton1_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
module1();

% --- Executes on button press in pushbutton2.
function pushbutton2_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
module2();

% --- Executes on button press in pushbutton3.
function pushbutton3_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
module3();
