/*************************************************************************
	> File Name: Fibonacci.c
	> Author: ldq
	> Mail: 446529842@qq.com 
	> Created Time: 2013年09月24日 星期二 14时40分03秒
 ************************************************************************/

#include<stdio.h>

int fibonacci(int n,int *array)
{
	if (n==0)
	{
		return 0;
	}
	if(n==1)
	{
		return 1;
	}

	return fibonacci(n-1,array)+fibonacci(n-2,array);

}

int fibonacci_time(int n,int *array)
{
	if (n==0)
	{
		return 0;
	}
	if(n==1)
	{
		return 1;
	}
    if(array[n]!=-1)
	{
		return array[n];
	}

	array[n]= (fibonacci(n-1,array)+fibonacci(n-2,array));
	return array[n];

}

int main()
{
	int array[20];
	for(int i = 0;i<20;i++)
	{
		array[i] = -1;
	}

	printf("%d\n",fibonacci(20,array));
	for(int i = 0;i<20;i++)
	{
		array[i] = -1;
	}
	printf("%d\n",fibonacci_time(20,array));
	return 0;
}
