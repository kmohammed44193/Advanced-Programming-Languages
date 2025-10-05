#include <iostream>
#include <vector>
#include <memory>
#include <string>
using namespace std;

class Ride { /* from 2.2 */ };

class Driver {
private:
    int driverID;
    string name;
    double rating;
    vector<shared_ptr<Ride>> assignedRides;
public:
    Driver(int id, string n, double r) : driverID(id), name(n), rating(r) {}

    void addRide(shared_ptr<Ride> r) { assignedRides.push_back(r); }
    string getDriverInfo() const {
        return "Driver #" + to_string(driverID) + " " + name + " | rating " + to_string(rating);
    }
    vector<shared_ptr<Ride>> rides() const { return assignedRides; }
};
