pipeline {
    agent any

    environment {
        IMAGE_NAME = "quick-example"
        DOCKER_REPO = "ghcr.io/jeremy-81"
        GITHUB_USER = "jeremy-81"
        GITHUB_TOKEN = credentials('github-token') // Stocké dans Jenkins -> Credentials
    }

    stages {
        stage('Cloner le dépôt') {
            steps {
                git url: 'https://github.com/Jeremy-81/quick-example-of-testing-in-nodejs.git', branch: 'main'
            }
        }

        stage('Installer les dépendances') {
            steps {
                sh 'npm install'
            }
        }

        stage('Exécuter les tests') {
            steps {
                sh 'npm test'
            }
        }

        stage('Construire l’image Docker') {
            steps {
                script {
                    env.IMAGE_TAG = "${BUILD_NUMBER}"
                    env.FULL_IMAGE = "${DOCKER_REPO}/${IMAGE_NAME}:${IMAGE_TAG}"
                    sh "docker build -t ${FULL_IMAGE} ."
                }
            }
        }

        stage('Pousser l’image Docker') {
            steps {
                script {
                    sh """
                        echo "${GITHUB_TOKEN}" | docker login ghcr.io -u ${GITHUB_USER} --password-stdin
                        docker push ${FULL_IMAGE}
                    """
                }
            }
        }

        stage('Créer un tag Git') {
            steps {
                script {
                    def tag = "v${BUILD_NUMBER}"
                    sh """
                        git config user.name "jenkins"
                        git config user.email "jenkins@example.com"
                        git tag ${tag}
                        git push https://${GITHUB_USER}:${GITHUB_TOKEN}@github.com/${GITHUB_USER}/quick-example-of-testing-in-nodejs.git ${tag}
                    """
                    echo "Tag ${tag} créé et poussé sur GitHub"
                }
            }
        }
    }
}
