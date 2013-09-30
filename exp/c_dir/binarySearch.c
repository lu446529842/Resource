/*************************************************************************
	> File Name: binarySearch.c
	> Author: ldq
	> Mail: 446529842@qq.com 
	> Created Time: 2013年09月25日 星期三 16时57分08秒
 ************************************************************************/

#include<stdio.h>
#include<stdlib.h>

int binarySearch(int * array,int v,int size)
{
	int l = 0 ;
	int r = size -1 ;
	int index = 0;

	while(l<r)
	{
		index = (l+r)/2;

		if(array[index]==v)
		{
			return index;
		}

		if(array[index]>v)
		{
			r = index-1;
		}
		else
		{
			l = index+1;
		}

	}
	return -1;

}

int main()
{
	int array[10] = {0};
	for(int i = 0;i < 10;i++)
	{
		array[i] = i*32;
	}
	printf("binary serach reslut is: %d",binarySearch(array,64,10));
	printf("binary serach reslut is: %d",binarySearch(array,6,10));

}
