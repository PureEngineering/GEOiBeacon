meta:
  id: geoibeacon
  title: location and offset encoded in an ibeacon beacon
  license: MIT
  endian: be
doc: |
  location encoded in an ibeacon beacon 
seq:
- id: frame
  type: frame
types:
  frame:
    seq:
    - id: uuid0
      type: u1
      doc: 'G' 
    - id: uuid1
      type: u1
      doc: 'E' 
    - id: uuid2
      type: u1
      doc: 'O' 
    - id: uuid3
      type: u1
      doc: 'L' 
    - id: uuid4
      type: u1
      doc: 'O' 
    - id: uuid5
      type: u1
      doc: 'C' 
    - id: latitude_1e7_center
      type: s4
    - id: longitude_1e7_center
      type: s4
    - id: elevation_10k_center
      type: s2
      doc: elevation in Meters with 10km offset
  #end of 16 byte UUID 
    - id: latitude_1e5_offset
      type: b12
      doc: signed latitude units offset from latitude center
    - id: longitude_1e5_offset
      type: b12 
      doc: signed longitude units offset from the longitue center
    - id: elevation_offset
      type: s8
      doc: highet offset in decimeter's
    - id: tx_power
      type: u1
      doc: The tx_power is the known measured signal strength in rssi at 1 meter away. Each iBeacon must be calibrated with this txPower value to allow accurate distance estimates
    instances:
      latitude_center:
       value:  latitude_1e7_center * 1e-7
      longitude_center:
       value:  longitude_1e7_center * 1e-7
      elevation_center:
        value:  elevation_10k_center -10000
      latitude:
       value:  latitude_center + latitude_1e5_offset * 1e5
      longitude:
       value:  longitude_center + longitude_1e5_offset * 1e5
      elevation:
        value:  elevation_center + elevation_offset/10 

