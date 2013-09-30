/*************************************************************************
	> File Name: reset_link.c
	> Author: ldq
	> Mail: 446529842@qq.com 
	> Created Time: 2013年09月29日 星期日 09时42分43秒
 ************************************************************************/

#include<stdio.h>
#include<stdlib.h>
struct node
{
	int key;
	node* next;
};

void reset(node* head)
{
	node* point;

	while(head->next->next != NULL)
	{
		point = head;
		while(point->next->next != NULL)
		{
			point = point->next;
		}
		point->next->next = head->next;
		head->next = point->next;
		point->next = NULL;

		head = head->next->next;

	}
}


node* buildlinkNode(int* array,int size)
{
	node * head = (node*)malloc(sizeof(node));
	head->key = 0;

	node *first =(node*)malloc(sizeof(node));
	first->key = array[0];
	first->next = NULL;

	head->next = first;

	for(int i = 1; i <size ;i++)
	{
		node* temp = (node*)malloc(sizeof(node));
		temp->key = array[i];
		first->next = temp;
		first = first->next;
	}

	return head;

}


int main()
{
	int array[10]={1,2,3,4,5,6,7,8,9,10};
	node* head = buildlinkNode(array,10);
	node * temp = head->next;
	reset(temp);
	temp = head->next;

	while(temp)
	{
		printf("%d\n",temp->key);
		temp = temp->next;
	}

	return 0;
}
