# Serverless Framework Node Express API With Lambda Layers and AWS DynamoDB

This template demonstrates how to develop and deploy a simple Node Express API service, backed by DynamoDB database, running on AWS Lambda using the traditional Serverless Framework, in addition to using Lambda Layers to reduce the size of the deployment package.
This template is based on the [aws-node-express-dynamodb-api](https://www.serverless.com/blog/serverless-express-rest-api/)


## Anatomy of the template

This template configures a single function, `gateway`, which is responsible for handling all incoming requests thanks to the `httpApi` event. To learn more about `httpApi` event configuration options, please refer to [httpApi event docs](https://www.serverless.com/framework/docs/providers/aws/events/http-api/). As the event is configured in a way to accept all incoming requests, `express` framework is responsible for routing and handling requests internally. Implementation takes advantage of `serverless-http` package, which allows you to wrap existing `express` applications. To learn more about `serverless-http`, please refer to corresponding [GitHub repository](https://github.com/dougmoscrop/serverless-http). Additionally, it also handles provisioning of a DynamoDB database that is used for storing data about users. The `express` application exposes two endpoints, `POST /users` and `GET /user/{userId}`, which allow to create and retrieve users, and finally to decrease the size of the deployment package, it also uses Lambda Layers to store `node_modules` dependencies.

## Usage

### Prepare Environment variables

First you have to prepare your environment variables. You can do that by copying `.env.example` to `.env` and then filling in the values.
- *AWS_REGION* - AWS region where you want to deploy your service
- *AWS_PROFILE* - AWS profile name that you want to use for deployment
- *NAMESPACE* - Namespace for your service. It will be used as a prefix for all resources created by this template. It is also used as a prefix for the name of the CloudFormation stack that will be created by this template. It is recommended to use your name or your company name as a namespace.
### Layers Deployment

In this template we have only one to store `node_modules` dependencies. And you have to make sure that layer `package.json` file is updated with the latest dependencies.
Then, you can deploy the layers by running the following command:


```
make layers-deploy [stage]
```

After running layers-deploy, you should see output similar to:

```bash
Deploying mynamespace-layers to stage dev (us-east-1)

✔ Service deployed to stack mynamespace-layers-dev (196s)

layers:
  NodeModules: arn:aws:lambda:us-east-1:xxxxxxxxxx:layer:NodeModules:1
```

### App Deployment
Now layers are deployed, you can deploy the app by running the following command:

```
make deploy [stage]
```

After running deploy, you should see output similar to:

```bash
Deploying mynamespace-app to stage dev (us-east-1)

✔ Service deployed to stack mynamespace-app-dev (196s)

endpoint: ANY - https://xxxxxxxxxx.execute-api.us-east-1.amazonaws.com
functions:
  api: mynamespace-app-dev-api (766 kB)
```

### App Removal
To remove the app, run the following command:

```
make destroy [stage]
```

### Custom Serverless commands
You can use all sls commands by running the following command:

```
make sls [stage] command='serverless command here'
# Example
make sls dev command='logs -f gateway --tail'
```

To learn more about the capabilities of the original template, please refer to the [original repository](https://github.com/serverless/examples/tree/v3/aws-node-express-dynamodb-api).
