"=== 2.3 Driver class with Encapsulation (GNU Smalltalk) ==="

"----- Headers -----"
Object subclass: Ride         [ | rideID pickupLocation dropoffLocation distance | ].
Ride subclass:  StandardRide  [ ].
Ride subclass:  PremiumRide   [ ].
Object subclass: Driver       [ | driverID name rating assignedRides | ].

"----- Ride base + overrides -----"
Ride extend [
  initId: anId p: p d: d m: miles [
    rideID := anId. pickupLocation := p. dropoffLocation := d.
    distance := miles asFloat. ^ self
  ]
  fareNumber [ ^ (2.0 + (1.5 * distance)) asFloat ]
  format2: x [
    | cents dollars rem |
    cents := (x asFloat * 100) rounded.
    dollars := cents // 100.
    rem := cents \\ 100.
    ^ dollars asString , '.' ,
      (rem < 10 ifTrue: ['0', rem asString] ifFalse: [rem asString])
  ]
  fareString     [ ^ self format2: self fareNumber ].
  distanceString [ ^ self format2: distance ].
  details [
    ^ 'Ride #', rideID asString, ' from ', pickupLocation,
      ' to ', dropoffLocation, ' distance ', self distanceString, ' mi'
  ]
].
StandardRide extend [
  fareNumber [ ^ (2.0 + (1.8 * distance)) asFloat ].
  details    [ ^ '[Standard] ', super details ].
].
PremiumRide extend [
  fareNumber [ ^ (3.5 + (2.75 * distance)) asFloat ].
  details    [ ^ '[Premium] ',  super details ].
].

"----- Driver (encapsulation: assignedRides is private) -----"
Driver extend [
  initId: i name: n rating: r [
    driverID := i. name := n. rating := r asFloat.
    assignedRides := OrderedCollection new. ^ self
  ]
  addRide: aRide [ assignedRides add: aRide ]
  format2: x [
    | cents dollars rem |
    cents := (x asFloat * 100) rounded.
    dollars := cents // 100.
    rem := cents \\ 100.
    ^ dollars asString , '.' ,
      (rem < 10 ifTrue: ['0', rem asString] ifFalse: [rem asString])
  ]
  info [
    ^ 'Driver #', driverID asString, ' ', name,
      ' | rating ', (self format2: rating),
      ' | rides ', assignedRides size asString
  ]
  ridesCopy [ ^ assignedRides copy ]
].

"----- Demo -----"
| d r1 r2 |
Transcript show: '=== 2.3 Driver Encapsulation demo (GST) ==='; nl.
d  := Driver new initId: 1001 name: 'A. Rivera' rating: 4.9.
r1 := StandardRide new initId: 501 p: 'Station' d: 'Campus'  m: 5.0.
r2 := PremiumRide  new initId: 502 p: 'Hotel'   d: 'Convention' m: 3.6.
d addRide: r1. d addRide: r2.

Transcript show: d info; nl.
d ridesCopy do: [:r |
  Transcript show: ' - '; show: r details; show: ' | Fare $'; show: r fareString; nl ].
