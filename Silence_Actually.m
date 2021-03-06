function SoundVector = BreakTheSilence (num, Freq, Timelength)
% This is a function with 3 variables
% Inputs: 
%           num - sets the number of tones played
%           Freq - sets the carrier frequency of the tone (Hz)
%           Timelength - the total length that includes both
%                        the Tone(s) and Silence_Period
%   *** num can only exceed timelenght by 1 
% Outputs: 
%           SoundVector - A structure containing vectors of the sound
%                          waveform for each tone.

%Default Timelength is set to 10s. Default carrier frequency set to 2000Hz. 
%Default number of tones is set to 0.

    switch nargin
        % switch block tests each case until one is true
        % nargin determines the number of arguments inputted
        case 2
            Timelength = 10;
        case 1
            Timelength = 10;
            Freq = 2000;
        case 0 
            Timelength = 10;
            Freq = 2000;
            num = 0;  
    end


%Sample frequency
Fs = 200000;

%Initialize the sampling interval (Ts) and the length of the tone (T), 200ms.
Ts = 1/Fs;
T = 0:Ts:.2;

NormSin = sin(2*pi*Freq*T);                
NormSin = NormSin(1:end-1);

Ramp = round(numel(NormSin)/20);
RampUp = linspace(0,1,Ramp);
Hold = ones(1,numel(NormSin)-2*Ramp);
RampDown = linspace(1,0,Ramp);
X = [RampUp, Hold, RampDown];

%Apply the trapezoidal waveform to the normal tone.
Tone = NormSin.*X;

%Define the amount of silence periods based off the num(number of tones)

% no tones for chosen timelength duration > num = 0, create a silence period 
% that is the length of time chosen (Timelength)
if num == 0 
    Silence_Period = Timelength; 
elseif num == 1
    Silence_Period = Timelength;
    response = input('Press 1 if you would like the tone at the beginning\nPress 2 if you would like the tone at the end','s');
    Decision = 0;
        if strcmp(response, '1')==1
            Decision = 1;
        elseif strcmp(response, '2')==1
            Decision = 2;
        elseif strcmp(response, '1')==0 || strcmp(response, '2')==0
            disp('Please choose 1 or 2')
            %It ends here after though, I need it to loop again
        end
elseif num > 0
        Silence_Period = Timelength/(num-1); 
end 

%Create a startsound to avoid any bottleneck in playing the tones when
%sound begins.
%Initialize vector for the beginning silence
Silence = zeros(1, round(Fs*Silence_Period));
startsound = Silence(1:200000);

%An initial silent tone is played to avoid bottlenecks in audio cues
%for the first tone played.
sound(startsound,Fs);
    
for i = num
    if num == 0
         SoundVector = Silence; 
         sound(SoundVector,Fs);
    elseif num == 1
         SoundVector = Tone;
            if Decision == 1 
                sound(SoundVector,Fs);
            elseif Decision == 2
                SoundVector = [Silence, SoundVector]; 
                sound(SoundVector,Fs);
            end
    elseif num > 0 
        SoundVector = Tone; % just a portion of the old code moved into this 
        for i = 1:num-1
            SoundVector = [SoundVector, Silence, Tone]; 
            sound(SoundVector,Fs);
        end
    end
end
