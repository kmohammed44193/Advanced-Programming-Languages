#include <iostream>
#include <vector>
#include <memory>
using namespace std;

class Ride { /* from 2.3 */ };

class Rider {
private:
    int riderID;
    string name;
    vector<shared_ptr<Ride>> requestedRides;
public:
    Rider(int id, string n) : riderID(id), name(n) {}
    void requestRide(shared_ptr<Ride> r) { requestedRides.push_back(r); }
    string getRiderInfo() const { return "Rider #" + to_string(riderID) + " " + name + " | requests " + to_string(requestedRides.size()); }
    vector<shared_ptr<Ride>> rides() const { return requestedRides; }
};
