/*************************************************************************
	> File Name: phone_num.c
	> Author: ldq
	> Mail: 446529842@qq.com 
	> Created Time: 2013年09月25日 星期三 09时49分04秒
 ************************************************************************/

#include<stdio.h>

char c[10][10] = {"","","ABC","DEF","GHI","JKL","MNO","PQRS","TUV","WXYZ"};
int total[10] = {0,0,3,3,3,3,3,4,3,4};
int number[3]={6,9,8};
int answer[3]={0,0,0};

void while_methom(int n)
{
	
	while(true)
	{
		for(int i = 0 ; i < n;i++)
		{
			printf("%c",c[number[i]][answer[i]]);
		}
		printf("\n");

		int k =n-1;
		while(k>=0)
		{
			if(answer[k]<total[number[k]]-1)
			{
				answer[k]++;
	 			break;
			}
			else
			{
	 			answer[k]=0;
				k--;
			}
		}

		if(k<0)
		{
			break;
		}
	}

}

void for_methom()
{

	for(answer[0] = 0 ;answer[0]<total[number[0]];answer[0]++)
	{
		for(answer[1] = 0; answer[1]<total[number[1]];answer[1]++)
		{
			for(answer[2] = 0;answer[2]<total[number[2]];answer[2]++)
			{
				for(int i =0 ; i< 3;i++)
				{
					printf("%c",c[number[i]][answer[i]]);
				}
				printf("\n");

			}
		}
	}

}

void Recursive(int index ,int n)
{
	if(index == n)
	{
		for(int i = 0 ;i< n;i++)
		{
			printf("%c",c[number[i]][answer[i]]);
		}
		printf("\n");

		return;
	}

	for(answer[index] = 0;answer[index]< total[number[index]];answer[index]++)
	{
		Recursive(index+1,n);
	}
}


int main()
{
	printf("we are starting....!");
	Recursive(0,3);
	return 0;
}
