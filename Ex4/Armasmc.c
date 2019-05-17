#include <stdio.h>

extern void delayxms(int xms);

int main() {
	
	int i=100;
	
	while(1) {
		delayxms(1000);
		i--;
		if (i == 0) {
			i = 100;
		}
	}
	
	return 0;
}

