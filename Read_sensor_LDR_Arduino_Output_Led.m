function varargout = untitled2(varargin)
% UNTITLED2 MATLAB code for untitled2.fig
%      UNTITLED2, by itself, creates a new UNTITLED2 or raises the existing
%      singleton*.
%
%      H = UNTITLED2 returns the handle to a new UNTITLED2 or the handle to
%      the existing singleton*.
%
%      UNTITLED2('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in UNTITLED2.M with the given input arguments.
%
%      UNTITLED2('Property','Value',...) creates a new UNTITLED2 or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before untitled2_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to untitled2_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help untitled2

% Last Modified by GUIDE v2.5 22-Oct-2016 01:18:47

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @untitled2_OpeningFcn, ...
                   'gui_OutputFcn',  @untitled2_OutputFcn, ...
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


% --- Executes just before untitled2 is made visible.
function untitled2_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to untitled2 (see VARARGIN)

% Choose default command line output for untitled2
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes untitled2 wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = untitled2_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on selection change in popupmenu1.
function popupmenu1_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu1 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu1


% --- Executes during object creation, after setting all properties.
function popupmenu1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton.
function pushbutton1_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

axes(handles.axes1);
cla(handles.axes1);
xlabel('Time(sec)');
ylabel('Amplitude (V)');
title('Reading sensor LDR'); 
ylim([0 5]);
Ts = .01;

porta = get(handles.popupmenu1,'Value');
porta = strcat('COM',int2str(porta));

try
    %fclose(instrfind);
    board = arduino(porta,'Uno');
    
    set(handles.textStatus,'String','Status: ON');
    
    hLine1 = line(nan, nan, 'Color','green');
    hLine2 = line(nan, nan, 'Color','red');
    %Inicia cronometro
    tic
    while 1
        
        b = readVoltage(board,0);
        voltagemLed = 5-b;
        
        writePWMVoltage(board,11,voltagemLed);
        writePWMVoltage(board,10,voltagemLed);
        pause(Ts/2);  %Delay
    
        x1 = get(hLine1, 'XData');
        y1 = get(hLine1, 'YData');
        
        y2 = get(hLine2, 'YData');
        y2 = [y2 voltagemLed];
        
        x1 = [x1 toc];  %toc = tempo decorrido
        y1 = [y1 b];
       
        set(hLine1, 'XData', x1, 'YData', y1);
        set(hLine2, 'XData', x1, 'YData', y2);
        
        pause(Ts/2);  %Delay
    end
catch exception 
     if(strcmp(exception.identifier, 'MATLAB:class:InvalidHandle'))
     set(handles.textStatus,'String','Status: OFF');
     else
     set(handles.textStatus,'String','Status: Failed');
     end
     clear board;
     %delete(board);
end



function editNum_Callback(hObject, eventdata, handles)
% hObject    handle to editNum (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of editNum as text
%        str2double(get(hObject,'String')) returns contents of editNum as a double


% --- Executes during object creation, after setting all properties.
function editNum_CreateFcn(hObject, eventdata, handles)
% hObject    handle to editNum (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function editTs_Callback(hObject, eventdata, handles)
% hObject    handle to editTs (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of editTs as text
%        str2double(get(hObject,'String')) returns contents of editTs as a double


% --- Executes during object creation, after setting all properties.
function editTs_CreateFcn(hObject, eventdata, handles)
% hObject    handle to editTs (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton.
function pushbutton_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%GRÁFICO FUNÇAO ORIGINAL
axes(handles.axes1);
cla(handles.axes1);
clear board;

num = str2double(strsplit((get(handles.editNum,'String')),' '));
den = str2double(strsplit((get(handles.editDen,'String')),' '));
Ts = str2double(get(handles.editTs,'String'));


%f= numden(input);

F = tf(num,den);
Z = c2d(F,Ts);
step(Z,'b', F, 'g');




function editDen_Callback(hObject, eventdata, handles)
% hObject    handle to editDen (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of editDen as text
%        str2double(get(hObject,'String')) returns contents of editDen as a double


% --- Executes during object creation, after setting all properties.
function editDen_CreateFcn(hObject, eventdata, handles)
% hObject    handle to editDen (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
