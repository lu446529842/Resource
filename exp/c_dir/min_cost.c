/*************************************************************************
	> File Name: min_cost.c
	> Author: ldq
	> Mail: 446529842@qq.com 
	> Created Time: 2013年09月16日 星期一 16时29分26秒
 ************************************************************************/

#include<stdio.h>

int get_left(int t)
{
	int sum = 0 ;
	int i = 1;
	for (i;i < t ;i++)
	{
		sum+=(i*(t-i)) ;
	}

	return sum ;
}

int get_right(int t,int n)
{
	int sum = 0 ;
	int i = n ;
	for (i ; i > t ; i--)
	{
		sum += (i*(i-t));
	}

	return sum;
}
int get_cost(int n,int t)
{
	return get_left(t) + get_right(t,n);
}

int main()
{
	int n = 1000 ;
	int t = 1 ;
	int sum = -1;
	int best_t = t;

	for(t ; t <= n ;t++)
	{
		int temp = get_cost(n,t);
		printf("##########--sum:%d--t:%d###############\n",temp,t);
		if (temp < sum||sum < 0)
		{
			sum = temp;
			best_t = t;

		}
	}

	printf("best t is :%d",best_t);
	return 0;

}
