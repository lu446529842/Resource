/*************************************************************************
	> File Name: string_smulate.c
	> Author: ldq
	> Mail: 446529842@qq.com 
	> Created Time: 2013年09月25日 星期三 11时40分07秒
 ************************************************************************/

#include<stdio.h>

int minValue(int a,int b,int c)
{
	int min = a;
	if(min> b)
	{
		min = b;
	}

	if(min>c)
	{
		min = c;
	}

	return min;
}


int getMinDistance(char* str1,int index ,int end, char* str2,int index_2,int end_2)
{
	if(index>end_2)
	{
		if(index_2>end_2)
		{
			return 0;
		}
		else
		{
			return (end_2 - index_2 +1);
		}

	}


	if(index_2>end)
	{
		if(index > end)
		{
			return 0;
		}
		else
		{
			return (end - index +1);
		}
	}

	if(str1[index]==str2[index_2])
	{
		return getMinDistance(str1,index+1,end,str2,index_2+1,end_2);
	}
	else
	{
		int a = getMinDistance(str1,index+1,end,str2,index_2+2,end_2);
		int b = getMinDistance(str1,index+2,end,str2,index_2+1,end_2);
		int c = getMinDistance(str1,index+2,end,str2,index_2+2,end_2);

		return minValue(a,b,c) +1;

	}
}

int main()
{
	char str1[10]= {'a','s','f','d','n','k','l','c','v','f'};
	char str2[8] = {'a','s','f','d','k','l','c','f'};
	int distance = getMinDistance(str1,0,9,str2,0,7);
	printf("%d\n",distance);
	return 0;
}

