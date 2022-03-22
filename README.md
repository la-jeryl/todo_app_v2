# Todo App V2

## Table of Contents

- [About](#about)
- [Getting Started](#getting_started)
- [Usage](#usage)
- [Contributing](../CONTRIBUTING.md)

## About <a name = "about"></a>

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

## Bugs I am aware of

 - The user is not automatically logged out after the session expires (approx. 30 minutes)