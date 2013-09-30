/*************************************************************************
	> File Name: max_sub_array.c
	> Author: ldq
	> Mail: 446529842@qq.com 
	> Created Time: 2013年09月22日 星期日 15时33分35秒
 ************************************************************************/

#include<stdio.h>


void get_max_array(int * array,int size)
{
	int temp = 0;
	int	start = 0;
	int	temp_start = 0;
	int end = -1;
	int	max  = -1;

	for(int i =0; i< size;i++)
	{
		temp+=array[i];
		if(max< temp)
		{
			temp_start = start;
			max = temp;
			end = i;
		}
		if(temp<0)
		{
			start = i+1;
			temp = 0;
		}
	}

	printf("max:%d\n",max);
	for(int i = temp_start;i<=end;i++)
	{
		printf("element:%d\n",array[i]);
	}

}


int main()
{
	int array[8] = {1,-2, 3, 10, -4, 7, 2, -5};
	get_max_array(array,8);
}
