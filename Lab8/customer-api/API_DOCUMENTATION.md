# Customer API Documentation

## Base URL

`http://localhost:8080/api/customers`

## Endpoints

### 1. Get All Customers

**GET** `/api/customers`

**Response:** 200 OK

```json
[
    {
        "id": 1,
        "customerCode": "C001",
        "fullName": "John Partially Updated",
        "email": "john.updated@example.com",
        "phone": "+12225559999",
        "address": "New Address",
        "status": "ACTIVE",
        "createdAt": "2025-12-12T15:58:53"
    },

    {
        "id": 2,
        "customerCode": "C001",
        ...
    },
    ...
]
```

### 2. Get Customers by ID

**GET** `/api/customers/{id}`

**Response:** 200 OK

```json
{
  "id": 2,
  "customerCode": "C002",
  "fullName": "Jane Smith",
  "email": "jane.smith@example.com",
  "phone": "+1-555-0102",
  "address": "456 Oak Ave, Los Angeles",
  "status": "ACTIVE",
  "createdAt": "2025-12-12T15:58:53"
}
```

**Error Response:** 404 Not Found

```json
{
  "timestamp": "2025-12-12T16:58:25.3292508",
  "status": 404,
  "error": "Not Found",
  "message": "Customer not found with id: 7",
  "path": "/api/customers/7",
  "details": null
}
```

### 3. Create Customer

**POST** `/api/customers`

**Request Body:**

```json
{
  "customerCode": "C006",
  "fullName": "David Miller",
  "email": "david.miller@example.com",
  "phone": "+15550106086",
  "address": "999 Broadway, Seattle, WA 98101"
}
```

**Success Response:** 201 Created

```json
{
  "id": 6,
  "customerCode": "C006",
  "fullName": "David Miller",
  "email": "david.miller@example.com",
  "phone": "+15550106086",
  "address": "999 Broadway, Seattle, WA 98101",
  "status": "ACTIVE",
  "createdAt": "2025-12-12T17:02:29.5573694"
}
```

**Error Response:** 400 Bad Request (Validation Error)

```json
{
  "timestamp": "2025-12-12T17:03:54.4782896",
  "status": 400,
  "error": "Validation Failed",
  "message": "Invalid input data",
  "path": "/api/customers",
  "details": [
    "customerCode: Customer code must start with C followed by numbers",
    "phone: Invalid phone number format"
  ]
}
```

**Error Response:** 409 Conflict (Duplicate Resource)

```json
{
  "timestamp": "2025-12-12T17:04:52.8985445",
  "status": 409,
  "error": "Conflict",
  "message": "Customer code already exists: C001",
  "path": "/api/customers",
  "details": null
}
```

### 4. Update Customer

**PUT** `/api/customers/{id}`

**Request Body:**

```json
{
  "customerCode": "C006",
  "fullName": "David Miller Jr.",
  "email": "david.miller.jr@example.com",
  "phone": "+15550106086",
  "address": "1000 Broadway, Seattle, WA 98101"
}
```

**Success Response:** 200 OK

```json
{
  "id": 6,
  "customerCode": "C006",
  "fullName": "David Miller Jr.",
  "email": "david.miller.jr@example.com",
  "phone": "+15550106086",
  "address": "1000 Broadway, Seattle, WA 98101",
  "status": "ACTIVE",
  "createdAt": "2025-12-12T17:02:30"
}
```

**Error Response:** 404 Not Found

```json
{
  "timestamp": "2025-12-12T17:07:00.6730846",
  "status": 404,
  "error": "Not Found",
  "message": "Customer not found with id: 45",
  "path": "/api/customers/45",
  "details": null
}
```

**Error Response:** 409 Conflict (Duplicate Email)

```json
{
  "timestamp": "2025-12-12T17:07:34.8917766",
  "status": 409,
  "error": "Conflict",
  "message": "Email already exists: bob.johnson@example.com",
  "path": "/api/customers/6",
  "details": null
}
```

