
pipeline {
    agent any

    options {
        timestamps()
    }

    environment {
        APP_NAME = 'self-pipeline-app'
        IMAGE_NAME = 'self-pipeline-practice'
    }

    stages {

        stage('Checkout') {
            steps {
                echo 'Getting source code from GitHub'
                checkout scm
                sh 'git log -1 --oneline'
            }
        }

        stage('Build') {
            steps {
                echo 'Building Docker image'
                sh '''
                    sudo docker build \
                      -t $IMAGE_NAME:$BUILD_NUMBER .
                '''
            }
        }

        stage('Test') {
            steps {
                echo 'Testing application before deployment'
                sh '''
                    sudo docker rm -f self-pipeline-test || true

                    sudo docker run -d \
                      --name self-pipeline-test \
                      -p 127.0.0.1:18080:80 \
                      $IMAGE_NAME:$BUILD_NUMBER

                    sleep 3

                    bash tests/test.sh http://127.0.0.1:18080
                '''
            }
        }

        stage('Deploy') {
            steps {
                echo 'Deploying application'
                sh '''
                    sudo docker rm -f $APP_NAME || true

                    sudo docker run -d \
                      --name $APP_NAME \
                      --restart unless-stopped \
                      -p 8080:80 \
                      $IMAGE_NAME:$BUILD_NUMBER
                '''
            }
        }

        stage('Verify Deployment') {
            steps {
                echo 'Checking deployed application'
                sh '''
                    bash tests/test.sh http://127.0.0.1:8080
                '''
            }
        }
    }

    post {
        always {
            sh 'sudo docker rm -f self-pipeline-test || true'
        }

        success {
            echo 'CI/CD completed successfully!'
        }

        failure {
            echo 'Pipeline failed. Check Console Output.'
        }
    }
}
