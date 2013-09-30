/*************************************************************************
	> File Name: paiLieZiZIFU.c
	> Author: ldq
	> Mail: 446529842@qq.com 
	> Created Time: 2013年09月30日 星期一 10时48分29秒
 ************************************************************************/

#include<stdio.h>

void init(int* array,char* str,int size)
{
	for (int i = 0;i<26;i++)
	{
		array[i] = 0;
	}

	for(int i = 0 ;i<size;i++)
	{
		array[str[i] - 'a']++;
	}
}

bool hasChar(int* array,char c)
{
	
	if(array[c - 'a']>0)
	{
		array[c-'a']--;
		return true;
	}
	return false;
}

bool iscontain(int* array,char* str,int size,char* str2,int size2)
{
	int index = 0;
	while(size-size2>=index)
	{
		if(hasChar(array,str[index]))
		{
			for(int i = 1;i< size2;i++)
			{
				if(!hasChar(array,str[index+i]))
				{
					index += (i+1);
					init(array,str2,size2);
					break;
				}
				if(i==size2-1)
				{
					return true;
				}
			}
		}
		else
		{
			index++;
		}
		
	}
	return false;
}


int main()
{
	int array[26] = {0};
	char str[7] = {'a','b','c','d','e','f','g'};
	char str2[4] = {'c','d','b','a'};

	init(array,str2,4);
	if(iscontain(array,str,7,str2,4))
	{
		printf("true");
	}
	else
	{
		printf("false");
	}
	return 0;
}
