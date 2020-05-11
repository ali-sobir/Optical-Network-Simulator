% head is the header node of the Queue, its next field [head.next] contains
% the address of next node. then next node's next field [i.e head.next.next]
% contains the address of 3rd node and so on.....


function [head]  = InsertEvent(new,head);

flag =0;
current = head.Next;                                      % Initially, Current node is initialized with 1st node in Queue.
%% If Queue is empty i.e it has only header node.

if isempty(current)
    insertAfter(new,head);
    return
end

%% If Queue has multiple nodes [doubly-linked node].

while flag ==0
    if new.Data.TimeInstant > current.Data.TimeInstant     % Nodes are inserted according to their TimeInstant value.
        if ~isempty(current.Next)
            current = current.Next;                        % Jumping to the next node if node next to it exists.
        else
            insertAfter(new,current);                      % If no next node exists, Insert this new node right after this.
            flag =1;
        end
    else
        insertBefore(new,current);                         % new node is inserted before current node.
        flag =1;
    end
end