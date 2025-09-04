#include <iostream>
#include <chrono>
#include <memory>
using namespace std;

void manual_leak() {
    int* a = new int[1'000'000];
    for (int i = 0; i < 5; ++i) a[i] = i;
   
}
void manual_correct() {
    int* a = new int[1'000'000];
    for (int i = 0; i < 5; ++i) a[i] = i;
    delete[] a;
}
void raai_safe() {
    auto a = make_unique<int[]>(1'000'000);
    for (int i = 0; i < 5; ++i) a[i] = i;
}

int main() {
    auto t1 = chrono::steady_clock::now();
    manual_leak();
    manual_correct();
    raai_safe();
    auto t2 = chrono::steady_clock::now();
    cout << "Ran in "
         << chrono::duration_cast<chrono::milliseconds>(t2 - t1).count()
         << " ms\n";
}
