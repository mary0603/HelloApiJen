pipeline {
    agent any

    tools {
        dotnetsdk 'dotnet-9.0' 
    }

    environment {
        DOTNET_CLI_TELEMETRY_OPTOUT = '1'
    }

    stages {
        stage('Checkout') {
            steps {
                git 'https://github.com/mary0603/HelloApiJen.git'
            }
        }

        stage('Restore') {
            steps {
                sh 'dotnet restore'
            }
        }

        stage('Build') {
            steps {
                sh 'dotnet build --configuration Release --no-restore'
            }
        }

        stage('Test') {
            steps {
                sh 'dotnet test --no-build --verbosity normal'
            }
        }

        stage('Publish') {
            steps {
                sh 'dotnet publish -c Release -o out'
            }
        }

        stage('Docker Build') {
            steps {
                script {
                    dockerImage = docker.build("helloapiJen:latest")
                }
            }
        }
//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
        stage('Deploy - Docker Compose') {
            steps {
                sh 'docker-compose down || true'
                sh 'docker-compose up -d --build'
            }
        }

        // Optional: Push to Docker Hub
        
        stage('Push to DockerHub') {
            steps {
                script {
                    docker.withRegistry('https://index.docker.io/v1/', 'dockerhub-credentials-new') {
                        dockerImage.push("latest")
                    }
                }
            }
        }
        
    }
}
