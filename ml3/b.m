load kos_doc_data.mat

W = max(A(:,2));  % number of unique words in A
D = max(A(:,1)); % number of document in A
word_frequency = zeros(W,1); % initialise frequency of each word

size_A = size(A);

for i=1:size_A(1) %iterate over entries
    w = A(i, 2); %get the word in the entry
    c = A(i, 3); % get the counts for the word 
    word_frequency(w,1) = word_frequency(w,1) + c; %add the counts
end

alpha = 1;
word_frequency = word_frequency + alpha;
bayes_word_frequency = word_frequency/sum(word_frequency); %normalise

cw2(bayes_word_frequency, V);

log_p = 0;
log_p1 = 0;
word_count = 0;
word_count1 = 0;
D_B = max(B(:,1));
D_1 = 2060;
size_B = size(B);

for i=1:size_B(1)
    wb = B(i,2);
    cb = B(i,3);
    frequency_b = bayes_word_frequency(wb);
    log_p = log_p + cb * log(frequency_b);
    word_count = word_count + cb;
    if (B(i,1) == D_1)
        log_p1 = log_p1 + cb * log(frequency_b);
        word_count1 = word_count1 + cb;
    end
end

log_p
log_p1
word_count1
per = exp( -log_p/ word_count)
per1 = exp( -log_p1/ word_count1)
        
    
    
