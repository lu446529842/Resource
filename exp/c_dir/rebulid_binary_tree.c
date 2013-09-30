/*************************************************************************
	> File Name: rebulid_binary_tree.c
	> Author: ldq
	> Mail: 446529842@qq.com 
	> Created Time: 2013年09月26日 星期四 10时50分07秒
 ************************************************************************/

#include<stdio.h>
#include<stdlib.h>

struct node
{
	char c;
	node * left;
	node * right;
};

int get_node_pos(char c,char * mid , int size)
{
	for(int i = 0 ; i < size ; i++)
	{
		if(c == array[i])
		{
			return i;
		}
	}

	return -1;

}

void rebulid_binary_tree(int * pre,int * mid,int size,node * root)
{
	if(pre== NULL || mid == Null)
	{
		printf("refuse empty string!!\n");
		return;
	}

	node* temp = (node*)malloc(sizeof(node));
	temp->c = pre[0];
	temp->left = NULL;
	temp->right = NULL;

	if(root == NULL)
	{
		root = temp;
	}

	if (size == 1)
	{
		return;
	}

	int left_length = get_node_pos(*pre,mid,size);
	int right_length = size - left_length - 1;

	if(left_length > 0)
	{
		rebulid_binary_tree(pre+1,mid,left_length,root->left);
	}

	if(right_length > = 0)
	{
		rebulid_binary_tree(pre+left_length+1,mid+left_length+1,right_length,root->right);
	}
}


int main()
{

}
