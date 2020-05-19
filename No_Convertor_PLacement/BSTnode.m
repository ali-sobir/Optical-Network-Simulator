%% BSTnode [Binary Search tree] is a class of Tree- data structure's nodes.
% We've implemented queue using Binary Search Tree [BST] after connecting 
% its [BSTnode] objects at right places.


classdef BSTnode < handle       
    % INHERITING handle class's property to BSTnode  [basically reference 
    % thing]. handle is a Super-class.
    
    properties                                % Defining properties [Fields] of this class
        
        Data                                  % To store Data [like Event's Source, Destination, Bandwidth etc]
        Left = BSTnode.empty                  % To store node's Left child's reference
        Right = BSTnode.empty                 % To store node's Right child's reference
    
    end
    
    methods                                   % Defining functions that can operate on this class.                 
        
        function node = BSTnode(Data)         % [Constructor] This function is used to construct a BSTnode's
                                              % object with Data field initialized with given parameter
            if nargin == 1
                node.Data = Data;
            end
        end
        
     end
end
