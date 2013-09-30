/*************************************************************************
	> File Name: sqrt.c
	> Author: ldq
	> Mail: 446529842@qq.com 
	> Created Time: 2013年09月17日 星期二 14时27分23秒
 ************************************************************************/

#include<stdio.h>
#include<math.h>

double math_sqrt(float n)
{
	int count = 20;
	double k = 1.0 ;
	while (	fabs (k*k-n) > 1e-9 && count > 0)
	{
		k = (k+n/k)/2;
		count--;
	}
	return k;
}


int main()
{
	double  n = 3.0;
	double reuslt = math_sqrt(n);
	printf("---%lf",reuslt);
}
