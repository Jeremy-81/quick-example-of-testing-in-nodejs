pipeline {
    agent any

    tools {
        nodejs "nodejs"
    }

    environment {
        IMAGE_NAME = "ghcr.io/jeremy-81/quick-example"
        IMAGE_TAG = "${BUILD_NUMBER}"
        FULL_IMAGE = "${IMAGE_NAME}:${IMAGE_TAG}"
        REPO_URL = 'https://github.com/jeremy-81/quick-example-of-testing-in-nodejs.git'
    }

    stages {
        stage('Checkout') {
            steps {
                checkout scm
            }
        }

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
                sh "docker build -t ${FULL_IMAGE} ."
            }
        }

        stage('Login to GitHub Container') {
            steps {
                withCredentials([usernamePassword(credentialsId: 'github-token', usernameVariable: 'GITHUB_USER', passwordVariable: 'GITHUB_TOKEN')]) {
                    sh '''
                        echo "$GITHUB_TOKEN" | docker login ghcr.io -u "$GITHUB_USER" --password-stdin
                    '''
                }
            }
        }

        stage('Push Docker Image') {
            steps {
                sh "docker push ${FULL_IMAGE}"
            }
        }

        stage('Tag Git') {
            steps {
                withCredentials([usernamePassword(credentialsId: 'github-token', usernameVariable: 'GITHUB_USER', passwordVariable: 'GITHUB_TOKEN')]) {
                    script {
                        def tagName = "v${env.BUILD_NUMBER}"
                        echo "Création du tag Git : ${tagName}"

                        sh """
                            git config user.name "jenkins"
                            git config user.email "jenkins@mail.fr"
                            git tag ${tagName}
                            git push https://${GITHUB_USER}:${GITHUB_TOKEN}@github.com/jeremy-81/quick-example-of-testing-in-nodejs.git ${tagName}
                        """
                    }
                }
            }
        }
    }
}
