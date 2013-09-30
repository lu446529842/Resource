/*************************************************************************
	> File Name: two_num_divide.c
	> Author: ldq
	> Mail: 446529842@qq.com 
	> Created Time: 2013年09月27日 星期五 13时20分23秒
 ************************************************************************/

#include<stdio.h>

int divide(const int y,const int x)
{
	if(y<x)
	{
		return 0;
	}

	
	int temp = y;
	int count = 0;

	while((temp-=x)>=0)
	{
		count++;
	}

	return count++;
}


int main()
{
	const int y = 500;
	const int x = 24 ;


	printf("%d\n",divide(y,x));
}
