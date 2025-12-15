@Library('Shared') _

pipeline {
    agent any

    environment {
        // Update the main app image name to match the deployment file
        DOCKER_IMAGE_NAME           = 'devop715/easyshop-app'
        DOCKER_MIGRATION_IMAGE_NAME = 'devop715/easyshop-migration'
        DOCKER_IMAGE_TAG            = "${BUILD_NUMBER}"
        GITHUB_CREDENTIALS          = credentials('github-credentials')
        GIT_BRANCH                  = "main"
    }

    stages {

        stage('Cleanup Workspace') {
            steps {
                script {
                    cleanWs()
                }
            }
        }

        stage('Clone Repository') {
            steps {
                script {
                    dir('source') {
                        checkout([
                            $class: 'GitSCM',
                            branches: [[name: '*/main']],
                            userRemoteConfigs: [[
                                url: 'https://github.com/abhinavpathaklabs/E-Commerce-Application.git'
                            ]]
                        ])
                    }
                }
            }
        }

        stage('Build Docker Images') {
            parallel {

                stage('Build Main App Image') {
                    steps {
                        script {
                            dir('source') {
                                echo "Building Docker image: devop715/easyshop-app:${BUILD_NUMBER} using Dockerfile"
                                sh """
                                    docker build \\
                                        -t devop715/easyshop-app:${BUILD_NUMBER} \\
                                        -t devop715/easyshop-app:latest \\
                                        -f Dockerfile .
                                """
                            }
                        }
                    }
                }
            }

            stage('Build Migration Image') {
                steps {
                    script {
                        dir('source') {
                            echo "Building Docker image: devop715/easyshop-migration:${BUILD_NUMBER} using scripts/Dockerfile.migration"
                            sh """
                                docker build \\
                                    -t devop715/easyshop-migration:${BUILD_NUMBER} \\
                                    -t devop715/easyshop-migration:latest \\
                                    -f scripts/Dockerfile.migration .
                            """
                        }
                    }
                }
            }
        }

        stage('Run Unit Tests') {
            steps {
                script {
                    run_tests()
                }
            }
        }

        stage('Security Scan with Trivy') {
            steps {
                script {
                    trivy_scan()
                }
            }
        }

        stage('Push Docker Images') {
            parallel {

                stage('Push Main App Image') {
                    steps {
                        script {
                            docker_push(
                                imageName: env.DOCKER_IMAGE_NAME,
                                imageTag: env.DOCKER_IMAGE_TAG,
                                credentials: 'docker-hub-credentials'
                            )
                        }
                    }
                }

                stage('Push Migration Image') {
                    steps {
                        script {
                            docker_push(
                                imageName: env.DOCKER_MIGRATION_IMAGE_NAME,
                                imageTag: env.DOCKER_IMAGE_TAG,
                                credentials: 'docker-hub-credentials'
                            )
                        }
                    }
                }
            }
        }

        stage('Update Kubernetes Manifests') {
            steps {
                script {
                    update_k8s_manifests(
                        imageTag: env.DOCKER_IMAGE_TAG,
                        manifestsPath: 'kubernetes',
                        gitCredentials: 'github-credentials',
                        gitUserName: 'Jenkins CI',
                        gitUserEmail: 'pathakabhinav2011@gmail.com'
                    )
                }
            }
        }
    }
}
