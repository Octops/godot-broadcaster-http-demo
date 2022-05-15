## Godot broadcaster-http demo
This repo is a demo lobby and chat app made with Godot, hosted using Agones and using [Octops agones-broadcaster-http](https://github.com/Octops/agones-broadcaster-http) to fetch game servers information


## Demo

![godot-demo](https://user-images.githubusercontent.com/12124856/168469896-135f124d-1690-4603-ac78-239963224892.gif)


## Requirements
- Docker

## Running the cluster
```
make start
```

## Building clients
```
make build-clients
```

## How it works?
The app uses [Octops agones-broadcaster-http](https://github.com/Octops/agones-broadcaster-http) to fetch rooms running in agones and their attributes like:
- Amount of connected players
- Map/Room mode
- Address
- Port

Once you select a server and hit the `join` button the server changes its state to `Allocated` and that is reflected in [Octops agones-broadcaster-http](https://github.com/Octops/agones-broadcaster-http) as well as the amount of players connected to that room.

When the last peer leaves the server the server shutsdown automatically and the Agones `Fleet` takes care of keeping your MinReady replicas up to date
