load kos_doc_data.mat

W = max(A(:,2));  % number of unique words in A
D = max(A(:,1)); % number of document in A
word_frequency = zeros(W,1); % initialise frequency of each word

for i=1:size(A) %iterate over entries
    w = A(i, 2); %get the word in the entry
    c = A(i, 3); % get the counts for the word 
    word_frequency(w,1) = word_frequency(w,1) + c; %add the counts
end

word_frequency = word_frequency/sum(word_frequency); %normalise

cw2(word_frequency, V)

% log_p = 0;
% D_B = max(B(:,1));
% max = intmin;
% min = intmax;
% 
% for j=1,D_B
%     for i=1:size_B(1)
%         wb = B(i,2);
%         cb = B(i,3);
%         frequency_b = word_frequency(wb);
%         if (B(i,1) == j)
%             log_p = log_p + cb * log(frequency_b);
%         end
%     end
%     if(log_p>max)
%         max=log_p;
%     end
%     if(log_p<min)
%         min=log_p;
%     end
% end
% 
% max
% min






