Screen('TextFont',w, 'Arial');
Screen('TextSize',w, 42);
%     Screen('TextStyle', w, 1+2);
Screen('FillRect', w, gray);
colorfixation = white;
DrawFormattedText(w, 'Rest your eyes.\n\n  \n \n \n \n Press any key to start', 'center', 'center', [255 255 255]);
Screen('Flip', w);
KbQueueWait;
