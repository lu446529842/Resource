/*************************************************************************
	> File Name: link.c
	> Author: ldq
	> Mail: 446529842@qq.com 
	> Created Time: 2013年09月23日 星期一 15时50分34秒
 ************************************************************************/

#include<stdio.h>
#include<stdlib.h>

struct linkNode
{
	int key;
	linkNode* next ;
};

linkNode* buildlinkNode(int* array,int size)
{
	linkNode * head = (linkNode*)malloc(sizeof(linkNode));
	head->key = 0;

	linkNode *first =(linkNode*)malloc(sizeof(linkNode));
	first->key = array[0];
	first->next = NULL;

	head->next = first;

	for(int i = 1; i <size ;i++)
	{
		linkNode* temp = (linkNode*)malloc(sizeof(linkNode));
		temp->key = array[i];
		first->next = temp;
		first = first->next;
	}

	return head;

}


int main()
{
	int array[10]={10,9,5,121,54,1,25,14,54,10};
	linkNode* head = buildlinkNode(array,10);
	linkNode * temp = head->next;

	while(temp)
	{
		printf("%d\n",temp->key);
		temp = temp->next;
	}

	return 0;
}
