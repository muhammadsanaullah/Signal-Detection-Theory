temp = uint8(zeros(400,400,3)); %Create a dark stimulus matrix
temp1 = cell(10,2); %Create a cell that can hold 10 matrices

cert = cell(10,1);
tp = []; tn = []; fp = []; fn = [];
cert_present = []; cert_absent = [];

for i = 1:10 %Filling temp1
    
    temp(200,200,:) = 255; %Inserting a fixation point
    
    a = (i-1)*10;
    temp(200,240,:) = a; %Inserting a test point 40 pixels right
    %of it. Brightness range 0 to 90.
    
    if (a == 0) % denotes stimulus absent
        temp1{i,2} = 0;
    end
    if (a > 0) % denotes stimulus present
        temp1{i,2} = 1;
    end
    
    
    temp1{i,1} = temp; %Putting the respective modified matrix in cell
end %Done doing that

h = figure %Creating a figure with a handle h
stimulusorder = randperm(200); %Creating a random order from 1 to 200.
%For the 200 trials. Allows to have
%a precisely equal number per condition.
stimulusorder = mod(stimulusorder,10); %Using the modulus function to
%create a range from 0 to 9. 20 each.

stimulusorder = stimulusorder + 1; %Now, the range is from 1 to 10, as
%desired.
score = zeros(10,1); %Keeping score. How many stimuli were reported seen

tp_ = 0; tn_ = 0; fp_ = 0; fn_ = 0;

for i = 1:20 %200 trials, 20 per condition
    image(temp1{stimulusorder(1,i)}) %Image the respective matrix. As
    %designated by stimulusorder
   %Give subject feedback about which trial we are in. No other feedback.
    pause; %Get the keypress
    temp2 = get(h,'CurrentCharacter'); %Get the keypress. "." for present,
    %"," for absent.
    present = strcmp('.', temp2); %Compare strings. If . (present), temp3 = 1,
    absent = strcmp(',', temp2);
    %otherwise 0.
    pause;
    certainty = get(h, 'CurrentCharacter');

    switch certainty
        case certainty*(strcmp('1',certainty))
            cert{i} = certainty;
        case certainty*(strcmp('2',certainty))
            cert{i} = certainty;
        case certainty*(strcmp('3',certainty))
            cert{i} = certainty;
        case certainty*(strcmp('4',certainty))
            cert{i} = certainty;
        case certainty*(strcmp('5',certainty))
            cert{i} = certainty;
        case certainty*(strcmp('6',certainty))
            cert{i} = certainty;
        case certainty*(strcmp('7',certainty))
            cert{i} = certainty;
        case certainty*(strcmp('8',certainty))
            cert{i} = certainty;
        case certainty*(strcmp('9',certainty))
            cert{i} = certainty;
        otherwise
            cert{i} = 1;
    end
    

    if (temp1{stimulusorder(1,i),2} == 1 && present) 
        %score(stimulusorder(1,i)) = score(stimulusorder(1,i)) + 1; 
        tp_ = tp_ + 1;
        tp = [tp tp_];
        cert_present = [cert_present str2num(cert{i})];
    end % TP: Stimulus Present + Answered "present"
    if (temp1{stimulusorder(1,i),2} == 1 && absent)
        tn_ = tn_ + 1;
        tn = [tn tn_];
        cert_present = [cert_present str2num(cert{i})];
        %score(stimulusorder(1,i)) = score(stimulusorder(1,i)) + 0;
    end % TN: Stimulus Present + Answered "absent"
    if (temp1{stimulusorder(1,i),2} == 0 && present)
        fp_ = fp_ + 1;
        fp = [fp fp_];
        cert_absent = [cert_absent str2num(cert{i})];
        %score(stimulusorder(1,i)) = score(stimulusorder(1,i)) + 1; 
    end % FP: Stimulus Absent + Answered "present"
    if (temp1{stimulusorder(1,i),2} == 0 && absent)
        fn_ = fn_ + 1;
        fn = [fn fn_];
        cert_absent = [cert_absent str2num(cert{i})];
        %score(stimulusorder(1,i)) = score(stimulusorder(1,i)) + 0;
    end % FN: Stimulus Absent + Answered "absent"
        
    
    %score(stimulusorder(1,i)) = score(stimulusorder(1,i)) + temp3; %Add up.
    % In the respective score sheet.
