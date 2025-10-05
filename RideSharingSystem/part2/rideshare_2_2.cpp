#include <iostream>
#include <iomanip>
#include <memory>
#include <vector>
using namespace std;

class Ride { /* (same as 2.1) */ };

class StandardRide : public Ride {
public:
    using Ride::Ride;
    double fare() const override { return 2.0 + 1.5 * distance; }
};

class PremiumRide : public Ride {
public:
    using Ride::Ride;
    double fare() const override { return 3.5 + 2.75 * distance; }
};

int main() {
    cout << "=== 2.2 Subclasses & Polymorphism Demo ===\n";
    vector<shared_ptr<Ride>> rides = {
        make_shared<StandardRide>(301, "Station", "Campus", 5.0),
        make_shared<PremiumRide>(302, "Hotel", "Convention", 3.6),
        make_shared<StandardRide>(303, "Mall", "Airport", 12.4)
    };

    for (auto& r : rides)
        cout << "- " << r->rideDetails() << " | Fare $" << fixed << setprecision(2) << r->fare() << "\n";
}
