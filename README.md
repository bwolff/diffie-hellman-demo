# Diffie-Hellman Key Exchange Demo
This little project allows to realise a Diffie-Hellman Key Exchange using two simple web forms to demonstrate the mechanics behind it. The project was created by me for a live demo during talk I gave at the CERN Spring Campus 2016 at the Vilnius Technical University (VGTU) in Lithuania.

The app itself runs on Google AppEngine (GAE) and is available at: https://spring-campus.appspot.com/

Since it is a GAE app, it needs to be built and run with **Java 7**.

## Running locally
The app can be run locally using the following Maven command:

```sh
mvn gcloud:run
```

After the startup, the app should be available at: http://localhost:8080/

## Deploying to GAE
To deploy the app to GAE, the following command is used (requires permissions for the GAE project):

```sh
mvn gcloud:deploy
```