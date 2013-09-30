/*************************************************************************
	> File Name: n_squre.c
	> Author: ldq
	> Mail: 446529842@qq.com 
	> Created Time: 2013年09月27日 星期五 14时54分48秒
 ************************************************************************/

#include<stdio.h>

int square(int n)
{
	int i =1 ;
	int temp = n -1;
	while(temp > 0)
	{
		i+=2;
		temp-=i;
	}

	if(temp==0)
	{
		return 1;
	}
	return 0;
}


int main()
{
	printf("%d\n",square(16));
	return 0 ;
}
