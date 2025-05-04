#############################################
# Stage 1: Build native image with GraalVM 21
#############################################
FROM ghcr.io/graalvm/java-21-graalvm AS builder

# Install prerequisites for native-image
RUN gu install native-image \
    && apt-get update \
    && apt-get install -y --no-install-recommends \
       build-essential \
       unzip \
       zip \
    && rm -rf /var/lib/apt/lists/*

# Create working directory
WORKDIR /app

# Copy Gradle wrapper and project files
COPY gradlew .
COPY gradle gradle
COPY build.gradle settings.gradle .
COPY src src

# Make Gradle wrapper executable
RUN chmod +x gradlew

# Build the application and the native image
RUN ./gradlew clean build nativeImage --no-daemon

#################################################
# Stage 2: Run the native binary on slim JRE base
#################################################
FROM debian:bullseye-slim

# Install ca-certificates for HTTPS
RUN apt-get update && apt-get install -y --no-install-recommends ca-certificates \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /app

# Copy native executable from builder
COPY --from=builder /build/native/nativeCompile/demo-graalvm /app/demo-graalvm

# Expose the application port (adjust if needed)
EXPOSE 8080

# Command to run
ENTRYPOINT ["./demo-graalvm"]
