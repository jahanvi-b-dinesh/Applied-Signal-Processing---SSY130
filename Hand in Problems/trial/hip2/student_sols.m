%NO_PFILE
function [funs, student_id] = student_sols()
%STUDENT_SOLS Contains all student solutions to problems.

% ----------------------------------------
%               STEP 1
% ----------------------------------------
% Set to your birthdate / the birthdate of one member in the group.
% Should a numeric value of format YYYYMMDD, e.g.
% student_id = 19900101;
% This value must be correct in order to generate a valid secret key.
student_id = 20000524;


% ----------------------------------------
%               STEP 2
% ----------------------------------------
% Your task is to implement the following skeleton functions.
% You are free to use any of the utility functions located in the same
% directory as this file as well as any of the standard matlab functions.


    function h = gen_filter()
        dt=1; %sampling time
        fs=1/dt; %sampling frequency
        fcut=0.05; %cut off frequency
        fstop=0.1; %stop band frequency
        %Numerical frequencies are normalized to half the 
        %smapling frequecy so we use (fs/2).
        freq=[0 fcut/(fs/2) fstop/(fs/2) (fs/2)/(fs/2)];
        amp=[0 2*pi*fcut 0 0]; %amplitude
        h=firpm(60,freq,amp,'differentiator');
    end

funs.gen_filter = @gen_filter;


% This file will return a structure with handles to the functions you have
% implemented. You can call them if you wish, for example:
% funs = student_sols();
% some_output = funs.some_function(some_input);

end

