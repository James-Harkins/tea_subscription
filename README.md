# Tea Subscription Service

## Overview

This is the back end app for a hypothetical Tea Subscription app, built in Ruby on Rails. It exposes an API for database consumption by a hypothetical front end. 

## Learning Goals

* Expose an API for CRUD functionality for Customers, Subscriptions, and Teas in the database, to be consumed by a Front End App

## Endpoints

`POST /subscriptions`

This endpoint is used to create a new subscription. It requires the following parameters: `customer_id`, `title`, `price`, `frequency` and `teas`, which should contain the `id`s for whichever teas the user wishes to subscribe to:

Example Params:

```
{
   "customer_id": 1,
   "title": "Monthly Subscription",
   "price": 19.99,
   "frequency": "Monthly",
   "teas": [2, 4]
}
```

Response: 

```
{
    "data": {
        "id": "14",
        "type": "subscription",
        "attributes": {
            "title": "Monthly Subscription",
            "price": 19.99,
            "status": "Active",
            "frequency": "Monthly",
            "teas": [
                {
                    "id": 2,
                    "title": "Earl Grey",
                    "description": "It's Grey",
                    "temperature": 120,
                    "brew_time": 240,
                    "created_at": "2022-07-28T18:04:18.647Z",
                    "updated_at": "2022-07-28T18:04:18.647Z"
                },
                {
                    "id": 4,
                    "title": "English Breakfast",
                    "description": "It's English",
                    "temperature": 120,
                    "brew_time": 240,
                    "created_at": "2022-07-28T18:04:18.649Z",
                    "updated_at": "2022-07-28T18:04:18.649Z"
                }
            ]
        }
    }
}
```

`PATCH /subscriptions/:id`

This endpoint is used to update an existing subscription. It requires the parameter, `cancel`, which must be set to true, which sets the "status" value of that subscription to "canceled" in the database.

Example Params:

```
{
   cancel: true
}
```

Response:

```
{
    "data": {
        "id": "10",
        "type": "subscription",
        "attributes": {
            "title": "\"Monthly Subscription\"",
            "price": 19.99,
            "status": "Canceled",
            "frequency": "Monthly",
            "teas": []
        }
    }
}
```

`GET /customers/:id/subscriptions`

This endpoint is used to return all of a given customer's subscriptions, whether active or canceled. It does not require any parameters beyond the `customer_id`, which should be included in the URI in the request.

Response:

```
{
    "data": [
        {
            "id": "3",
            "type": "subscription",
            "attributes": {
                "title": "Uncle Jun's Monthly Subscriptions",
                "price": 29.99,
                "status": "Active",
                "frequency": "Monthly",
                "teas": [
                    {
                        "id": 1,
                        "title": "Green",
                        "description": "It's Green",
                        "temperature": 120,
                        "brew_time": 240,
                        "created_at": "2022-07-28T18:04:18.646Z",
                        "updated_at": "2022-07-28T18:04:18.646Z"
                    }
                ]
            }
        }
    ]
}
```

## Database Schema

![image](https://user-images.githubusercontent.com/93609855/181612413-2fd46628-580e-4c77-af04-c8d042f69276.png)
