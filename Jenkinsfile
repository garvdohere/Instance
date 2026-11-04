pipeline {

    agent any

    environment {
        DOCKER_IMAGE = "instance-app"
        CONTAINER_NAME = "instance-app"
        APP_PORT = "8081"
    }

    stages {

        stage('Checkout GitHub Code') {
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

        stage('Deploy Application Locally') {
            steps {
                sh '''
                    docker rm -f $CONTAINER_NAME || true

                    docker run -d \
                        --name $CONTAINER_NAME \
                        --restart unless-stopped \
                        -p $APP_PORT:80 \
                        $DOCKER_IMAGE:latest
                '''
            }
        }

        stage('Verify Deployment') {
            steps {
                sh '''
                    sleep 5
                    curl --fail http://localhost:$APP_PORT
                '''

                echo 'Application deployed successfully!'
            }
        }
    }

    post {
        success {
            echo 'CI/CD Pipeline executed successfully!'
        }

        failure {
            echo 'CI/CD Pipeline failed. Check Console Output.'
        }
    }
}
