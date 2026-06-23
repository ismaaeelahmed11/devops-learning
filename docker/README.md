# Docker & Containers Module

Completed the Docker module — from installing Docker to building and orchestrating multi-container applications. The core assignment was the CoderCo Containers Challenge: a Flask + Redis web app with visit counting.

---

## Topics Covered

### Docker Setup & Fundamentals
- Installing Docker and verifying with `docker run hello-world`
- Understanding images vs containers — images are blueprints, containers are running instances
- The Dockerfile — `FROM`, `WORKDIR`, `COPY`, `RUN`, `EXPOSE`, `CMD`

### Web App Containerisation
- Created a simple Python Flask web application
- Wrote a Dockerfile to package the app with its dependencies
- Built and ran the container locally

### Docker Networking & Linking
- How containers communicate on shared networks
- Linking containers together — service names become hostnames
- Debugging MySQL connection errors (hostnames, ports, dependencies)

### Docker Compose
- Why Compose matters — run multiple containers with one command
- Writing `docker-compose.yml` — services, ports, environment variables, `depends_on`
- Debugging container name conflicts and networking issues

### Docker Registries
- Docker Hub and Amazon ECR — storing and sharing images
- Tagging images for registries
- Pushing and pulling images
- Debugging registry authentication and networking issues

### Commands & Multi-Stage Builds
- Essential Docker commands: `build`, `run`, `ps`, `stop`, `rm`, `logs`, `exec`
- Multi-stage builds — separating build dependencies from the final image
- Reducing image size by copying only what's needed

### Orchestration Tools (Overview)
- Brief introduction to Kubernetes and Docker Swarm
- Why orchestration matters for scaling and managing containers

---

## What I Built

### CoderCo Containers Challenge
A multi-container application consisting of:

- **Flask web app** — two routes:
  - `/` — returns a welcome message
  - `/count` — increments and displays a visit counter stored in Redis
- **Redis** — key-value store for the visit counter
- **Dockerfile** — containerises the Flask app
- **docker-compose.yml** — orchestrates both services

### Architecture
Browser → localhost:5000 → Flask container → Redis container

### How to run
docker compose up --build

Then visit:
- http://localhost:5000 → welcome message
- http://localhost:5000/count → visit counter (increments on refresh)

### Screenshots
- Welcome page at `/`
- Visit counter at `/count`
- Counter incrementing after multiple refreshes

---

## What I Learnt

### Docker Fundamentals
- Images are read-only templates, containers are running instances with a writable layer
- The Dockerfile is a recipe — each instruction creates a layer
- Multi-stage builds keep final images small and secure

### Docker Compose
- Orchestrates multiple containers with shared networking
- Service names become DNS-resolvable hostnames
- Environment variables pass configuration cleanly
- `depends_on` controls startup order

### Registries
- Docker Hub is the default public registry
- ECR is AWS's private registry — requires authentication via `aws ecr get-login-password`
- Images are tagged as `registry/image:tag` before pushing

### Networking
- Docker Compose creates a default network for all services
- Containers communicate using service names, not IPs
- `docker run` alone doesn't create shared networks — use Compose for multi-container apps

---

## Challenges & Solutions

### Challenge: Flask couldn't connect to database
Running `docker run` alone — Flask tried to reach `db` hostname but it didn't exist.

**Fix:** Used `docker compose up` — it creates a shared network where service names resolve automatically.

### Challenge: Multi-stage build missing Python packages
After switching to a multi-stage Dockerfile, the final image was smaller but Flask and mysqlclient were missing.

**Cause:** The final stage only copied `/app`, not the installed site-packages.

**Fix:** Added `COPY --from=build /usr/local/lib/python3.12/site-packages` and `/usr/local/bin` to the final stage, plus runtime library `libmariadb3`.

### Challenge: Port already allocated
Running a new container on port 5000 failed because an old container was still using it.

**Fix:** `docker stop $(docker ps -q)` to stop all running containers, or use a different port.

---

## Key Commands

# Build an image
docker build -t myapp .

# Run a container
docker run -p 5000:5000 myapp

# List running containers
docker ps

# View logs
docker compose logs

# Stop and remove everything
docker compose down

# Push to ECR
aws ecr get-login-password --region eu-north-1 | docker login --username AWS --password-stdin <registry-url>
docker tag myapp <registry-url>/myapp:latest
docker push <registry-url>/myapp:latest
