Object subclass: #Ride
    instanceVariableNames: 'rideID pickupLocation dropoffLocation distance'
    classVariableNames: ''
    poolDictionaries: ''
    category: 'RideShare'.

Ride >> initializeWith: id pickup: p dropoff: d distance: miles
    rideID := id.
    pickupLocation := p.
    dropoffLocation := d.
    distance := miles.

Ride >> fare
    ^ 2.0 + (1.5 * distance).

Ride >> rideDetails
    ^ 'Ride #', rideID printString, ' from ', pickupLocation, ' to ', dropoffLocation,
      ' distance ', distance printString, ' mi'.
