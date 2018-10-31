meta:
  id: geoeddystone
  title: location and offset encoded in an an eddystone uid beacon
  license: MIT
  endian: be
doc: |
  GEO-eddystone is a Standard for encoding latitude, longitude, and height into an iBeacon standard format allowing for server-less indoor location and tracking in an eddystone beacon 
seq:
- id: frame
  type: frame
types:
  frame:
    seq:
    - id: frame_type
      type: u1
      doc: eddystone-uid format
    - id: ranging_data
      type: u1
      doc: calibrated tx power at 0 m	
    - id: latitude_1e7_center
      type: s4
    - id: longitude_1e7_center
      type: s4
    - id: elevation_10k_center
      type: s2
      doc: elevation in meters with 10km offset
  #end of 10 byte namespace. 
    - id: latitude_1e6_offset
      type: s2
      doc: latitude units offset from latitude center
    - id: longitude_1e6_offset
      type: s2
      doc: longitude units offset from the longitue center
    - id: elevation_offset
      type: s2
      doc: highet offset in cm
    - id: reserved0
      type: u1
      doc: reserved for future use, must be 0x00
    - id: reserved1
      type: u1
      doc: reserved for future use, must be 0x00
    instances:
      latitude_center:
       value:  latitude_1e7_center * 1e-7
      longitude_center:
       value:  longitude_1e7_center * 1e-7
      elevation_center:
        value:  elevation_10k_center -10000
      latitude:
       value:  latitude_center + latitude_1e6_offset * 1e6
      longitude:
       value:  longitude_center + longitude_1e6_offset * 1e6
      elevation:
        value:  elevation_center + elevation_offset/100 
