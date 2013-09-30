/*************************************************************************
	> File Name: queue.c
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

int queueSize = 0;
linkNode * head = NULL;
linkNode * tail = NULL;
int cur = -1;
int next = -1;


void init(linkNode * node)
{
	queueSize = 1;
	head = node;
	tail = node;
	cur = 0;
	int next = 1;
}


void push(linkNode * node)
{
	queueSize++;
	tail->next = node;
	tail = tail->next;
}

linkNode* pop()
{
	if(queueSize < 0)
	{
		return NULL;
	}

	linkNode* temp =head;
	queueSize--;

	if(head->next)
	{
		head = head->next;
	}
	cur++;
}

int get_size()
{
	return queueSize;
}
}

void printBinaryByLayer(int * tree)
{
	if(tree == NULL)
	{
		return;
	}

	init(tree);

	while(cur<get_size())
	{
		next = get_size();

		while(cur< next)
		{
			print
		}
	}
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
