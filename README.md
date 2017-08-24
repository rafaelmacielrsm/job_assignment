# API endpoint documentation #
## 1. General ##
### 1.1. Root url ###
This api has a subdomain constraint, that means that the base url will look like:

    http://api.<domain_name>/

#### 1.1.1. In a development environment ###
##### Using Prax ####
```
http://api.zssn.dev/
```
##### Without Prax
```
http://api.lvh.me:3000/
```
------------
### 1.2. Required headers
| header | value |
| ------------ | ------------ |
| Content-Type | application/vnd.api+json |
| Accept | application/vnd.api+json |

#### 1.2.1. Response error in case these headers are not present
- Code: **415 - Unsupported Media Type**
- Code: **406 - Not Acceptable**
------------
## 2. Survivors
### 2.1. Create
##### Url: `/survivors`

##### Method: `POST`

##### URL Params `None`

##### Data Params
```json
{
  "survivor": {
		"name": <String>,
		"age": [Number greater or equal to zero and Integer],
		"gender": [String],
		"latitude": [Decimal¹ number between -90 and 90],
    "longitude": [Decimal¹ number between -180 and 180],
    "inventory": {
				"water": [Integer greater or equal to 0],
				"food": [Integer greater or equal to 0],
				"medication": [Integer greater or equal to 0],
				"ammunition": [Integer greater or equal to 0]
		}
	}
}

Decimal¹: Must use a .(dot) as decimal mark
```
**Complete example:**
```json
{
  "survivor": {
		"name": "John Doe",
		"age": 25,
		"gender": "male",
		"latitude":  -15.7996 ,
    "longitude":  -47.8634 ,
    "inventory": {
				"water": 2,
				"food": 3,
				"medication": 2,
				"ammunition": 3
		}
	}
}
```

##### Success Response

- **Code:** `201 - Created`
- **Body:**
```json
{
    "data": {
        "id": "2",
        "type": "survivors",
        "attributes": {
            "name": "John Doe",
            "age": 25,
            "gender": "male",
            "latitude": "-15.7996",
            "longitude": "-47.8634",
            "inventory": {
                "water": 2,
                "food": 3,
                "medication": 2,
                "ammunition": 3
            }
        }
    }
}
```
##### Error Response
- **Code:** `422 - Unprocessable Entity`
- **Body:**

```json
{
    "errors": {
        "name": [
            "can't be blank"
        ],
        "age": [
            "must be an integer"
        ],
        "gender": [
            "can't be blank"
        ],
        "latitude": [
            "must be greater than or equal to -90"
        ],
        "longitude": [
            "must be greater than or equal to -180"
        ],
        "items": [
            {
                "water": "Quantity must be greater than or equal to 0",
                "food": "Quantity must be greater than or equal to 0",
                "medication": "Quantity must be greater than or equal to 0",
                "ammunition": "Quantity must be an integer"
            }
        ]
    }
}
```
------------
### 2.2. Update Location
##### Url: `/survivors/:id`

##### Method: `PUT/PATCH`

##### URL Params
- Required:
  `id - [integer]`

##### Data Params
```json
{
  "survivor": {
		"latitude": [Decimal¹ number between -90 and 90],
    "longitude": [Decimal¹ number between -180 and 180]
}

Decimal¹: Must use a .(dot) as decimal mark
```
**Complete example:**
```json
{
	"survivor": {
		"latitude":  51.7996 ,
    "longitude":  88.8634
	}
}
```

##### Success Response

- **Code:** `200 - OK`
- **Body:**
```json
{
    "data": {
        "id": "2",
        "type": "survivors",
        "attributes": {
            "name": "John Doe",
            "age": 25,
            "gender": "male",
            "latitude": "51.7996",
            "longitude": "88.8634",
            "inventory": {
                "water": 2,
                "food": 3,
                "medication": 2,
                "ammunition": 3
            }
        }
    }
}
```
##### Error Response
- Error in the data parameters
  - **Code:** `422 - Unprocessable Entity`
  - Body:
```json
{
    "errors": {
        "latitude": [
            "is not a number"
        ],
        "longitude": [
            "must be less than or equal to 180"
        ]
    }
}
```

- **Error in the url parameters**
  - **Code:** `404 - Not Found`
  - Body:
```json
null
```

------------
## 3. Report an Infected Survivor
### 3.1. Create InfectionReport
##### Url: `/survivors/:survivor_id/infection_reports/`

##### Method: `POST`

##### URL Params
- Required:
  `survivor_id - [integer]`

##### Data Params
```json
{
	"infection_report": {
		"infected_id":  [integer]
	}
}

Decimal¹: Must use a .(dot) as decimal mark
```
**Complete example:**
```json
{
	"infection_report": {
		"infected_id":  1
	}
}
```

##### Success Response

- **Code:** `201 - Created`
- **Body:**
```json
{
    "data": {
        "id": "1",
        "type": "infection-reports",
        "relationships": {
            "survivor": {
                "data": {
                    "id": "2",
                    "type": "survivors"
                }
            },
            "infected-survivor": {
                "data": {
                    "id": "1",
                    "type": "survivors"
                }
            }
        }
    }
}
```
##### Error Response
- Error in the data parameters
  - **Code:** `422 - Unprocessable Entity`
  - Body -
```json

## When reporting an invalid survivor ##
{
    "errors": {
        "reported_survivor": [
            "must exist"
        ]
    }
}

## When trying to report self ##
{
    "errors": {
        "infected_id": [
            "can't flag yourself as an infected"
        ]
    }
}

## When Reporting someone who has been already flagged by the survivor ##
{
    "errors": {
        "infected_id": [
            "has already been reported"
        ]
    }
}
```

