/*************************************************************************
	> File Name: top_k.c
	> Author: ldq
	> Mail: 446529842@qq.com 
	> Created Time: 2013年09月24日 星期二 13时10分44秒
 ************************************************************************/

#include<stdio.h>


void adjust_heap(int * array,int size ,int index)
{
	if(index > size/2)
	{
		return;
	}
	int min = index;
	int l = index*2;
	int r = index*2+1;

	if(l<=size&&array[min-1]> array[l-1])
	{
		min = l;
	}

	if(r<=size&&array[min-1]>array[r-1])
	{
		min = r;
	}

	if(index != min)
	{
		int temp = array[index-1];
		array[index-1]= array[min-1];
		array[min-1] = temp;
		adjust_heap(array,size,min);
	}


}

void build_heap(int * array,int size)
{
	for(int i = size/2;i>=1;i--)
	{
		adjust_heap(array,size,i);
	}

}


int main()
{
	int array[5]={54,21,543,54,24};
	int array_2[8] = {5465,15,421,563,54,2,62,6};

	build_heap(array,5);
	for(int i = 0; i< 8;i++)
	{
		if(array_2[i]>array[0])
		{
			array[0]=array_2[i];
			adjust_heap(array,5,1);
		}
	}


	for (int i = 0; i < 5;i++)
	{
		printf("%d\n",array[i]);
	}

	return 0 ;

}

