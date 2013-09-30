/*************************************************************************
	> File Name: generate.c
	> Author: ldq
	> Mail: 446529842@qq.com 
	> Created Time: 2013年09月27日 星期五 14时07分17秒
 ************************************************************************/

#include<stdio.h>

int min_gongBeiShu(int x,int y)
{
	int max = x;
	int min = y;

	if(max<min)
	{
		min = max;
		max = y;
	}

	if(max% min == 0)
	{
		 return max;
	}
	int temp = max ;

	while(max%min!=0)
	{
		max+temp;
	}

	return max;
}

int generate(int a,int b ,int* N )
{
	int n = *N;

	int max = a;
	int min = b;
	int count = 0;

	if(max< min)
	{
		max = b;
		min = a;
	}

	int gongBeiShu = min_gongBeiShu(max,min);
	int minNum = min;
	int maxNum = max;
	count = 2;

	while(count<n)
	{
		if(minNum<maxNum)
		{
			minNum+=min;
			printf("%d\n",minNum);
			count++;
		}
		else
		{
			if(maxNum%gongBeiShu!=0)
			{
				maxNum+=max;
				printf("%d\n",maxNum);
				count++;
			}
		}

	}
}

int main()
{
	int*  n = 6;
	generate(3,5,n);
	return 0;
}
