#include <iostream>
#include <iomanip>
#include <algorithm>
#include <vector>
#include <memory>
using namespace std;

int main() {
    cout << "=== 2.5 System Functionality Demonstration (C++) ===\n";
    // (Driver and Rider setup)
    Driver d(9001, "A. Rivera", 4.87);
    Rider r(6001, "M. Chen");

    auto r1 = make_shared<StandardRide>(901, "Campus", "Library", 2.4);
    auto r2 = make_shared<StandardRide>(903, "Stadium", "Mall", 4.7);
    auto r3 = make_shared<PremiumRide>(902, "Airport", "Hotel", 8.1);
    auto r4 = make_shared<PremiumRide>(904, "Downtown", "Station", 3.6);

    vector<shared_ptr<Ride>> all = {r1, r2, r3, r4};
    d.addRide(r1); d.addRide(r2);
    r.requestRide(r3); r.requestRide(r4);

    double total = 0;
    for (auto& x : all) total += x->fare();
    cout << fixed << setprecision(2);
    cout << "Average fare: $" << (total / all.size()) << "\n";

    sort(all.begin(), all.end(), [](const auto& a, const auto& b) { return a->fare() < b->fare(); });
    cout << "\n-- Cheapest to most expensive --\n";
    for (auto& x : all)
        cout << "$" << x->fare() << "  " << x->rideDetails() << "\n";
}
