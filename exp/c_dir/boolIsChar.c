/*************************************************************************
	> File Name: boolIsChar.c
	> Author: ldq
	> Mail: 446529842@qq.com 
	> Created Time: 2013年09月27日 星期五 12时40分31秒
 ************************************************************************/

#include<stdio.h>

int isChar(char c)
{
	int a = c - '0';
	return a;
}


int main()
{
	for(int i = 0;i<10;i++)
	{
		char a = '0' + i;
		printf("%d\n",isChar(a));
	}
	return 0;
}
