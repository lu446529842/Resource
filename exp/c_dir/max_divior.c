/*************************************************************************
	> File Name: max_divior.c
	> Author: ldq
	> Mail: 446529842@qq.com 
	> Created Time: 2013年09月24日 星期二 13时46分52秒
 ************************************************************************/

#include<stdio.h>

void max_divior(int x,int y)
{

	int max = 0;
	int min = 0;
	int b = 0 ;

	if(x>y)
	{
		max = x;
		min = y;
	}
	else
	{
		max = y;
		min = x;
	}

	b = max % min;

	while(b)
	{
		max = min;
		min = b ;
		b = max%min;
	}

	printf("max divisor is :%d\n",min);
}

int gcb(int x ,int y)
{
	if (x<y)
	{
		return gcb(y,x);
	}

	if(y==0)
	{
		return x;
	}
	else
	{
		return gcb(x-y,y);
	}
}


int main()
{
	max_divior(100,50);
	printf("max divisor is :%d\n",gcb(100,50));
	return 0;
}
