/*************************************************************************
	> File Name: full_perm.c
	> Author: ldq
	> Mail: 446529842@qq.com 
	> Created Time: 2013年09月27日 星期五 12时55分19秒
 ************************************************************************/

#include<stdio.h>

int count = 0 ;
void swap(int* array, int i, int j)
{
	int temp = array[i];
	array[i] = array[j];
	array[j] = temp;
}

void quanPaiLie(int* array,int index,int size)
{
	if(index >= size)
	{
		count++;
		for(int i =0; i < size;i++)
		{
			printf("%d ",array[i]);
		}
		printf("\n");
	    return;
	}

	for(int i = index;i <size;i++)
	{
		swap(array,index,i);
		quanPaiLie(array,index+1,size);
		swap(array,index,i);
	}
}

int main()
{
	int array[10 ] = {0,1,2,3,4};
	quanPaiLie(array,0,5);
	printf("count is:%d\n",count);
}
