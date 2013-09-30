/*************************************************************************
	> File Name: all_tickey_num.c
	> Author: ldq
	> Mail: 446529842@qq.com 
	> Created Time: 2013年09月29日 星期日 13时26分38秒
 ************************************************************************/

#include<stdio.h>

int get_num(int count,int left_count)
{
	if(left_count<0 )
	{
		return 0;
	}
	if(count<=0)
	{
		return 1;
	}

	
	int a = get_num(count -1,left_count+1);
	int b =  get_num(count-1,left_count -1);

	return a+b;

}


int main()
{
	printf("%d\n",get_num(3,0));
	return 0;
}
