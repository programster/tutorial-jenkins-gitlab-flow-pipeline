pipeline {
    agent none

    stages {
        stage("build") {
            agent {
                docker { image 'docker:dind' }
            }
            steps {
                echo "building docker image..."

                configFileProvider([configFile(fileId: 'my-config-file.json', variable: 'BRANCH_SETTINGS')]) {
                    echo "Branch ${env.BRANCH_NAME}"
                    echo "Branch Settings: ${BRANCH_SETTINGS}"

                    script {
                        def config = readJSON file:"$BRANCH_SETTINGS"
                        def branchConfig = config."${env.BRANCH_NAME}"

                        if (branchConfig) {
                            echo "using config for branch ${env.BRANCH_NAME}"

                            def DOCKER_REGISTRY = branchConfig.DOCKER_REGISTRY
                            def dockerImage = docker.build(branchConfig.IMAGE_NAME)

                            docker.withRegistry("https://${branchConfig.DOCKER_REGISTRY}", 'docker-registry-credentials') {
                                dockerImage.push("${env.BUILD_NUMBER}")
                                dockerImage.push("latest")
                            }
                        }
                        else {
                            error("Skipping build as this is not a change to staging or production")
                        }
                    }
                }
            }
        }

        stage("deploy") {
            agent {
                docker { image 'ubuntu:focal' }
            }
            steps {
                sh "apt-get update && apt-get install ssh -y"

                configFileProvider([configFile(fileId: 'my-config-file.json', variable: 'BRANCH_SETTINGS')]) {
                    echo "Branch ${env.BRANCH_NAME}"
                    echo "Branch Settings: ${BRANCH_SETTINGS}"

                    script {
                        def config = readJSON file:"$BRANCH_SETTINGS"

                        def branchConfig = config."${env.BRANCH_NAME}"

                        if (branchConfig) {
                            echo "using config for branch ${env.BRANCH_NAME}"

                            def SSH_USER = branchConfig.SSH_USER
                            def DOCKER_HOST = branchConfig.DOCKER_HOST
                            def DOCKER_REGISTRY = branchConfig.DOCKER_REGISTRY
                            def IMAGE_NAME = branchConfig.IMAGE_NAME

                            sshagent(credentials : ['master.pem']) {
                                withCredentials([usernamePassword(credentialsId: 'docker-registry-credentials', passwordVariable: 'DOCKER_REGISTRY_PASSWORD', usernameVariable: 'DOCKER_REGISTRY_USER')]) {
                                    sh 'ssh -o StrictHostKeyChecking=no ' + branchConfig.SSH_USER + '@' + branchConfig.DOCKER_HOST + ' "docker login -u ' + DOCKER_REGISTRY_USER + ' -p ' + DOCKER_REGISTRY_PASSWORD + ' ' + branchConfig.DOCKER_REGISTRY + '"'
                                    sh 'ssh -o StrictHostKeyChecking=no ' + branchConfig.SSH_USER + '@' + branchConfig.DOCKER_HOST + ' "docker pull ' + branchConfig.DOCKER_REGISTRY + '/' + IMAGE_NAME + ' && docker kill hello-world || true && docker rm hello-world || true && docker run -d --name hello-world -p80:80 ' + branchConfig.DOCKER_REGISTRY + '/' + branchConfig.IMAGE_NAME + '"'
                                }
                            }
                        }
                        else {
                            error("Skipping deployment as this is not a change to staging or production")
                        }
                    }
                }
            }
        }
    }
}
