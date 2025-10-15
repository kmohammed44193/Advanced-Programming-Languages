#include <stdio.h>
#include <stdlib.h>

/* insertion sort ascending */
void insertion_sort(int *a, int n){
    for(int i=1;i<n;i++){
        int key=a[i], j=i-1;
        while(j>=0 && a[j]>key){ a[j+1]=a[j]; j--; }
        a[j+1]=key;
    }
}

/* mean */
double mean(const int *a,int n){
    long long s=0;
    for(int i=0;i<n;i++) s+=a[i];
    return (double)s/(double)n;
}

/* median: requires sorted */
double median(const int *s,int n){
    if(n%2) return (double)s[n/2];
    return (s[n/2-1]+s[n/2])/2.0;
}

/* modes from sorted; returns count and writes into out[] */
int modes_from_sorted(const int *s,int n,int *out){
    if(n<=0) return 0;
    int maxf=1, cur=1, cnt=0;
    for(int i=1;i<n;i++){
        if(s[i]==s[i-1]) cur++;
        else { if(cur>maxf) maxf=cur; cur=1; }
    }
    if(cur>maxf) maxf=cur;
    cur=1;
    for(int i=1;i<=n;i++){
        if(i<n && s[i]==s[i-1]) cur++;
        else { if(cur==maxf) out[cnt++]=s[i-1]; cur=1; }
    }
    return cnt;
}

int main(void){
    int n;
    printf("Enter N: ");
    if(scanf("%d",&n)!=1 || n<=0){ fprintf(stderr,"N must be positive.\n"); return 1; }

    int *a = (int*)malloc(sizeof(int)*n);
    if(!a){ fprintf(stderr,"Alloc fail.\n"); return 1; }

    printf("Enter %d integers (space-separated): ", n);
    for(int i=0;i<n;i++){
        if(scanf("%d",&a[i])!=1){ fprintf(stderr,"Invalid input at %d.\n", i); free(a); return 1; }
    }

    int *s = (int*)malloc(sizeof(int)*n);
    if(!s){ fprintf(stderr,"Alloc fail.\n"); free(a); return 1; }
    for(int i=0;i<n;i++) s[i]=a[i];
    insertion_sort(s,n);

    double m_mean = mean(a,n);
    double m_median = median(s,n);

    int *modes = (int*)malloc(sizeof(int)*n);
    if(!modes){ fprintf(stderr,"Alloc fail.\n"); free(s); free(a); return 1; }
    int mcnt = modes_from_sorted(s,n,modes);

    printf("\nInput: ");
    for(int i=0;i<n;i++){ printf("%d", a[i]); if(i+1<n) printf(" "); }
    printf("\nSorted: ");
    for(int i=0;i<n;i++){ printf("%d", s[i]); if(i+1<n) printf(" "); }
    printf("\nMean  : %.6f", m_mean);
    printf("\nMedian: %.6f", m_median);
    printf("\nMode  : [");
    for(int i=0;i<mcnt;i++){ printf("%d", modes[i]); if(i+1<mcnt) printf(", "); }
    printf("]\n");

    free(modes);
    free(s);
    free(a);
    return 0;
}
