#include<stdio.h>

int func(int a1, int a2, int a3, int a4, int a5, int a6, int a7, int a8){
	int loc1 = a1 + 1;
	int loc8 = a8 + 8;
	return loc1 + loc8;
}


int main(){
	return func(11, 22, 33, 44, 55, 66, 77, 88);
}
