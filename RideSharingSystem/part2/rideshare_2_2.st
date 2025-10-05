"=== 2.2 Subclasses & Polymorphism (GNU Smalltalk) ==="

"----- Headers -----"
Object subclass: Ride         [ | rideID pickupLocation dropoffLocation distance | ].
Ride subclass:  StandardRide  [ ].
Ride subclass:  PremiumRide   [ ].

"----- Base methods -----"
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

"----- Overrides (polymorphism) -----"
StandardRide extend [
  fareNumber [ ^ (2.0 + (1.8 * distance)) asFloat ].
  details    [ ^ '[Standard] ', super details ].
].
PremiumRide extend [
  fareNumber [ ^ (3.5 + (2.75 * distance)) asFloat ].
  details    [ ^ '[Premium] ', super details ].
].

"----- Demo -----"
| rides |
Transcript show: '=== 2.2 Subclasses & Polymorphism demo (GST) ==='; nl.
rides := OrderedCollection new.
rides add: (StandardRide new initId: 301 p: 'Station' d: 'Campus' m: 5.0).
rides add: (PremiumRide  new initId: 302 p: 'Hotel'   d: 'Convention' m: 3.6).
rides add: (StandardRide new initId: 303 p: 'Mall'    d: 'Airport' m: 12.4).

rides do: [:r |
  Transcript show: ' - '; show: r details;
  show: ' | Fare $'; show: r fareString; nl ].
