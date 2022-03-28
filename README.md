# Todo App V2

## About

This is the 2nd iteration of the Todo App as part of my onboarding process with LawAdvisors Ventures.
This readme file is still a work in progress and I intend to put my thoughts and decisions I made on this readme file.

## My Idea about the Program

I imagine the app having 2 sub apps:
 - Client - Liveview frontend
 - Todo API - stores the Users, Lists and Todos tables

For the Todo API, I made the following routes available:
 - GET - /lists
 - GET POST PUT DELETE - /lists/:list_id
 - GET - /lists/:id/todos
 - GET POST PUT DELETE - /lists/:id/todos/:todo_id
 - POST - /api/registration
 - POST DELETE - /api/session
 - POST - /api/session/renew

For the Client, I decided to 
  - create the liveview app from scratch
  - use pow for the user logins
  - use tesla as the http toolkit

## My Progress

Here are the mix commands I used to create the projects:
* Todo API:
    - mix phx.new todo_api --no-html --no-assets --no-live --no-dashboard
    - mix phx.gen.json Lists List lists user_id:integer list_name:string
* Client:
    - mix phx.new todo_client

I was able to finish the version 2 of the Todo API plus along with the tests on both the APIs and Controllers of Todos and Lists.

Implemented the changes suggested by Ken and Pao.

Docker is now working.

## Running the project

1. Go to todo_client directory and then run the following commands:
  - docker-compose build
  - docker-compose up
2. Do the same thing in the client directory
3. In case an error is encountered regarding post
4. Open a separate tab for todo_client and client directories, and then run the following command:
  - docker-compose exec todoclient mix ecto.setup
  - docker-compose exec todoapi mix ecto.setup
  
  \* Note: todoclient and todoapi are the name of the services in the respective docker-compose.yml files.

Optional Steps in case client is not able to communicate with todo_api:
1. While the docker containers are up, run the command below and get the container ids
  - docker ps
2. Run the following command to check if client can ping todo_api:
  - docker exec [client container id] ping [todo_api container id] -c2

  Running the command will show something like:

  PING 70886e53cc97 (192.168.64.2): 56 data bytes
  64 bytes from 192.168.64.2: seq=0 ttl=64 time=0.060 ms
  64 bytes from 192.168.64.2: seq=1 ttl=64 time=0.079 ms

  --- 70886e53cc97 ping statistics ---
  2 packets transmitted, 2 packets received, 0% packet loss
  round-trip min/avg/max = 0.060/0.069/0.079 ms

  Copy the ip address of the todo_api (i.e. 192.168.64.2)

3. Go to client > lib > client, and open the following files:
  - sessions.ex
  - registrations.ex
  - todos.ex
  - lists.ex
2. Replace http://localhost:4000 with the ip address (i.e. 192.168.64.2:4000)
3. Run the following commands in client directory:
  - docker-compose build
  - docker-compose up

## Bugs I am aware of

 - The user is not automatically logged out after the session expires (approx. 30 minutes)