# Backend
This document will cover the basics of our backend architecture as well as describe the various modules and subdirectories within the NodeJS app.

---

## General Idea

Our backend is a NodeJS application running an Express server. The main landing point for our app is within the `app.js` file. The server is configured within the `server.js` file.

---

## App

The main app file handles all the necessary configurations for our NodeJS app — including initializing routes, express, and basic logging. This is the central landing point for all incoming traffic.

---

## Server

The main server logic is handled within `server.js` and — as of now — simply configures our ports and enables listeners.

---

## Features

The following features have been created:

```bash
features/
├── expense-splits/
├── expenses/
├── house-members/
├── houses/
├── users/
└── README.md
```

Within each of these features sub-directories, the following files can be found:

```bash
features/
├── controller.js  # Handles the main logic for the endpoint
├── router.js      # Handles the routes (API endpoints)
└── validator.js   # Validates the HTTP payload and headers
```

Each feature contains the following routes:

```bash
POST <feature>/
PATCH <feature>/:id
GET <feature>/
GET <feature>/:id
DELETE <feature>/:id
```

This ables us to access methods to create, read, update, and delete the data from the client side application. 

The `controller.js` file contains the actual logic that we use to connect and manipulate our database. We separate these methods to increase modularity and allow for a simpler system for testing.

Before accessing the main controller, the request is passed through our custom validators (inside `validator.js`). This allows us to have a single layer of security to ensure correct input validation. Upon validation, the request is passed into the controller. Without proper validation, an error will be thrown.
