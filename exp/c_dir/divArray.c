/*************************************************************************
	> File Name: divArray.c
	> Author: ldq
	> Mail: 446529842@qq.com 
	> Created Time: 2013年09月26日 星期四 11时57分02秒
 ************************************************************************/

#include<stdio.h>

int* divArray(int * array,int size)
{
	for(int i = size -1;i >= 0;i--)
	{
		array[i]/=array[0];
	}

	return array;
}
