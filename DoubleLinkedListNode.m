%% DoubleLinkedListNode is a class to represent a double-linked node.
% We can implement Linked List [kind of Queue] after connecting its
% [DoubleLinkedListNode's] objects. These objects [double-linked node] are
% inserted in Queue using 'InsertEvent' function. 

classdef DoubleLinkedListNode < handle        % INHERITING handle class's property to Double Linked List
                                              % Node [basically reference thing]. handle is a Super-class
    
    properties                                % Defining properties [Fields] of this class
        Data                                  % To store Data [like Event's Source, Destination, Bandwidth etc]
        Next = DoubleLinkedListNode.empty     % To store next node's reference
        Prev = DoubleLinkedListNode.empty     % To store previous node's reference
    end
    
    methods
        
        function node = DoubleLinkedListNode(Data)    % [Constructor] This function is used to construct a
                                                      % DoubleLinkedListNode object with Data field initialized with given parameter
            if nargin == 1
                node.Data = Data;
            end
        end
        
        function insertAfter(newNode, nodeBefore)     % Inserts newNode after nodeBefore
            newNode.Next = nodeBefore.Next;
            newNode.Prev = nodeBefore;
            if ~isempty(nodeBefore.Next)
                nodeBefore.Next.Prev = newNode;
            end
            nodeBefore.Next = newNode;
        end
        
        function insertBefore(newNode, nodeAfter)     % Inserts newNode before nodeAfter.
            newNode.Next = nodeAfter;
            newNode.Prev = nodeAfter.Prev;
            if ~isempty(nodeAfter.Prev)
                nodeAfter.Prev.Next = newNode;
            end
            nodeAfter.Prev = newNode;
        end
        
        function removeNode(node)                     % Removes a node from a linked list [We'll remove head.Next]
            prevNode = node.Prev;
            nextNode = node.Next;
            if ~isempty(prevNode)
                prevNode.Next = nextNode;
            end
            if ~isempty(nextNode)
                nextNode.Prev = prevNode;
            end
            node.Next = DoubleLinkedListNode.empty;
            node.Prev = DoubleLinkedListNode.empty;
        end
    end
end