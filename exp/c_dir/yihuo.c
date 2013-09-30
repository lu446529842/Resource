/*************************************************************************
	> File Name: yihuo.c
	> Author: ldq
	> Mail: 446529842@qq.com 
	> Created Time: 2013年09月22日 星期日 14时19分11秒
 ************************************************************************/

#include<stdio.h>

int get_yihuo(int * array,int size)
{
	int temp = 0;
	for(int i =0 ; i < size ;i++)
	{
		temp = temp^array[i];
	}

	return temp;
}

void find_two(int * array,int size,int temp)
{
	int j = 0;
	for(j = 0; j++ ;j < 32)
	{
		if((temp>>j)&1==1)
		{
			break;
		}
	}

	int temp_a = 0;
	int temp_b = 0;
   
	for(int i = 0;i < size;i++)
	{
		if(((array[i]>>j)&1)==1)
		{
			temp_a^=array[i];
		}
		else
		{
			temp_b^= array[i];
		}

	}

	printf("%d\n",temp_a);
	printf("%d\n",temp_b);
}

int main()
{
	int array[10] = {1,1,2,2,3,3,4,4,5,6};
	find_two(array,10,get_yihuo(array,10));

}
