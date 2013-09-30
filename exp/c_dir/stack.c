/*************************************************************************
	> File Name: stack.c
	> Author: ldq
	> Mail: 446529842@qq.com 
	> Created Time: 2013年09月25日 星期三 14时14分23秒
 ************************************************************************/

#include<stdio.h>
#include<stdlib.h>

int stackTop = -1;
int maxStackItem = -1;
int stack_size = 100;
int stackItem[100] = {0};
int lastMaxItem[100] = {-1};


int get_max()
{
	if(maxStackItem > 0)
	{
		return stackItem[maxStackItem];
	}
	else
	{
		return -1;
	}

}
void push(int e)
{
	
	if(stackTop+1 >stack_size )
	{
		printf("stack already full !!!\n");
	}
	else
	{
		stackTop++;
		stackItem[stackTop] = e;

		if(e>get_max())
		{
			lastMaxItem[stackTop] = maxStackItem;
			maxStackItem = stackTop;
		}
		else
		{
			lastMaxItem[stackTop] = -1;
		}
	}
}


int pop()
{
	if(stackTop < 0)
	{
		printf("stach is empty!\n");
	}
	else
	{
		if(stackTop == maxStackItem)
		{
			maxStackItem = lastMaxItem[stackTop];
		}

		return stackItem[stackTop--];
	}
}

int main()
{
	for(int i = 0; i < 20;i++)
	{
		push(rand()%1000);
	}

	printf("current size is :%d\n",stackTop);
	printf("current max value is :%d",get_max());

}
