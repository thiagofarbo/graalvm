pipeline {
    agent any
    
    // Configuração de ferramentas (opcional)
    tools {
        // Especifique sua versão do Maven, se disponível no Jenkins
        // maven 'Maven 3.8.6'
        
        // Especifique sua versão do JDK, se disponível no Jenkins
        // jdk 'JDK 17'
    }
    
    // Variáveis de ambiente
    environment {
        // Exemplo de variáveis que podem ser utilizadas na pipeline
        APP_NAME = 'demo-native'
        VERSION = '1.0.0'
    }
    
    // Estágios da pipeline
    stages {
        stage('Checkout') {
            steps {
                // Checkout do código fonte
                checkout scm
                echo 'Código fonte obtido com sucesso'
            }
        }
        
        stage('Build') {
            steps {
                // Comandos de build - ajuste conforme sua aplicação
                sh 'echo "Executando build..."'
                
                // Exemplo para Maven
                // sh 'mvn clean package -DskipTests'
                
                // Exemplo para Gradle
                // sh './gradlew build -x test'
            }
        }
        
        stage('Testes') {
            steps {
                // Comandos para executar testes
                sh 'echo "Executando testes..."'
                
                // Exemplo para Maven
                // sh 'mvn test'
                
                // Exemplo para Gradle
                // sh './gradlew test'
            }
            
            post {
                always {
                    // Publicar resultados de testes (opcional)
                    echo 'Processando resultados dos testes'
                    // junit '**/target/surefire-reports/*.xml'
                }
            }
        }
        
        stage('Análise de Código') {
            steps {
                // Integração com ferramentas de análise como SonarQube
                sh 'echo "Executando análise de código..."'
                
                // Exemplo para SonarQube
                // withSonarQubeEnv('SonarQube') {
                //     sh 'mvn sonar:sonar'
                // }
            }
        }
        
        stage('Build da Imagem Docker') {
            steps {
                // Construir imagem Docker da aplicação
                sh 'echo "Construindo imagem Docker..."'
                
                // Exemplo de comando para build de imagem
                // sh "docker build -t ${env.APP_NAME}:${env.VERSION} ."
            }
        }
        
        stage('Deploy') {
            steps {
                // Deploy da aplicação - ajuste conforme seu ambiente
                sh 'echo "Realizando deploy da aplicação..."'
                
                // Exemplo de deploy com Docker
                // sh "docker run -d -p 8080:8080 --name ${env.APP_NAME} ${env.APP_NAME}:${env.VERSION}"
            }
        }
    }
    
    // Ações após a execução da pipeline
    post {
        success {
            echo 'Pipeline executada com sucesso!'
            // Notificações ou ações em caso de sucesso
            // slackSend channel: '#ci-cd', color: 'good', message: "Pipeline concluída com sucesso: ${env.JOB_NAME} ${env.BUILD_NUMBER}"
        }
        
        failure {
            echo 'Pipeline falhou!'
            // Notificações ou ações em caso de falha
            // slackSend channel: '#ci-cd', color: 'danger', message: "Falha na pipeline: ${env.JOB_NAME} ${env.BUILD_NUMBER}"
        }
        
        always {
            // Ações que sempre devem ser executadas, independente do resultado
            echo 'Limpando workspace...'
            // cleanWs()
        }
    }
}