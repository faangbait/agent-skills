---
name: officerequest-definition
description: Maps `OfficeRequest` wire data to the exact office the user wants.
metadata:
  type: project
paths:
  - "src/office.rs"
  - "src/routes.rs"
---

# Office Wire Types

## OfficeRequest

```rs
pub struct OfficeRequest {
  temperature: [f16; 2]
  free_parking: Option<Vehicle>
  nearby_coworkers: Option<u8>
}
```

### temperature

Wanted office temperature in Fahrenheit.

Shape is:

`[minimum, maximum]`

### free_parking

Vehicle that needs free parking.

Backend must not return an `Office` unless that office can park this `Vehicle` for free.

### nearby_coworkers

Wanted count of nearby coworkers.

`None` is missing data, not zero. Do not invent a default.

## OfficeResult

Backend returns:

```rs
OfficeResult {
  office_choices: Option<Vec<usize>>
}
```

### office_choices

Matching office IDs.

`None` means backend returned no office list.

## OfficeError

Do not retry:

- **500 Internal Server Error**: Bad `OfficeSearch` result. Payload shape is malformed.
- **501 Not Implemented**: Requested unavailable office, like on moon.

May retry:

- **422 Unprocessable Entity**: Payload shape is valid, but data is invalid. Example: `nearby_coworkers = -1`.
- **418 I'm a teapot**: Client sent `BeverageRequest` to `OfficeRequest` endpoint. Server respond with joke. See `memory/beveragerequest-definition.md`

