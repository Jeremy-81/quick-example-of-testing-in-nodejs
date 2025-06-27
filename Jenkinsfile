pipeline {
    agent {
        docker {
            image 'node:22'
            args '-v /var/run/docker.sock:/var/run/docker.sock'
        }
    }

    tools {
        nodejs "nodejs"
        docker "Docker"
    }

    environment {
        IMAGE_NAME = "quick-example"
        IMAGE_TAG = "${BUILD_NUMBER}"
        FULL_IMAGE = "${IMAGE_NAME}:${IMAGE_TAG}"
    }

    stages {
        stage('Install dependencies') {
            steps {
                sh 'npm install'
            }
        }

        stage('Run tests') {
            steps {
                sh 'npm test'
            }
        }

        stage('Build Docker image') {
            steps {
                script {
                    sh "docker build -t ${FULL_IMAGE} ."
                }
            }
        }

        stage('Push to local Docker registry (optional)') {
            when {
                expression { return false }
            }
            steps {
                script {
                    withCredentials([usernamePassword(credentialsId: 'docker-hub-creds', passwordVariable: 'PASS', usernameVariable: 'USER')]) {
                        sh """
                            echo "$PASS" | docker login -u "$USER" --password-stdin
                            docker tag ${FULL_IMAGE} ${USER}/${IMAGE_NAME}:${IMAGE_TAG}
                            docker push ${USER}/${IMAGE_NAME}:${IMAGE_TAG}
                        """
                    }
                }
            }
        }
    }
}
