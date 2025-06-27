pipeline {
    agent {
        docker {
            image 'node:22'
            args '-v /var/run/docker.sock:/var/run/docker.sock'
        }
    }

    tools {
        nodejs "nodejs"
    }

    environment {
        IMAGE_NAME = "quick-example"
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
