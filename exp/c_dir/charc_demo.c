/*************************************************************************
	> File Name: charc_demo.c
	> Author: ldq
	> Mail: 446529842@qq.com 
	> Created Time: 2013年09月26日 星期四 11时06分30秒
 ************************************************************************/

#include<stdio.h>
#include<stdlib.h>

void printfChar(char * array)
{
	printf("--%c\n",*array);
}

void printfInt(int * array)
{
	printf("--%d\n",*array);
}

int main()
{
	int array[4] = {1,2,3,4};

	for(int i = 0;i< 3;i++)
	{
		printfInt(array+i);
		printfChar(array+i);
	}

	return 0;

}
