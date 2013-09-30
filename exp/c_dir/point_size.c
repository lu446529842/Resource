/*************************************************************************
	> File Name: point_size.c
	> Author: ldq
	> Mail: 446529842@qq.com 
	> Created Time: 2013年09月29日 星期日 11时26分48秒
 ************************************************************************/

#include<stdio.h>
#include<stdlib.h>
void reset(int array[],int size)
{
	for(int i = 0; i < size;i++)
	{
		printf("%d \n",array[i]);
	}
}
int main()
{

	int a  = 50;
	int* ap = &a;
	int** app=ap;
	printf("%d\n",app);
	printf("%d\n",ap);
	printf("%d\n",a);
	return 0;
}
