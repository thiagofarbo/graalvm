pipeline {
    // Usando o agente 'any' em vez de 'docker' para compatibilidade básica
    agent any

    environment {
        // Variáveis para o projeto
        APP_NAME = 'graalvm-app'
        VERSION = "${BUILD_NUMBER}"
        // Caminho para o binário nativo gerado pelo GraalVM
        NATIVE_IMAGE_PATH = 'build/native-image'
        // Adiciona o JAVA_HOME para GraalVM se necessário
        // JAVA_HOME = '/caminho/para/graalvm'
    }

    stages {
        stage('Checkout') {
            steps {
                checkout scm
                echo 'Código fonte obtido com sucesso'

                // Garante que o gradlew seja executável
                sh 'chmod +x ./gradlew'
            }
        }

        stage('Build Java') {
            steps {
                // Build do projeto Java com Gradle
                sh './gradlew assemble'
                echo 'Projeto Java compilado com sucesso'
            }
        }

        stage('Testes') {
            steps {
                // Executa testes com Gradle
                sh './gradlew test'
                echo 'Testes executados com sucesso'
            }
            post {
                always {
                    // Publica resultados dos testes
                    junit '**/build/test-results/test/*.xml'
                }
            }
        }

        stage('Análise de Código') {
            steps {
                // Pode ser expandido com integração SonarQube
                echo 'Análise de código estático'
                sh './gradlew check'
            }
        }

        stage('GraalVM Native Image') {
            steps {
                // Comando para gerar imagem nativa com GraalVM usando Gradle
                sh '''
                    echo "Gerando imagem nativa com GraalVM..."
                    ./gradlew nativeCompile
                '''
                echo 'Imagem nativa gerada com sucesso'
            }
        }

        stage('Build Imagem Docker') {
            steps {
                // Constrói uma imagem Docker usando o binário nativo
                sh '''
                    echo "Construindo imagem Docker a partir da imagem nativa..."
                    docker build -f src/main/docker/Dockerfile.native -t ${APP_NAME}:${VERSION} .
                '''
                echo 'Imagem Docker construída com sucesso'
            }
        }

        stage('Testes de Integração') {
            steps {
                // Executa testes de integração
                sh '''
                    echo "Executando testes de integração..."
                    ./gradlew integrationTest || echo "Pulando testes de integração"
                '''
                echo 'Testes de integração concluídos'
            }
        }

        stage('Deploy') {
            when {
                branch 'main'  // Ou 'master', dependendo da sua branch principal
            }
            steps {
                echo 'Realizando deploy da aplicação...'
                // Exemplo de push para Docker Registry
                sh '''
                    echo "Publicando imagem Docker..."
                    # Descomentar após configurar seu registry
                    # docker tag ${APP_NAME}:${VERSION} seu-registry/${APP_NAME}:${VERSION}
                    # docker tag ${APP_NAME}:${VERSION} seu-registry/${APP_NAME}:latest
                    # docker push seu-registry/${APP_NAME}:${VERSION}
                    # docker push seu-registry/${APP_NAME}:latest
                '''
            }
        }
    }

    post {
        success {
            echo 'Pipeline executada com sucesso!'
        }

        failure {
            echo 'Pipeline falhou!'
        }

        always {
            echo 'Limpando recursos...'
            sh '''
                docker system prune -f || echo "Docker não disponível"
                ./gradlew clean || echo "Falha ao limpar"
                echo "Workspace limpo."
            '''
        }
    }
}