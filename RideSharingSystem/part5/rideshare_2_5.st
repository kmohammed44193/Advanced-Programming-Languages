"=== 2.5 System Functionality (GNU Smalltalk) ==="

"----- Headers -----"
Object subclass: Ride         [ | rideID pickupLocation dropoffLocation distance | ].
Ride subclass:  StandardRide  [ ].
Ride subclass:  PremiumRide   [ ].
Object subclass: Driver       [ | driverID name rating assignedRides | ].
Object subclass: Rider        [ | riderID name requestedRides | ].

"----- Ride base -----"
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

"----- Overrides -----"
StandardRide extend [
  fareNumber [ ^ (2.0 + (1.8 * distance)) asFloat ].
  details    [ ^ '[Standard] ', super details ].
].
PremiumRide extend [
  fareNumber [ ^ (3.5 + (2.75 * distance)) asFloat ].
  details    [ ^ '[Premium] ',  super details ].
].

"----- Driver -----"
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

"----- Rider -----"
Rider extend [
  initId: i name: n [
    riderID := i. name := n. requestedRides := OrderedCollection new. ^ self
  ]
  requestRide: aRide [ requestedRides add: aRide ]
  info [
    ^ 'Rider #', riderID asString, ' ', name,
      ' | requests ', requestedRides size asString
  ]
  ridesCopy [ ^ requestedRides copy ]
].

"----- Demo (full system) -----"
| all d r total count |
Transcript show: '=== 2.5 System Functionality (GST) ==='; nl.

all := OrderedCollection new.
all add: (StandardRide new initId: 901 p: 'Campus'   d: 'Library'  m: 2.4).
all add: (PremiumRide  new initId: 902 p: 'Airport'  d: 'Hotel'    m: 8.1).
all add: (StandardRide new initId: 903 p: 'Stadium'  d: 'Mall'     m: 4.7).
all add: (PremiumRide  new initId: 904 p: 'Downtown' d: 'Station'  m: 3.6).

d := Driver new initId: 5001 name: 'A. Rivera' rating: 4.86.
d addRide: (all at: 1). d addRide: (all at: 3).

r := Rider new initId: 6001 name: 'M. Chen'.
r requestRide: (all at: 2). r requestRide: (all at: 4).

Transcript show: '-- Mixed rides (polymorphic) --'; nl.
total := 0.0. count := 0.
all do: [:x |
  Transcript show: ' - '; show: x details; show: ' | Fare $'; show: x fareString; nl.
  total := total + x fareNumber. count := count + 1.
].
Transcript show: 'Average fare: $'; show: ((Ride new) format2: (total / count)); nl.

Transcript show: '-- Driver --'; nl.
Transcript show: d info; nl.
d ridesCopy do: [:x | Transcript show: '   * '; show: x details; show: ' | Fare $'; show: x fareString; nl ].

Transcript show: '-- Rider --'; nl.
Transcript show: r info; nl.
r ridesCopy do: [:x | Transcript show: '   * '; show: x details; show: ' | Fare $'; show: x fareString; nl ].
