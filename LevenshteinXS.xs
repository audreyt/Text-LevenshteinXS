#include "EXTERN.h"
#include "perl.h"
#include "XSUB.h"

/****************************************************/
/* Levenshtein Distance Algorithm		    */
/* C Implementation by Lorenzo Seidenari	    */
/* http://www.merriampark.com/ldc.htm		    */
/* modified by dree				    */
/****************************************************/

#include <stdlib.h>
#include <string.h>

int levenshtein_distance(SV *s,SV *t);
int minimum(int a,int b,int c);

int levenshtein_distance(SV* s, SV* t)

/*Compute levenshtein distance between s and t*/
{
  //Step 1
  int k,i,j,n,m,cost,*d,distance;

  n=sv_len_utf8(s);
  m=sv_len_utf8(t);

  U8* ps = SvPVX(s);
  U8* pt = SvPVX(t);

  // optimisation for equal strings
  if(m == n && memEQ(ps, pt, n)) { return 0; }

  if(n==0) {return m;}
  if(m==0) {return n;}

  d=malloc((sizeof(int))*(m+1)*(n+1));

  m++;
  n++;
  //Step 2	
  for(k=0;k<n;k++)
	d[k]=k;
  for(k=0;k<m;k++)
      d[k*n]=k;


  U8* si = ps;
  U8* ti = pt;

  int size;

  //Step 3 and 4	
  for(i=1;i<n;i++)
  {
    size = UTF8SKIP(si);

    ti = pt;

    for(j=1;j<m;j++)
    {
        if(memEQ(si, ti, size))
          cost=0;
        else
          cost=1;

        d[j*n+i]=minimum(d[(j-1)*n+i]+1,d[j*n+i-1]+1,d[(j-1)*n+i-1]+cost);

        ti = utf8_hop(ti, 1);
    }
    
    si = utf8_hop(si, 1);
  }

  distance=d[n*m-1];

  free(d);

  return distance;
}

/*Gets the minimum of three values*/
int minimum(int a, int b, int c)
{
  int min=a;

  if(b<min)
    min=b;

  if(c<min)
    min=c;

  return min;
}

MODULE = Text::LevenshteinXS		PACKAGE = Text::LevenshteinXS

int
distance(s,t)
	SV * s
	SV * t
CODE:
	RETVAL = levenshtein_distance(s,t);
OUTPUT:
	RETVAL

