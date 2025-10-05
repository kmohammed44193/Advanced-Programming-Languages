#include <iostream>
#include <iomanip>
#include <string>
using namespace std;

class Ride {
protected:
    int rideID;
    string pickupLocation, dropoffLocation;
    double distance;
public:
    Ride(int id, string pickup, string dropoff, double miles)
        : rideID(id), pickupLocation(pickup), dropoffLocation(dropoff), distance(miles) {}

    virtual double fare() const { return 2.0 + 1.5 * distance; }
    virtual string rideDetails() const {
        return "[Standard] Ride #" + to_string(rideID) + " from " + pickupLocation +
               " to " + dropoffLocation + " distance " + to_string(distance) + " mi";
    }
};
