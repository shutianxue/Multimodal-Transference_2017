function [correctness] = AnalyzeResponse(order, answer)

%OUTPUT
%incorrect = 0; correct = 1

checkanswer = answer - 37;
checkanswer2 = answer - 38;


if  order == checkanswer
    correctness = 0;
elseif order == checkanswer2
    correctness = 0;
else
    correctness = 1;
end

if answer == -1;
    correctness = 0;
end
    