### 5. Delete Customer

**DELETE** `/api/customers/{id}`

**Success Response:** 200 OK

```json
{
  "message": "Customer deleted successfully"
}
```

**Error Response:** 404 Not Found

```json
{
  "timestamp": "2025-12-12T17:08:11.0600586",
  "status": 404,
  "error": "Not Found",
  "message": "Customer not found with id: 54",
  "path": "/api/customers/54",
  "details": null
}
```

### 6. Search Customers

**GET** `/api/customers/search?keyword={keyword}`

**Success Response:** 200 OK

```json
[
  {
    "id": 1,
    "customerCode": "C001",
    "fullName": "John Partially Updated",
    "email": "john.updated@example.com",
    "phone": "+12225559999",
    "address": "New Address",
    "status": "ACTIVE",
    "createdAt": "2025-12-12T15:58:53"
  },
  {
    "id": 3,
    "customerCode": "C003",
    "fullName": "Bob Johnson",
    "email": "bob.johnson@example.com",
    "phone": "+1-555-0103",
    "address": "789 Pine Rd, Chicago",
    "status": "ACTIVE",
    "createdAt": "2025-12-12T15:58:53"
  }
]
```

### 7. Get Customers by Status

**GET** `/api/customers/status/{status}`

**Success Response:** 200 OK

```json
[
  {
        "id": 1,
        "customerCode": "C001",
        "fullName": "John Partially Updated",
        "email": "john.updated@example.com",
        "phone": "+12225559999",
        "address": "New Address",
        "status": "ACTIVE",
        "createdAt": "2025-12-12T15:58:53"
    },
    {
        "id": 2,
        "customerCode": "C002",
        "fullName": "Jane Smith",
        "email": "jane.smith@example.com",
        "phone": "+1-555-0102",
        "address": "456 Oak Ave, Los Angeles",
        "status": "ACTIVE",
        "createdAt": "2025-12-12T15:58:53"
    },
    ...
]
```

**Error Response:** 500 Internal Server Error

```json
{
  "timestamp": "2025-12-12T17:10:21.0991293",
  "status": 500,
  "error": "Internal Server Error",
  "message": "Method parameter 'status': Failed to convert value of type 'java.lang.String' to required type 'com.example.customer_api.entity.CustomerStatus'; Failed to convert from type [java.lang.String] to type [@org.springframework.web.bind.annotation.PathVariable com.example.customer_api.entity.CustomerStatus] for value [ACTIVEa]",
  "path": "/api/customers/status/ACTIVEa",
  "details": null
}
```

---

## HTTP Status Code Reference

### Success Codes

- **200 OK**: Request succeeded (GET, PUT, DELETE operations)
- **201 Created**: Resource successfully created (POST operations)

### Client Error Codes

- **400 Bad Request**: Invalid request data or validation failed
  - Missing required fields
  - Invalid data format (email, phone, customer code pattern)
  - Field length constraints violated
- **404 Not Found**: Requested resource does not exist
  - Customer ID not found
  - Invalid endpoint
- **409 Conflict**: Resource conflict detected
  - Duplicate customer code
  - Duplicate email address

### Server Error Codes

- **500 Internal Server Error**: Unexpected server-side error
  - Database connection issues
  - Unhandled exceptions
  - System errors

---

## Validation Rules

### Customer Code

- **Required**: Yes
- **Pattern**: Must start with 'C' followed by 3 or more digits (e.g., C001, C1234)
- **Length**: 3-20 characters

### Full Name

- **Required**: Yes
- **Length**: 2-100 characters

### Email

- **Required**: Yes
- **Format**: Valid email format
- **Unique**: Must be unique across all customers

### Phone

- **Required**: No
- **Pattern**: 10-20 digits, optionally starting with '+'
- **Example**: +15550103, 15550103

### Address

- **Required**: No
- **Max Length**: 500 characters

### Status

- **Values**: ACTIVE, INACTIVE
- **Default**: ACTIVE
