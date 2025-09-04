// Section 2: C++ closures & capture
#include <iostream>
#include <vector>
#include <functional>
using namespace std;

vector<function<int(int)>> byRef() {
    vector<function<int(int)>> fs;
    int i;
    for (i = 0; i < 3; ++i) fs.push_back([&](int x){ return x + i; });
    return fs;
}
vector<function<int(int)>> byVal() {
    vector<function<int(int)>> fs;
    for (int i = 0; i < 3; ++i) fs.push_back([=](int x){ return x + i; });
    return fs;
}
int main() {
    auto r = byRef(); auto v = byVal();
    cout << "C++ [&] (late-bound): ";
    for (auto& f : r) cout << f(10) << " ";
    cout << "\nC++ [=] (captured):  ";
    for (auto& f : v) cout << f(10) << " ";
    cout << endl;
}
