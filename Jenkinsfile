pipeline {
    agent any

    tools {
        nodejs "nodejs"
    }

    environment {
        IMAGE_NAME = "quick-example"
        GITHUB_USER = 'jeremy-81'
        GITHUB_TOKEN = credentials('github-token')
        IMAGE_TAG = "${BUILD_NUMBER}"
        FULL_IMAGE = "${IMAGE_NAME}:${IMAGE_TAG}"
        GIT_CREDENTIALS_ID = 'github-token' 
        REPO_URL = 'https://github.com/jeremy-81/quick-example-of-testing-in-nodejs.git'
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

        stage('Login to GitHub Container') {
            steps {
                sh "echo ${GITHUB_TOKEN} | docker login ghcr.io -u ${GITHUB_USER} --password-stdin"
            }
        }

        stage('Push Docker Image') {
            steps {
                sh "docker push ${FULL_IMAGE}"
            }
        }

        stage('Tag Git') {
            steps {
                script {
                    def tagName = "v${env.BUILD_NUMBER}"
                    echo "Création du tag Git : ${tagName}"

                    sh '''
                        git config user.name "jenkins"
                        git config user.email "jenkins@mail.fr"
                    '''

                    sh "git tag ${tagName}"

                    sh """
                        git push https://${GIT_CREDENTIALS_ID}@github.com/jeremy-81/quick-example-of-testing-in-nodejs.git ${tagName}
                    """
                }
            }
        }
    }
}
