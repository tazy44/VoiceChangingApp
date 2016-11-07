function varargout = assignment1(varargin)
% ASSIGNMENT1 MATLAB code for assignment1.fig
%      ASSIGNMENT1, by itself, creates a new ASSIGNMENT1 or raises the existing
%      singleton*.
%
%      H = ASSIGNMENT1 returns the handle to a new ASSIGNMENT1 or the handle to
%      the existing singleton*.
%
%      ASSIGNMENT1('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in ASSIGNMENT1.M with the given input arguments.
%
%      ASSIGNMENT1('Property','Value',...) creates a new ASSIGNMENT1 or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before assignment1_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to assignment1_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help assignment1

% Last Modified by GUIDE v2.5 22-Mar-2016 23:17:45

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @assignment1_OpeningFcn, ...
                   'gui_OutputFcn',  @assignment1_OutputFcn, ...
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


% --- Executes just before assignment1 is made visible.
function assignment1_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to assignment1 (see VARARGIN)

% Choose default command line output for assignment1
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes assignment1 wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = assignment1_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
 set(hObject,'Toolbar','figure');
% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in fft.
function fft_Callback(hObject, eventdata, handles)
% hObject    handle to fft (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

%These two lines get data from other callbacks to use them in this callback
signal=handles.signal;
id=handles.id;

%Choosing the suitable sampling frequency based on the signal
if strcmp(id,'ecg')
    fs=250;
elseif strcmp(id,'speech')
    fs=8000;
else
    fs=100;
end
N=length(signal); %no. of samples
nfft=2^(nextpow2(N)); %increasing no. of samples

mag = abs(fft(signal, nfft));
phase=angle(fft(signal));
phase=unwrap(phase);

n = 0:N-1;
freq = n*fs/N;
%Normalizing frequency from 0 to 2pi
nfreq=(freq./max(freq))*2*pi;
axes(handles.axes2);  %To choose which axes to plot on
%plotting frequency spectrum
plot(nfreq(1:N), mag(1:N));
xlabel('Frequency (Hz)');
ylabel('Magnitude');
title('Single-sided Magnitude spectrum (Hertz)');
axis tight;
axes(handles.axes5);
plot(phase);

% Cropping the spectrum between two frequencies chosen by user
% [pt,~]=ginput(2);
% 
% for i=1:N
%     if (nfreq(i)>pt(1) && nfreq(i)<pt(2))
%         mag(i)=0;
%     end
%     
%     if (nfreq(i)<pt(1) && nfreq(i)>pt(2))
%         mag(i)=0;
%     end
% end

[pt,~]=ginput(2);

for i=1:N
    if (nfreq(i)>pt(1) && nfreq(i)<pt(2))
        phase(i)=0;
    end
    
    if (nfreq(i)<pt(1) && nfreq(i)>pt(2))
        phase(i)=0;
    end
end

axes(handles.axes3);
%Plotting the cropped frequency spectrum
%plot(nfreq(1:N), mag(1:N));
plot(phase);
xlabel('Frequency (Hz)');
ylabel('Magnitude');
title('Single-sided Magnitude spectrum (Hertz)');
axis tight;
handles.signal=signal;
guidata(hObject,handles);


% --- Executes on button press in ifft.
function ifft_Callback(hObject, eventdata, handles)
% hObject    handle to ifft (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
fsignal=handles.fsignal;
x=ifft(fsignal);
axes(handles.axes4);
plot(x);

% --- Executes on button press in sawtooth.
function sawtooth_Callback(hObject, eventdata, handles)
% hObject    handle to sawtooth (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

%Generating the signal
f=2;
T = 10*(1/f);
Fs = 100;
dt = 1/Fs;
t = 0:dt:T-dt;
signal = sawtooth(2*pi*f*t);

%Plotting
axes(handles.axes1);
plot(t,signal)
grid on;

%Making data available for other callbacks
handles.id='sawtooth';
handles.signal=signal;
guidata(hObject, handles);



% --- Executes on button press in speech.
function speech_Callback(hObject, eventdata, handles)
% hObject    handle to speech (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% recObj = audiorecorder;
% disp('Start speaking.')
% recordblocking(recObj, 4);
% disp('End of Recording.');
% Play back the recording.
% play(recObj);
% Store data in double-precision array.
% signal = getaudiodata(recObj);
% t=0:1/8000:4;


% Store Sound wave in an array
audioTime = 4;
[signal, fs] = audioread('sound.wav');
t=0:audioTime/(length(signal)-1):audioTime;
% sound(signal, fs);

% Plot the waveform.
axes(handles.axes1);
plot(t,signal);
grid on;

%Making data available for other callbacks
handles.signal=signal;
handles.id='speech';
guidata(hObject, handles);


% --- Executes on button press in ecg.
function ecg_Callback(hObject, eventdata, handles)
% hObject    handle to ecg (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

%Reading ecg signal
[~,signal,~]=rdsamp('f2y07',2,3500,2500);
t=0:1/250:4;
%Plotting
axes(handles.axes1);
plot(t,signal);
grid on;

%Making data available for other callbacks
handles.signal=signal;
handles.id='ecg';
guidata(hObject, handles);
