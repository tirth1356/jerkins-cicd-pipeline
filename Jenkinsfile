pipeline {
    agent any

    environment {
        IMAGE_NAME    = "nodejs-demo-app"
        CONTAINER_PORT = "30002"
    }

    stages {

        stage('Test') {
            steps {
                sh 'npm ci'
                sh 'npm test'
            }
        }

        stage('Build') {
            steps {
                sh 'npm run build'
            }
        }

        stage('Docker Build') {
            steps {
                sh "docker build -t ${IMAGE_NAME}:sha-${GIT_COMMIT.take(7)} -t ${IMAGE_NAME}:latest ."
            }
        }

        stage('Push to DockerHub') {
            when {
                branch 'main'
            }
            steps {
                withCredentials([usernamePassword(
                    credentialsId: 'dockerhub-credentials',
                    usernameVariable: 'DOCKERHUB_USERNAME',
                    passwordVariable: 'DOCKERHUB_TOKEN'
                )]) {
                    sh "echo ${DOCKERHUB_TOKEN} | docker login -u ${DOCKERHUB_USERNAME} --password-stdin"
                    sh "docker tag ${IMAGE_NAME}:sha-${GIT_COMMIT.take(7)} ${DOCKERHUB_USERNAME}/${IMAGE_NAME}:sha-${GIT_COMMIT.take(7)}"
                    sh "docker tag ${IMAGE_NAME}:latest ${DOCKERHUB_USERNAME}/${IMAGE_NAME}:latest"
                    sh "docker push ${DOCKERHUB_USERNAME}/${IMAGE_NAME}:sha-${GIT_COMMIT.take(7)}"
                    sh "docker push ${DOCKERHUB_USERNAME}/${IMAGE_NAME}:latest"
                    sh "docker logout"
                }
            }
        }
    }

    post {
        success {
            echo "Pipeline passed — image pushed to DockerHub."
        }
        failure {
            echo "Pipeline failed — check the stage logs above."
        }
    }
}
