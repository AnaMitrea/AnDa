#include <stdio.h>
#include <stdlib.h>

enum NodeType {OP=1, IDENTIFIER=2, NUMBER=3, ARRAY_ELEM=4, FUNCTION_CALL=5}; //OP=1, IDENTIFIER=2, NUMBER=3, ARRAY_ELEM=4, FUNCTION_CALL=5

struct Node
{
    int value;                  // default val = 0 pt operator node
    enum NodeType node_type;
    int flag;                   // 0-leaf node, 1-internal node
    char *op;                   // '+', '-', '*', '/'
    struct Node* left;
    struct Node* right;
};

struct Node* newLeafNode(int data, enum NodeType type)
{
    printf("newLeafNode: leaf=%d si nodetype=%d\n",data, type);
    struct Node* temp = (struct Node*)malloc(sizeof(struct Node));

    temp->value = data;
    temp->node_type = type;
    temp->flag = 0; // leaf
    temp->op = NULL;
    temp->left = NULL;
    temp->right = NULL;

    return temp;
}

struct Node* newOperatorNode(char operator, struct Node* stg, struct Node* drp)
{
    printf("newOperatorNode: op=%s\n",operator);

    struct Node* temp = (struct Node*)malloc(sizeof(struct Node));
    
    temp->value = 0;
    temp->node_type = 1;
    temp->flag = 1; //op

    temp->op = malloc(sizeof(char));
    *(temp->op) = operator;
    temp->left = stg;
    temp->right = drp;

    return temp;
}

int evalAST(struct Node* ast)
{
    printf("In functia eval\n");
    if(ast->flag == 0) // leaf node
    {   
        printf("Eval: flag=0\n");
        if(ast->node_type == IDENTIFIER) // an id: return the value of the identifier   
            return 0;  //-> valoarea se ia din tabelul de simboluri
        else
        if(ast->node_type == NUMBER) // a number: return the number
            return ast->value;
        else
        if(ast->node_type == ARRAY_ELEM) // vector element: return the corresponding value of the vector element
            return 0;
        else
        return 0;
    }
    else
    {
        printf("Eval: flag=1\n");
        // evalAST for left and right tree
        // combine the results according to the operation 
        switch(*(ast->op))
        {
            case '+' :  return evalAST(ast->left) + evalAST(ast->right);
                        break;
            case '-' :  return evalAST(ast->left) - evalAST(ast->right);
                        break;
            case '*' :  return evalAST(ast->left) * evalAST(ast->right);
                        break;
            case '/' :  return evalAST(ast->left) / evalAST(ast->right);
                        break;
        }
    }
}


int main()
{
    // int sum = 5+7;
    struct Node* root;
    root->left = newLeafNode(5, NUMBER);
    root->right = newLeafNode(7, NUMBER);
    root = newOperatorNode('+',root->left, root->right);

    evalAST(root);
    return 0;
}