end %End the presentation of trials, after 200 have lapsed.
cert_absent = 10 - cert_absent;
uc_p = []; uc_a = [];
uc_p = [uc_p unique(cert_present)]; uc_a = [uc_a unique(cert_absent)];
freq_p = histc(cert_present,uc_p);
freq_a = histc(cert_absent,uc_a);

close all;

figure;
histogram(cert_present); hold on; histogram(cert_absent); xlim([0.5 9.5]); 
legend('Stimulus Present', 'Stimulus Absent');

% sensitivity = []; specificity = [];
% 
% sens = tp_ / tp_ + fn_;
% spec = 1 - (tn_ / tn_ + fp_);
% 
% for crit = 1:9
%     
% 
y = [0,0,0,0,0,0,0,0,0]; z = [0,0,0,0,0,0,0,0,0];

for a = 1:1:length(uc_a)
    y(uc_a(a)) = freq_a(a);
end
for a = 1:1:length(uc_p)
    z(uc_p(a)) = freq_p(a);
end

x = 0:0.01:10; y1 = 10 - y; z1 = 10 - z;
y1 = normpdf(x,mean(y1),std(y1));
z1 = normpdf(x,mean(z1),std(z1))
y = normpdf(x,mean(y),std(y));
z = normpdf(x,mean(z),std(z));

figure;
plot(y); hold on; plot(z); legend('Stimulus Present','Stimulus Absent');
%xlim([0 1000]);

FA = [0,0,0,0,0,0,0,0,0]; HIT = [0,0,0,0,0,0,0,0,0];
figure
for i = 1:1:length(x) %Going through all elements of y
FA(i) = sum(y(1,i:length(y))); %Summing from ith element to rest ! FA(i)
HIT(i) = sum(z(1,i:length(y))); %Summing from ith element to rest ! Hit(i)
end
FA = FA./100; %Converting it to a rate
HIT = HIT./100; %Converting it to a rate
plot(FA,HIT) %Plot it
hold on
reference = 0:0.01:1; %reference needed to visualize
plot(reference,reference,'color','k') %Plot the reference

figure
m1 = [0,0,0,0,0,0,0,0,0]; m2 = [0,0,0,0,0,0,0,0,0]; m3 = [0,0,0,0,0,0,0,0,0];
for i = 1:length(x)-1
m1(i) = FA(i)-FA(i+1); %This recalls the
m2(i) = HIT(i)-HIT(i+1); %equation of a slope
end
m3 = m1./m2; %Dividing them
plot(m3)



% absent_hist = [0,0,0,0,0,0,0,0,0]; present_hist = [0,0,0,0,0,0,0,0,0];
% 
% for i = 1:length(uc_a)
%     absent_hist(uc_a(i)) = freq_a(i);
% end
% for i = 1:length(uc_p)
%     present_hist(uc_p(i)) = freq_p(i);
% end



% total_a = length(uc_a);
% for i = 1:total_a
%     absent_hist(i) = sum(freq_a(cert_absent == uc_a(i)));
% end
% 
% total_p = length(uc_p);
% for i = 1:total_p
%     present_hist(i) = sum(freq_p(cert_present == uc_p(i)));
% end


% Shapes of the ROC curve change according to the overlap between 
% distributions. More overlap means the curve is closer to diagonal,
% less overlap means the curve is further from the diagonal.
% At optimal point (ROC curve in the middle of diagonal and upper left corner)
% on the ROC curve there is no bias to say stimulus present or absent. 

