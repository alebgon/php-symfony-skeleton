# Image Builder

This directory contains the Dockerfiles used to build and publish the base images
required by the **App** project.


### Github Login
Images are published to GitHub Container Registry (GHCR).
Make sure you are authenticated before pushing:

```bash
docker login ghcr.io
```

---

## Build

### NOTE: Ignore this if the images are already published.

If required, you can update the Dockerfiles and build custom images.

### Execution

Each image must be built and pushed from its own directory.

### 📦 Nginx Image (`base-nginx-1.26`)

```bash
docker build \
  -t ghcr.io/alebgon/base-nginx-1.26 \
  .
  
docker push ghcr.io/alebgon/base-nginx-1.26
```

### 📦 PHP CLI Image (`base-php-cli-8.4`)

```bash
docker build \
  -t ghcr.io/alebgon/base-php-cli-8.4 \
  .

docker push ghcr.io/alebgon/base-php-cli-8.4
```

### 📦 PHP FPM Image (`base-php-fpm-8.4`)

```bash
docker build \
  -t ghcr.io/alebgon/base-php-fpm-8.4 \
  .
  
docker push ghcr.io/alebgon/base-php-fpm-8.4
```