#include <stdio.h>

void sample_function()
{
	int i = 0;
	char buffer[10];

	printf("In sample_function(), i is stored at 0x%08x.\n", &i); 
	printf("In sample_function(), buffer is stored at 0x%08x.\n", &buffer); 

	printf("Value of i before calling gets(): 0x%08x\n", i); 
	gets(buffer); 
	printf("Value of i after calling gets(): 0x%08x\n", i); 
	return;
}

int main()
{
	int x; 
	
	printf("In main(), x is stored at 0x%08x.\n", &x); 
	sample_function();
}
