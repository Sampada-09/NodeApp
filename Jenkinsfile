pipeline {
  agent any

  environment {
    GHCR_USER = 'Sampada-09'       // GitHub username for login
    GHCR_REPO = 'sampada-09'       // lowercase for Docker repo
    IMAGE_NAME = "ghcr.io/${GHCR_REPO}/react-frontend:latest"
  }

  stages {
    stage('Checkout') {
      steps {
        checkout scm
      }
    }

    stage('Build Docker Image') {
      steps {
        sh "docker build -t ${IMAGE_NAME} ."
      }
    }

    stage('Login to GHCR') {
      steps {
        withCredentials([string(credentialsId: 'GHCR_PAT', variable: 'TOKEN')]) {
          sh 'echo $TOKEN | docker login ghcr.io -u $GHCR_USER --password-stdin'
        }
      }
    }

    stage('Push Docker Image') {
    steps {
        sh "docker push ${IMAGE_NAME}"
        echo "Docker image pushed to GHCR successfully! -t ${IMAGE_NAME}"
    }
}

    stage('Deploy to Render') {
      steps {
        withCredentials([string(credentialsId: 'RENDER_DEPLOY_HOOK', variable: 'HOOK')]) {
          sh 'curl "$HOOK"'
        }
      }
    }
  }

  post {
    success {
      echo ' Docker image pushed to GHCR and deploy triggered on Render!'
    }
    failure {
      echo ' Pipeline failed'
    }
  }
}
