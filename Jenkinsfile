pipeline {
    agent any

    tools {
        dotnetsdk 'dotnet-9.0' // Ensure 'dotnet-9.0' is configured in Jenkins tools
    }

    environment {
        DOTNET_CLI_TELEMETRY_OPTOUT = '1'
        DOTNET_ROOT = "C:\\Program Files\\dotnet"  // Set the DOTNET_ROOT variable to your .NET SDK installation path
        PATH = "$DOTNET_ROOT:$PATH"  // Update PATH to include the dotnet installation path
        DOTNET_SYSTEM_GLOBALIZATION_INVARIANT = 'true'

       // DOCKER_CLI_EXPERIMENTAL = "enabled"
       // DOCKER_HOST = "unix:///var/run/docker.sock"
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
                sh 'rm -rf out' // Clean previous publish output

                sh 'dotnet publish -c Release -o out'
            }
        }

        stage('Docker Build') {
            steps {
                script {
                    dockerImage = docker.build("helloapijen:latest")
                }
            }
        }
        stage('Docker Test') {
        steps {
         sh 'docker --version'
         }
     }


        stage('Deploy - Docker Compose') {
            steps {
                sh 'docker-compose down || true'
                sh 'docker-compose up -d --build'
            }
        }

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
