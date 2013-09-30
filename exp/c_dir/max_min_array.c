/*************************************************************************
	> File Name: max_min_array.c
	> Author: ldq
	> Mail: 446529842@qq.com 
	> Created Time: 2013年09月24日 星期二 15时50分20秒
 ************************************************************************/

#include<stdio.h>

struct max_min
{
	int max;
	int min;
};


max_min binarySearch(int * array,int l,int r)
{
	if(r-l<=1)
	{
		max_min mm;
		if(array[l]>array[r])
		{
			mm.max = array[l];
			mm.min = array[r];
		}
		else
		{
			mm.max = array[r];
			mm.min = array[l];
		}

		return mm;

	}

	max_min mm_l = binarySearch(array,l,(l+r)/2);
	max_min	mm_r = binarySearch(array,(l+r)/2,r);
	max_min max_mm;

	if(mm_l.max> mm_r.max)
	{
		max_mm.max = mm_l.max;
	}
	else
	{
		max_mm.max = mm_r.max;
	}

	if(mm_l.min<mm_r.min)
	{
		max_mm.min = mm_l.min;
	}
	else
	{
		max_mm.min = mm_r.min;
	}

	return max_mm;
}

int main()
{
	int array[10] = {546,1,5,2,5,4,58,4,543,546};
	max_min mm = binarySearch(array,0,9);

	printf("%d %d\n",mm.max,mm.min);

}
