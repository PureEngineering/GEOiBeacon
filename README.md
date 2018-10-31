# GEO-iBeacon
GEO-iBeacon is a Standard for encoding latitude, longitude, and height into an iBeacon standard format allowing for server-less indoor location and tracking. 

![Geo-iBeacon](https://github.com/PureEngineering/GEOiBeacon/raw/master/geoibeacon.png)


## Who Uses Size Limit

* [PureLocate](http://www.purelocate.com)

## How It Works

By encoding the center point of an area or building as the iBeacon UUID we are able to subscribe to the area for iBeacon alerts from iBeacon tags that are programmed with the Geo-iBeacon Format.  The first 6 bytes of the UUID is always encoded with 0x47 0x45 0x4F 0x4C 0x4F 0x43 "GEOLOC", the following 10 bytes are the latitude, longitude, and height of the central location. The Offset of the central location is encoded in the major and minor number fields of the standard iBeacon Data. Note that the TxPower is still used and is required for accurate location. 

![iBeacon](https://os.mbed.com/media/uploads/mbedAustin/diagramredo.png)

```
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
      doc: signed longitude units offset from the longitude center
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
```

## Usage
 
For iBeacon developers who wish to encode geo information into their iBeacon refer to the schema for encoding their data. Note that to make it useful for location within the same building, then central location/UUID needs to be the same for all iBeacons. Only the offset should be adjusted per new location. If the coverage area exceeds the offset, then choose a new logical central location for the next area. 

For app developers, you can subscribe to the central location/UUID for iBeacon events. For each iBeacon you see with that matching UUID, and then you can construct the offset to that central location using the data in the major and minor number fields. 
You can apply simple algorithms such as clamping to the strongest RSSI, or apply more advanced location methods using averaging of multiple Geo-iBeacons. Since the location information is all encoded within the Geo-iBeacon, there is no need for a central database to store/compute/retrieve your location information. This removes the need for network access and ensures privacy.  


## License

This project is licensed under the MIT License - see the [LICENSE.md](LICENSE.md) file for details
