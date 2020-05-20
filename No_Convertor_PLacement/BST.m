%% BST [Binary Search tree] is a class.

% The instance of this class is used to implement the Queue using Binary Search
% tree [that we need to handle requests or events that are dynamically coming
% from diff-diff nodes in an Optical-Network].

% The Nodes are inserted on time basis of TimeInstant field of Events 
% i.e  BSTnode.Data.TimeInstant.


classdef BST
    
    properties
        
        root = BST.empty                                              % Initializing field 'root' to 0x0[i.e field is empty]. 
        
    end
    
    methods
        
        function [LeftMostNode ,Tree] = removeNode(Tree)               % Removes the Left Most Node in BST [i.e the one with minimum Time Instant value]
           
            flag1 =0;
            currentnodeN = Tree.root;                                  % currentnodeN becomes root node.                        
            
            %% if Tree dont have Left Sub-tree, root becomes LeftMostNode 
            if isempty(Tree.root.Left)                                 
                LeftMostNode = Tree.root;
                Tree.root = LeftMostNode.Right;                        % Tree root needs to change now.
                return
            end
            
            %% if Tree have Left Sub-tree
            while flag1 == 0
                if ~isempty(currentnodeN.Left)                        % if currentnodeN has left Sub-tree
                    currentnodeP = currentnodeN;
                    currentnodeN = currentnodeP.Left;
                else
                    if ~isempty(currentnodeN.Right)                   % if currentnode.N has Right Sub-tree.
                        LeftMostNode = currentnodeN;
                        currentnodeP.Left = currentnodeN.Right;
                        %CurrentNode.Right = BSTnode.empty;
                        flag1 = 1;                                    % Signals that we have got tree's LeftMostNode
                    else
                        LeftMostNode = currentnodeN;
                        currentnodeP.Left = BSTnode.empty;
                        flag1 =1;                                     % Signals that we've got tree's LeftMostNode
                    end
                end
            end
            
            
        end
        
        function [tree]  = InsertEvent(tree,new);
            
            flag1 =0;
            currentnode = tree.root;                                         % currentnode becomes root node.
            
            %% if Tree is empty [i.e no root node]
            if isempty(currentnode)                                   
                tree.root = new;                                             % then new becomes root node.
                return
            end
            
            %% If tree is not empty
            
            while flag1 ==0
                if new.Data.TimeInstant < currentnode.Data.TimeInstant       % if new value is less than current value, we enters in Left Sub-tree then. 
                    if isempty(currentnode.Left)                           
                        currentnode.Left = new;
                        flag1 = 1;
                        
                    else
                        currentnode = currentnode.Left;                     
                    end
                else                                                         % if new value is more than current value, we enter in Right Sub-tree then.
                    if isempty(currentnode.Right)            
                        currentnode.Right = new;
                        
                        flag1 = 1;
                    else
                        currentnode = currentnode.Right;
                    end
                end
            end
            
        end
        
    end
    
end



