/*************************************************************************
	> File Name: get_1_count.c
	> Author: ldq
	> Mail: 446529842@qq.com 
	> Created Time: 2013年09月24日 星期二 11时27分31秒
 ************************************************************************/

#include<stdio.h>
#include<math.h>

int get_count(int n)
{
	int num = 0;
	while(n)
	{
		num+=(n%10==1?1:0);
		n=n/10;
	}

	return  num;
}

int get_n_count(int n)
{
	int sum = 0;
	for(int i = 1;i<= n;i++)
	{
		sum+=get_count(i);
	}
	return sum;
}

int get_b_ditui(int n)
{
	int time = 0;
	int num = 0;

	int temp = n%10;
	n = n / 10;

	if(temp > 0)
	{
		num+=1;
	}

	while(n)
	{
		int temp = n%10;
		n= n / 10;
		time++;

		if(temp > 0)
		{
			num+=(1+time*pow(10,time-1));
		}

	}
	return num ;

}


int main()
{
	printf("1 count:%d\n",get_n_count(100000000));
	printf("1 count:%d\n",get_b_ditui(100000000));
	return 0;
}
