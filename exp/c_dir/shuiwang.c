/*************************************************************************
	> File Name: shuiwang.c
	> Author: ldq
	> Mail: 446529842@qq.com 
	> Created Time: 2013年09月24日 星期二 10时36分09秒
 ************************************************************************/

#include<stdio.h>

struct three_id
{
	int id;
	int id_2;
	int id_3;
};


three_id find_id(int *array,int size)
{
	three_id id;
	id.id = 0;
	id.id_2 = 0;
	id.id_3 = 0;

	int count = 0;
	int count_2 = 0;
	int count_3 = 0;

	for(int i = 0;i<size;i++)
	{
		// first candidate
		if(count == 0 )
		{
			id.id = array[i];
			count = 1;
		}
		else
		{
			if(id.id == array[i])
			{
				count++;
			}
			else
			{
				// second candidate
				if(count_2 == 0)
				{
					id .id_2 = array[i];
					count_2 = 1;
				}
				else
				{
					if( id.id_2 == array[i])
					{
						count_2++;
					}
					else
					{
						 //third candidate
						if(count_3 == 0)
						{
							id.id_3 = array[i];
						 	count_3 = 1;
						}
						else
						{
						 	if(id.id_3 == array[i])
							{
								count_3++;
							}
							else
							{
								count--; 
								count_2--;
								count_3--;
							}
						}
					}
				}
			}
		}
	}
	return id;
}

/************************************************************************/
int find(int * array,int n)
{
	int findId = -1;
	int count =0;
	for(int i = count;i< n;i++)
	{
		if(count == 0)
		{
			findId = array[i];
			count = 1;
		}
		else
		{
			if(findId == array[i])
			{
				count++;
			}
			else
			{
				count--;
			}
		}
	}

	return findId;
}


int main()
{
	int array[11] = {1,1,1,2,2,2,3,3,3,4,5};
	three_id id = find_id(array,11);
	printf("the three  ids is:%d %d %d \n",id.id,id.id_2,id.id_3);
	return 0;
}
