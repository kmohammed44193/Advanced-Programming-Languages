"=== 2.4 Rider class (GNU Smalltalk) ==="

"----- Headers -----"
Object subclass: Ride   [ | rideID pickupLocation dropoffLocation distance | ].
Object subclass: Rider  [ | riderID name requestedRides | ].

"----- Ride -----"
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

"----- Rider (encapsulation: requestedRides is private) -----"
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

"----- Demo -----"
| rd r1 r2 |
Transcript show: '=== 2.4 Rider class demo (GST) ==='; nl.
rd := Rider new initId: 7001 name: 'M. Chen'.
r1 := Ride new initId: 801 p: 'Campus' d: 'Library' m: 2.4.
r2 := Ride new initId: 802 p: 'Mall'   d: 'Stadium' m: 6.3.
rd requestRide: r1. rd requestRide: r2.

Transcript show: rd info; nl.
rd ridesCopy do: [:r |
  Transcript show: ' - '; show: r details; show: ' | Fare $'; show: r fareString; nl ].