- **Error in the url parameters**
  - **Code:** `404 - Not Found`
  - Body:
```json
null
```

------------
## 4. Trades
### 4.1. Create a Trade
##### Url: `/survivors/:survivor_id/trades/`

##### Method: `POST`

##### URL Params
- Required:
  `survivor_id - [integer]`

##### Data Params
```json
{
	"trade":
    {
      "offer":
        {
          "items":
            {
              "water": [integer],
              "food": [integer],
              "medication": [integer],
              "ammunition": [integer]
            }
        },
	    "for":
        {
          "survivor_id": [integer],
          "items":
            {
              "water": [integer],
              "food": [integer],
              "medication": [integer],
              "ammunition": [integer]
            }
        }
    }
}
```
**Complete example:**
```json
{
	"trade":
    {
      "offer":
        {
          "items":
            {
              "water": 1,
              "food": 1,
              "medication": 1
            }
        },
	    "for":
        {
          "survivor_id": 1,
          "items":
            {
              "ammunition": 9
            }
        }
    }
}
```

##### Success Response

- **Code:** `201 - Created`
- **Body:**
```json
{
    "data": {
        "id": "2",
        "type": "survivors",
        "attributes": {
            "name": "John Doe",
            "age": 25,
            "gender": "male",
            "latitude": "55.7996",
            "longitude": "-32.8634",
            "inventory": {
                "water": 1,
                "food": 2,
                "medication": 1,
                "ammunition": 11
            }
        }
    }
}
```
##### Error Response
- Error in the data parameters
  - **Code:** `422 - Unprocessable Entity`
  - Body -
```json
## When the target survivor does not exist or is infected ##
{
    "errors": {
        "for": {
            "survivor_id": [
                "Survivor does not exist"
            ]
        }
    }
}

## When any of the items list is empty ##
{
    "errors": {
        "offer": {
            "items": [
                "Empty item-list is not allowed"
            ]
        },
        "for": {
            "items": [
                "Empty item-list is not allowed"
            ]
        }
    }
}

## When the item list has an invalid item ##
{
    "errors": {
        "offer": {
            "items": [
                "There is an invalid item in the list"
            ]
        },
        "for": {
            "items": [
                "There is an invalid item in the list"
            ]
        }
    }
}

## When the lists aren't worth the same ##
{
    "errors": {
        "for": {
            "items": [
                "Invalid Offer, the items offered and received do not worth the same"
            ]
        }
    }
}

## When attempting to trade with self ##
{
    "errors": {
        "for": {
            "survivor_id": [
                "not allowed to trade with self"
            ]
        }
    }
}
## When there are not enough items to complete the trade ##
{
    "errors": {
        "offer": {
            "items": [
                {
                    "medication": "Not enough items, only 0 available"
                }
            ]
        },
        "for": {
            "items": [
                {
                    "water": "Not enough items, only 3 available"
                }
            ]
        }
    }
}
```


- **Error in the url parameters**
  - **Code:** `404 - Not Found`
  - Body:
```json
null
```

------------
## 5. System Reports
### 5.1. Index - All Report urls
##### Url: `/reports/`

##### Method: `GET`

##### URL Params `None`

##### Data Params `None`

##### Success Response

- **Code:** `200 - Ok`
- **Body:**
```json
{
    "data": "null",
    "links": [
        "http://api.<domain_name>/reports/infected",
        "http://api.<domain_name>/reports/non_infected",
        "http://api.<domain_name>/reports/inventories_overview",
        "http://api.<domain_name>/reports/resources_lost"
    ]
}
```

------------
### 5.2. Infected Survivors Report
##### Url: `/reports/infected`

##### Method: `GET`

##### URL Params `None`

##### Data Params `None`

##### Success Response

- **Code:** `200 - Ok`
- **Body:**
```json
{
    "data": {
        "report": {
            "details": "This number represents the percentage of infected survivors in relation to the total of registered survivors.",
            "value": 0.2
        }
    }
}
```

------------
### 5.3. Non Infected Survivors Report
##### Url: `/reports/non_infected`

##### Method: `GET`

##### URL Params `None`

##### Data Params `None`

##### Success Response

- **Code:** `200 - Ok`
- **Body:**
```json
{
    "data": {
        "report": {
            "details": "This number represents the percentage of non infected survivors in relation to the total of registered survivors.",
            "value": 0.8
        }
    }
}
```

------------
### 5.4. Average of each type item in pocession of non-infected survivors
##### Url: `/reports/inventories_overview`

##### Method: `GET`

##### URL Params `None`

##### Data Params `None`

##### Success Response

- **Code:** `200 - Ok`
- **Body:**
```json
{
    "data": {
        "report": {
            "details": "This report contains the average amount of each type of item that are in the non-infected survivors' inventories",
            "value": {
                "water": 2.5,
                "food": 3,
                "medication": 1.25,
                "ammunition": 2
            }
        }
    }
}
```

------------
### 5.5. The sum of points of every resource in possession of infected survivors
##### Url: `/reports/resources_lost`

##### Method: `GET`

##### URL Params `None`

##### Data Params `None`

##### Success Response

- **Code:** `200 - Ok`
- **Body:**
```json
{
    "data": {
        "report": {
            "details": "This report represents the values in points of all resources that were lost because their owner are infected",
            "value": 24
        }
    }
}
```
