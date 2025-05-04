node {
    // Configura GraalVM instalado em Global Tool Configuration como 'GRAALVM21'
    def graalHome = tool name: 'GRAALVM21', type: 'jdk'
    env.JAVA_HOME = graalHome
    env.GRAALVM_HOME = graalHome
    env.PATH = "${graalHome}/bin:${env.PATH}"

    stage('Verificar Ambiente') {
        echo "=== JAVA_HOME = ${env.JAVA_HOME} ==="
        sh 'java -version'
        sh 'native-image --version'
    }

    stage('Checkout') {
        checkout scm
    }

    stage('Build JVM') {
        echo 'Compilando aplicação na JVM'
        sh './gradlew clean assemble'
    }

    stage('Build Native Image') {
        echo 'Gerando imagem nativa com GraalVM'
        // Executa o task nativeCompile do Gradle, que usa a CLI native-image
        sh './gradlew clean nativeCompile'
    }

    stage('Test') {
        echo 'Executando testes'
        sh './gradlew test'
    }

    stage('Deploy') {
        echo 'Deploy step aqui'
    }
}
