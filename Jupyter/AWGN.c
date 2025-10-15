/*This program generates Additive White Gaussian Noise (AWGN) based on the Box-Muller Transformation*/ 
/*given by S= [-2*loge r1]1/2 * cos (2*PI*r2) where r1 and r2 are two functions used to generate*/  
/*random numbers between 0.0 and 1.0.*/  
 
#include<ctype.h> 
#include<math.h> 
#include<stdlib.h> 
#include<stdio.h> 
 
#define e 2.71828 
#define PI 3.142 
#define SEED 100     	// Used together with library function srand so  
				    	// that same sequence of AWGN is obtained each time program is executed. 
						// Refer to Scahume's programming with c 
 
void main() 
{ 
	double r1,r2,s,mid_value; 
	int count,item,num; 
	int freq[10]={0}; 
 
	FILE *noise_freq;	// Excel data file to store noise and corresponding frequency of occurence for each noise interval. 
 
	noise_freq=fopen("AWGN_frequency.xls","w"); //To be able to plot required graph 
	srand(SEED);    	// Used to initialise random number generator. 
 
	printf("\n\t   Generation of AWGN based on the Box-Muller transformation."); 
	printf("\n\nEnter number of noise signal to be generated (preferably a very large value):\n\n"); 
 
	//The larger the number inout, the larger the standard deviation of the noise distribution 
	//Try with no. of noise signal to be generated: 50000 or even greater!!! 
	 
	scanf("%d",&num); 
	count=0; 
	printf("\n\n\t\t\t\tCount  Noise voltage (V)\n"); 
 
	while(count<num) 
	{ 
		r1= rand()/ 32768.0; 
		r2= rand()/32768.0; 
		s= sqrt(-2* log(r1)/log(e)) * cos(2*PI*r2);//Box-Muller Transformation 
		 
		printf("\n\t\t\t\t%d \t %0.2f",count+1,s); 
		for(item=-5;item<=4;++item) // Finding frequency of occurence of noise voltage lying in a particular the interval. 
		{ 
			if((s>item)&&(s<=(item+1))) //Interval N to N+1 
			{	 
				++freq[item+5];//freq[0] to freq[9] because of 10 different noice ranges 
				break; 
			} 
		} 
 
		++count; 
 
	} 
	 
	printf("\n\n\n\n\t\t\t  Noise(N) \t Frequency \n");// Displaying frequency of noise in each voltage interval. 
	fprintf(noise_freq,"Noise (midpoint) \t Frequency\n");// Displaying frequency for each noise interval so that graph can be plotted. 
	for(item=0;item<=9.0;++item) 
	{	 
		mid_value=((2.0*item)-9.0)/2.0; 
		printf(" \n\t\t\t  %d < N <= %d \t %d",item-5,item-4,freq[item]); 
		fprintf(noise_freq,"%0.2f \t %d \n",mid_value,freq[item]); 
	} 
	 
	fclose(noise_freq); 
	printf("\n\n\t\t\t"); 
 
} 