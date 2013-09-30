/*************************************************************************
	> File Name: revest.c
	> Author: ldq
	> Mail: 446529842@qq.com 
	> Created Time: 2013年09月27日 星期五 15时23分28秒
 ************************************************************************/

#include<stdio.h>

void revest(char* array,int size)
{
	for(int i = 0 ; i < size/2;i++)
	{
		array[i] +=array[size-1-i];
		array[size-1-i] = array[i] - array[size-1-i];
		array[i] = array[i] - array[size-1-i];
	}

}

void print(char* array, int size)
{
	for(int i = 0;i<size ; i++)
	{
		printf("%c",array[i]);
	}

	printf("\n");
}

int main()
{
	char array[5] = {'a','b','c','d','e'};
	print(array,5);
	revest(array,5);
	print(array,5);
	return 0;

}
