## Project Overview

This repository contains a production‑ready Ruby application that processes a user’s itinerary reservations and outputs a human‑readable trip summary. The core flow is:
1. Validate command‑line arguments.
2. Load and parse the input file.
3. Detect trips by chaining transports and stays.
4. Serialize the resulting trips to human‑readable format.
5. Output the result to the console.

## Prerequisites

Before building and running the app with Docker, ensure you have the following installed:

- [Docker](https://www.docker.com/get-started)

## Steps to build and run the App

1. **Clone the repository**

2. **Build the Docker image:** Use the following command to build the Docker image for the app:
    ```
    docker build -t itinerary-app .
    ```
3. **Run the Docker container:** After building the image, you can run the container using the following command:
    ```
    docker run --rm -e BASED=SVQ itinerary-app bundle exec ruby main.rb input.txt
    ```
    to get the desired output for this technical challenge.
    If you want to run the app with a different input file, replace `input.txt` with the path to your desired input file.
    For example, you may try `complex_input.txt` to see how the app handles more complex scenarios as:
    ```
    docker run --rm -e BASED=MAD itinerary-app bundle exec ruby main.rb complex_input.txt
    ```

## Considerations
- I have assumed that other transportation types such as trains are subject to the same rules as flights, with a maximum time difference of 24 hours for connections.
- More than one chained connection is allowed, as long as the time difference is within 24 hours.
- Stays can be connected to other stays, depending on their date of arrival and departure dates.
- There are some edge cases that are not handled, such as:
  - If a transport's start date is early in the morning so that the stay's departure date is the day before, such transport will not be connected to the stay.
  - If a transport's arrival date is late in the evening so that the stay's start date is the morning after, such stay will not be connected to the transport.
