# Jenkins GitLab Flow Pipeline
A sample codebase for tutorial(s) on setting up Jenkins for CI/CD of a Gitlab Flow style repository whereby there are
named environment branches for staging/production, and the credentials/configuration options need to be stored/provided
by the Jenkins server.


For this to work, you need to set [deploy a Jenkins server](https://blog.programster.org/deploy-jenkins-with-docker) with the following plugins:

* [Config File Provider](https://plugins.jenkins.io/config-file-provider/S)
* [Docker Slaves](https://plugins.jenkins.io/docker-slaves/)
* [Docker](https://plugins.jenkins.io/docker-plugin/)
* [Docker Pipeline](https://plugins.jenkins.io/docker-workflow/)
* [Pipeline Utility Steps](https://plugins.jenkins.io/pipeline-utility-steps/) - for readJSON
* [SSH Agent](https://plugins.jenkins.io/ssh-agent/)

Create a new multi-branch project.

Fork this codebase to create your own GitHub repository.

Create a config file in that project with the following name: `my-config-file.json`, or use an alternative name, and
update the Jenkinsfile in this codebase accordingly.

That config file should have the following contents (a block per environment branch).

```json
{
	"staging": {
		"DOCKER_HOST": "my.staging-server.com",
		"IMAGE_NAME": "my-docker-image",
		"DOCKER_REGISTRY": "docker-registry.mydomain.com",
		"SSH_USER": "programster"
	},
	"production": {
		"DOCKER_HOST": "my.production-server.com",
		"IMAGE_NAME": "my-docker-image",
		"DOCKER_REGISTRY": "docker-registry.mydomain.com",
		"SSH_USER": "programster"
	}
}
```


### Create Credentials
Create a credential of type `usernamePassword` called "docker-registry-credentials" for which you provide the
username and password to your docker registry.

Create a credential of type file called `master.pem` that contains the private SSH key that will allow logging into the
remote server (`DOCKER_HOST`).


### Configure Triggering From GitHub
It's ideal if changes pushed to GitHub automatically triggered Jenkins to run the pipeline so...







