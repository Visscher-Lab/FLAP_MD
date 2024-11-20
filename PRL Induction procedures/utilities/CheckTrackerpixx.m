function [SummaryData EyeTrackerData ErrorData] = CheckTrackerpixx(EyetrackerType,eye_used,ScreenHeightPix,ScreenWidthPix,driftoffsetx,driftoffsety,ViewpointRefresh,el,datapixxtime)
% if(nargin==7)
%     el = 0;
% end
switch EyetrackerType
    case 1 % EyeLink
        EyelinkError=Eyelink('CheckRecording');
        if(EyelinkError~=0) % If there is an error in the data recording
            SummaryData = -1;
            EyeTrackerData = -1;
            ErrorData = EyelinkError;
        elseif Eyelink('NewFloatSampleAvailable') > 0 % if there is no error
            % and there is a new available sample of data
            CurEyelinkEvt = Eyelink('NewestFloatSample');
            if (CurEyelinkEvt.gx(eye_used+1) ~= el.MISSING_DATA) && ...
                    (CurEyelinkEvt.gy(eye_used+1) ~= el.MISSING_DATA)
                
                SummaryData(1) = CurEyelinkEvt.gx(eye_used+1)-driftoffsetx; % +1 to eye used as we're accessing a MATLAB array
                SummaryData(2) = CurEyelinkEvt.gy(eye_used+1)-driftoffsety;
                SummaryData(3) = CurEyelinkEvt.pa(eye_used+1);
                SummaryData(4) = -1; % need to compute velocity outside this function
                SummaryData(5) = GetSecs;
                
                EyeTrackerData = CurEyelinkEvt;
                ErrorData = -1;
            else
                SummaryData = -1;
                EyeTrackerData = 0;
                ErrorData = CurEyelinkEvt;
            end
        else
            SummaryData = -1;
            EyeTrackerData = -1;
            ErrorData = -1;
        end
        
    case 2 % VPixx
        
        %        [xScreenRight, yScreenRight, ~, ~, ~, ~, ~, ~, ~] = Datapixx('GetEyePosition');
        % pos = Datapixx('ConvertCoordSysToCustom', [xScreenRight, yScreenRight]);
        [xScreenLeft, yScreenLeft,xScreenRight, yScreenRight , ~, ~, ~, ~, ~] = Datapixx('GetEyePosition');
        if eye_used==1
            pos = Datapixx('ConvertCoordSysToCustom', [xScreenLeft, yScreenLeft]);
            [Left_Major, Left_Minor]= Datapixx('GetPupilSize');
            newpupil_maj=Left_Major;
            newpupil_min=Left_Minor;
        elseif eye_used==2
            pos = Datapixx('ConvertCoordSysToCustom', [xScreenRight, yScreenRight]);
            [~, ~,Right_Major, Right_Minor]= Datapixx('GetPupilSize');
            newpupil_maj=Right_Major;
            newpupil_min=Right_Minor;
        end
        SummaryData(1) = pos(1)-driftoffsetx; % +1 to eye used as we're accessing a MATLAB array
        SummaryData(2) = pos(2)-driftoffsety;
        SummaryData(3) = newpupil_maj; %CurEyelinkEvt.pa(eye_used+1);
        SummaryData(4) = -1; % need to compute velocity outside this function
        if datapixxtime==1
                             Datapixx('RegWrRd');
SummaryData(5) = Datapixx('GetTime');
        else
            SummaryData(5) = GetSecs;
        end
        EyeTrackerData = 0; %CurEyelinkEvt;
        ErrorData= -1;
    case 3 % Arrington
        [DataQuality]=vpx_GetDataQuality(eye_used);
        if(DataQuality > 2)
            SummaryData = -1;
            EyeTrackerData = -1;
            ErrorData = DataQuality;
        else
            [eyepos.x,eyepos.y]=vpx_GetGazePoint(eye_used);
            [xsize,ysize]=vpx_GetPupilSize(eye_used);
            [velx,vely]=vpx_GetComponentVelocity(eye_used);
            
            SummaryData(1) = (eyepos.x*ScreenWidthPix)+driftoffsetx;
            SummaryData(2) = (eyepos.y*ScreenHeightPix)+driftoffsety;
            SummaryData(3) = pi*(xsize/2)*(ysize/2);
            SummaryData(4) = sqrt((velx*ScreenWidthPix)^2 + (vely*ScreenHeightPix)^2)*ViewpointRefresh;
            SummaryData(5) = GetSecs;
            EyeTrackerData = -1;
            ErrorData = DataQuality;
        end
end