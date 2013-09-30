/*************************************************************************
	> File Name: test.c
	> Author: ldq
	> Mail: 446529842@qq.com 
	> Created Time: 2013年09月16日 星期一 15时38分22秒
 ************************************************************************/

#include<stdio.h>

// test function
int test(int x)
{
	return x&(-x);
}

int main()
{
	int a = test(3);
	printf("my reslut is :%d",a);
}
