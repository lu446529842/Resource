/*************************************************************************
	> File Name: njiecheng.cpp
	> Author: ldq
	> Mail: 446529842@qq.com 
	> Created Time: 2013年09月23日 星期一 15时39分19秒
 ************************************************************************/

#include<iostream>
using namespace std;
class sumN
{
	public :
		sumN()
		{
			n++;
			sum+=n;
		}

	void printResult();
	private :
		static int sum;
		static int n;
};

int sumN::sum=0;
int sumN::n=0;

void sumN::printResult()
{
	cout <<sum<<endl;
	cout << n <<endl;
}

int main()
{
	sumN * p = new sumN[100];
	p->printResult();
	delete p;
	return 0 ;
}
