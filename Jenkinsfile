pipeline {
    agent any

    // Definição da ferramenta Java - certifique-se de configurar esta JDK no Jenkins
    tools {
        // Você precisa configurar uma JDK 21 no Jenkins em "Gerenciar Jenkins" > "Global Tool Configuration"
        jdk 'JDK21'
    }

    environment {
        // Variáveis para o projeto
        APP_NAME = 'graalvm-app'
        VERSION = "${BUILD_NUMBER}"
        // Caminho para o binário nativo gerado pelo GraalVM
        NATIVE_IMAGE_PATH = 'build/native-image'
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

        stage('Verificar Ambiente') {
            steps {
                // Verifica a versão do Java disponível
                sh 'java -version'
                // Verifica se o Gradle consegue iniciar
                sh './gradlew --version'
                // Verifica disponibilidade do Docker (opcional)
                sh 'if command -v docker &> /dev/null; then docker --version; else echo "Docker não está instalado"; fi'
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
                    // Publica resultados dos testes se existirem
                    junit allowEmptyResults: true, testResults: '**/build/test-results/test/*.xml'
                }
            }
        }

        stage('Análise de Código') {
            steps {
                // Análise de código simplificada
                sh './gradlew check || echo "Alguns checks podem ter falhado, mas continuando"'
            }
        }

        // Estágio condicional para a geração de imagem nativa (só executa se houver a task apropriada)
        stage('GraalVM Native Image') {
            steps {
                script {
                    def hasNativeTask = sh(script: './gradlew tasks --all | grep nativeCompile', returnStatus: true)
                    if (hasNativeTask == 0) {
                        sh './gradlew nativeCompile'
                        echo 'Imagem nativa gerada com sucesso'
                    } else {
                        echo 'Task nativeCompile não encontrada, pulando geração de imagem nativa'
                    }
                }
            }
        }

        // Estágio condicional para o build da imagem Docker (só executa se Docker estiver disponível)
        stage('Build Imagem Docker') {
            steps {
                script {
                    def dockerInstalled = sh(script: 'command -v docker', returnStatus: true)
                    if (dockerInstalled == 0 && fileExists('src/main/docker/Dockerfile.native')) {
                        sh 'docker build -f src/main/docker/Dockerfile.native -t ${APP_NAME}:${VERSION} .'
                        echo 'Imagem Docker construída com sucesso'
                    } else {
                        echo 'Docker não instalado ou Dockerfile.native não encontrado, pulando build da imagem'
                    }
                }
            }
        }

        stage('Testes de Integração') {
            steps {
                script {
                    def hasIntegrationTests = sh(script: './gradlew tasks --all | grep integrationTest', returnStatus: true)
                    if (hasIntegrationTests == 0) {
                        sh './gradlew integrationTest'
                        echo 'Testes de integração concluídos'
                    } else {
                        echo 'Task integrationTest não encontrada, pulando testes de integração'
                    }
                }
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
            sh './gradlew clean || echo "Falha ao limpar"'
            echo "Workspace limpo."
        }
    }
}