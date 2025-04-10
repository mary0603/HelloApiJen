pipeline {
    agent any

    tools {
        dotnetsdk 'dotnet-9.0'  // Ensure you have 'dotnet-9.0' configured in Jenkins Global Tools Configuration
    }

    environment {
        DOTNET_CLI_TELEMETRY_OPTOUT = '1'  // Opt out of .NET CLI telemetry
        DOTNET_ROOT = "C:\\Program Files\\dotnet"  // Update to the correct path for Windows
        PATH = "C:\\Program Files\\dotnet:$PATH"  // Ensure dotnet is included in the PATH
        DOCKER_CLI_EXPERIMENTAL = "enabled"  // Enable Docker CLI experimental features (optional)
        DOCKER_HOST = "unix:///var/run/docker.sock"  // Docker host configuration (optional)
    }

    stages {
        // Checkout the code from the GitHub repository
        stage('Checkout') {
            steps {
                git 'https://github.com/mary0603/HelloApiJen.git'
            }
        }

        // Restore the NuGet packages
        stage('Restore') {
            steps {
                bat 'dotnet restore'  // Using bat for Windows commands
            }
        }

        // Build the application
        stage('Build') {
            steps {
                bat 'dotnet build --configuration Release --no-restore'  // Using bat for Windows commands
            }
        }

        // Run the unit tests
        stage('Test') {
            steps {
                bat 'dotnet test --no-build --verbosity normal'  // Using bat for Windows commands
            }
        }

        // Publish the application for deployment
        stage('Publish') {
            steps {
                bat 'dotnet publish -c Release -o out'  // Using bat for Windows commands
            }
        }

        // Docker build step to build the Docker image
        stage('Docker Build') {
            steps {
                script {
                    // Build Docker image with the specified tag
                    dockerImage = docker.build("helloapiJen:latest")
                }
            }
        }

        // Deploy the application using Docker Compose
        stage('Deploy - Docker Compose') {
            steps {
                // Bring down any existing Docker Compose services, ignore errors if no services are running
                bat 'docker-compose down || true'  // Using bat for Windows commands
                // Bring up the services in detached mode, and rebuild images if necessary
                bat 'docker-compose up -d --build'  // Using bat for Windows commands
            }
        }

        // Push the Docker image to Docker Hub
        stage('Push to DockerHub') {
            steps {
                script {
                    // Authenticate with Docker Hub using Jenkins credentials
                    docker.withRegistry('https://index.docker.io/v1/', 'dockerhub-credentials-new') {
                        // Push the Docker image with the 'latest' tag
                        dockerImage.push("latest")
                    }
                }
            }
        }
    }
}
