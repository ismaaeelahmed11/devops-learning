# Stage 1: Build the Go binary
# Use the official Go image as the builder environment
FROM golang:1.23-alpine AS builder

# Set the working directory inside the container
WORKDIR /app

# Copy just the Go source file into the container
COPY app/main.go .

# Compile the Go app into a static Linux binary called "server"
# CGO_ENABLED=0  -> no C dependencies (needed for scratch)
# GOOS=linux     -> build for Linux
# -o server      -> name the output binary "server"
RUN CGO_ENABLED=0 GOOS=linux go build -o server main.go

# Stage 2: Create a minimal image with the Go binary
# "scratch" is an empty image — no OS, no shell, nothing
FROM scratch

# Copy only the compiled binary from stage 1 into the empty image
COPY --from=builder /app/server /server

# Document that the container listens on port 80
EXPOSE 8080

# Run as a non-root user (UID 1000)
USER 1000

# Command to run when the container starts
ENTRYPOINT ["/server"]