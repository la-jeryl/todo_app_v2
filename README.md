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
 - Todo Client - stores the Users tables
 - Todo API - stores the Lists and Todos tables

![Alt text](/readme_assets/Todo%20App%20V2%20Design%20Idea.png?raw=true "Todo App V2 Design Idea")

Here's my plan for the Todo API:
 - GET - /lists
 - GET POST PUT DELETE - /lists/:list_id
 - GET - /lists/:id/todos
 - GET POST PUT DELETE - /lists/:id/todos/:todo_id

 For the Todo Client, I decided to 
  - create the liveview app from scratch 
  - use Tailwind CSS
  - use phx.gen.auth for the user logins

## My Progress

Here are the mix commands I used to create the projects:
* Todo API:
    - mix phx.new todo_api --no-html --no-assets --no-live --no-dashboard
    - mix phx.gen.json Lists List lists user_id:integer list_name:string
* Todo Client:
    - mix phx.new todo_client

I was able to finish the version 2 of the Todo API plus along with the tests on both the APIs and Controllers of Todos and Lists.

For the Todo Client, I created it as a bare project and also added tailwind css.

## Getting Started <a name = "getting_started"></a>

These instructions will get you a copy of the project up and running on your local machine for development and testing purposes. See [deployment](#deployment) for notes on how to deploy the project on a live system.

### Prerequisites

What things you need to install the software and how to install them.

```
Give examples
```

### Installing

A step by step series of examples that tell you how to get a development env running.

Say what the step will be

```
Give the example
```

And repeat

```
until finished
```

End with an example of getting some data out of the system or using it for a little demo.

## Usage <a name = "usage"></a>

Add notes about how to use the system.
