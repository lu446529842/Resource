/*************************************************************************
	> File Name: get_specific_bit.c
	> Author: ldq
	> Mail: 446529842@qq.com 
	> Created Time: 2013年09月29日 星期日 17时14分20秒
 ************************************************************************/

#include<stdio.h>
#include<math.h>

int get_specific_bit(int num,int count)
{
	return ((num/(int)pow((double)10,(double)count))%10);
}


int main()
{
	int a = 123;

	for(int i = 0;i < 3;i++)
	{
		printf("%d\n",get_specific_bit(a,i));
	}
	return 0;
}
