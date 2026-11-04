pipeline {
    agent any

    environment {
        DOCKER_IMAGE = "YOUR_DOCKERHUB_USERNAME/my-web-app"
        CONTAINER_NAME = "my-web-app"
    }

    stages {

        stage('Pull Code from GitHub') {
            steps {
                checkout scm
                echo 'Code pulled successfully from GitHub'
            }
        }

        stage('Build Docker Image') {
            steps {
                sh '''
                    docker build -t $DOCKER_IMAGE:$BUILD_NUMBER .
                    docker tag $DOCKER_IMAGE:$BUILD_NUMBER $DOCKER_IMAGE:latest
                '''
            }
        }

        stage('Push Image to Docker Hub') {
            steps {
                withCredentials([
                    usernamePassword(
                        credentialsId: 'dockerhub-credentials',
                        usernameVariable: 'DOCKER_USER',
                        passwordVariable: 'DOCKER_PASS'
                    )
                ]) {
                    sh '''
                        echo "$DOCKER_PASS" | docker login \
                        -u "$DOCKER_USER" --password-stdin

                        docker push $DOCKER_IMAGE:$BUILD_NUMBER
                        docker push $DOCKER_IMAGE:latest

                        docker logout
                    '''
                }
            }
        }

        stage('Deploy Container Locally') {
            steps {
                sh '''
                    docker rm -f $CONTAINER_NAME || true

                    docker run -d \
                    --name $CONTAINER_NAME \
                    --restart unless-stopped \
                    -p 8080:80 \
                    $DOCKER_IMAGE:latest
                '''
            }
        }
    }

    post {
        success {
            echo 'CI/CD Pipeline completed successfully!'
        }
        failure {
            echo 'CI/CD Pipeline failed. Check Jenkins console output.'
        }
    }
}
