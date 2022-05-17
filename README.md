## Chat Application using Godot, Agones and Octops
This repo is a demo lobby and chat app made with [Godot](https://godotengine.org/). The deployment and the allocation of game servers is managed by [Agones](https://agones.dev/site/) sitting on top of a [Kubernetes](https://kubernetes.io) cluster running locally.

The demo shows how applications or games built with the [Godot Engine](https://godotengine.org/) can be integrated with other technologies. Specially those that makes games ready for large scale environment like [Agones](https://agones.dev/site/) and the [Octops Broadcaster HTTP](https://github.com/Octops/agones-broadcaster-http).

For more OSS projects related to gaming infrastructure check https://octops.io.

## How it works
The app uses the HTTP endpoint exposed by the [Octops Broadcaster HTTP](https://github.com/Octops/agones-broadcaster-http) to fetch information from the game servers managed by Agones. 

The broadcaster collects and exposes game server details taken from the Labels and the information relevant for the user to establish a connection to the game.

- Map/Room mode: Set by the game using the [Agones SDK](https://agones.dev/site/docs/guides/client-sdks/)
- Total connected players: Set by the game when a user joins a room
- Address and Port: Part of the game server metadata that is set by Agones

## Demo

![godot-demo](https://user-images.githubusercontent.com/12124856/168469896-135f124d-1690-4603-ac78-239963224892.gif)

Once you select a server and hit the `join` button the server changes its state to `Allocated`. The information from the game servers list is updated using the response from the [Octops Bradcaster HTTP](https://github.com/Octops/agones-broadcaster-http). That includes the amount of players connected to that room.

When the last peer leaves the room the server shutsdown automatically and Agones takes care of keeping the minimum desired number of replicas on a Ready state.


## Requirements
- [Docker](https://docs.docker.com/get-docker/): Container orchestrator
- [Kind](https://kind.sigs.k8s.io/): Kubernetes cluster running in Docker containers

## Running the cluster
This command will create a Kubernetes cluster using Kind and will deploy all the required services and components. Moreover it will build and deploy the game server backend.

```
make start
```

## Building clients
Builds clients for all the 3 main platforms: Mac, Windows and Linux. Those will be output to the `./builds/{mac,windows,linux}` folders.

```
make build-clients
```

After the build is completed, check the folder that describes your platform and execute the game client.

If you want to simulate multiples users, you can open multiples instances of the game client.