/*************************************************************************
	> File Name: next.c
	> Author: ldq
	> Mail: 446529842@qq.com 
	> Created Time: 2013年09月22日 星期日 12时57分13秒
 ************************************************************************/

#include<stdio.h>

void getNext(const char* pattern,int next[])
{
	next[0] = -1;
	//前k个相等的字符
    int k=-1,j=0;
	while(pattern[j] != '\0')
	{

		if(k!= -1 && pattern[k]!= pattern[j] )
		{
			//1.如果上次匹配的pattern[k] != pattern[j]
			//取出next第K位的值
			k = next[k];
		}

		//2.k 和J 向后移动一个位
		j++;
		k++;
		//T[j] != T[k]  next[j ] = k,else 等于 -1 或 0
		if(pattern[k]==pattern[j])
		{
			next[j] = next[k];
		}
		else
		{
			next[j] = k;
		}
	}

	for(int i =0 ;i <j ;i++)
	{
		printf("%d\n",next[i]);
	}

}
						 


int main()
{
 const char* str = "ababcaabc";
 int next[8] = {0};
 getNext(str,next);
}
