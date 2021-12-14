
# Taking a Service to Production

This Devops challenge's goal is simple.

Build a full integration, deployment and monitoring pipeline for a service deployed in k8s. It will allow you understand the challenges we face in Cycode everyday, and to demonstrate your skills.

We look at the pipeline as consisting of the following stages:

1. **Infrastructure as a code** - (optional) use terraform to setup k8s cluster on one of the cloud providers (AWS, GCP)
2. **Continuous Integration** - Any change in the repository that is pushed is automatically built as a docker container and published to a docker registry.
3. **Continuous Deployment** - Latest docker image deployed to a container platform and available to use.
4. **Continuous Monitoring** - The service health status is always available, and alert is sent when the service is not functioning. Logs are delivered and available.

## Required solution:
**all the services can be deployed on one local k8s cluster (kind, minikube) / Managed Kubernetes as a Service (EKS, GKE)**

The exercise is focused on the `CI` and `CD` stages.

* Create a full _Continuous Integration_ and _Continuous Deployment_ processes as defined above.
* The outcome should include:
   * Configuration / script files as part of the repository.
   * Permissions to the repository, where we can commit changes, and see that the pipeline was triggered and new docker was uploaded to the registry.
   * URL/IP of the deployed service - so we can check it over http.
   * Access to CI tool that we can access and see the pipeline
   * Access to the deployment environment where we can see the deployed artifact
* * *__Bonus:__* Continue to _Continuous Monitoring_ process as defined above (Use the `/health` endpoint in addition to logs) .

## Prerequisites

This GitHub repository is a `NodeJS` demo app of a very small users service.
Below are the instructions of how to build, run and use this service.

### Build

   `npm install`

### Run

   `npm run start`

### Use

#### http://localhost:3000/users

`GET` - lists the list of existing users

* Response:
```javascript
[
    {
        "_id": "5c20ca1d2cdc846b4de1f6ab",
        "name": "u1",
        "date": 1545652765281
    },
    {
        "_id": "5c20ca81c23ea46b5089884b",
        "name": "u2",
        "date": 1545652865843
    }
]
```

`POST` - add a new user

* Body: new user name
```javascript
{
    "username":"<username>"
}
```

* Response: created user, including ID, and created date:
```javascript
{
    "name": "<name>",
    "date": 1545657494671,
    "_id": "5c20dc96e4f6066bc12ab11e"
}
```

#### http://localhost:3000/health

`GET` - report on health of the service

* Response:
  * In case all OK:
  **Status**:200
  **Headers**: System-Health:true
  * If error occurs:
  **Status**:200
  **Headers**: System-Health:false
  **Body**: Information about the error in json:
  ```javascript
  {
      "status": "DB Down"
  }
  ```


### Config

The users service works with a `MongoDB` to store its users.

   `Database name: devops-exercise`

   `Collection name: users`

### Environment Variables

   `MONGO_URI - uri of the mongo DB`

## Guidelines:

* **all the services can be deployed on one local k8s cluster (kind, minikube) / Managed Kubernetes as a Service (EKS, GKE)**
* Although this "users service" is very small and focused, we should be prepared for multi-environments (dev, staging, production, etc...) with full pipeline (including testing, linting, and more...) in the future. Make sure your solution is opened for such future changes.
* use whichever k8s platform (kind, minikube, k3s, eks, gke)
* Use whichever CI/CD tool you want.
* Use whichever Container Registry
* Work on local gitlab repository.
* Make sure the solution is *__private__*, not public. Only available for you and us.
* You can use managed services as Mongo-Atlas, Grafana-Cloud, GKE, EKS
* For the sake of the exercise, `/health` endpoint randomly returns that the health is false.
* For simplicity, the service logs all the requests to the console.

Don't hesitate to contact us with any question.

**Good Luck!**
