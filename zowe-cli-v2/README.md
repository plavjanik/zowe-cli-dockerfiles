# Docker Image with Zowe CLI

The purpose of this image is to make Zowe CLI, plug-ins, and related tools available without installing it and its dependencies on
any system.

You can use it on your workstation without the need to install Zowe CLI or use it from Jenkins as an image for an agent.

Why use Docker containers as Jenkins build agents?

- All the dependencies are packaged in a Docker image
  - No problems with different versions
  - No need to install them manually
  - No conflicts between projects that require different versions
- You can run your build on any machine that supports Docker

What is included:
- Debian GNU/Linux 10 (buster)
- Node.js v16
- zx
- Python 3.7 from the OS
- Zowe V2 (@next)
- Endevor Plug-in for Zowe CLI

## Usage

### CLI

#### Build the image

```bash
docker build . -t zowe-cli:local
```

#### Start the container

```bash
docker run --platform=linux/amd64 --name=zowe-cli --rm -it -d --mount type=bind,source="$PWD",target=/workspace,consistency=delegated zowe-cli:local
```

**Note:** The current directory on your computer is mounted as `/workspace` in the container which is the current directory in the container.

#### Issue a Zowe CLI command

```bash
docker exec zowe-cli zowe --version
```

The container starts the Zowe daemon and the Zowe commands are be executed faster.

#### Issue any shell command

```bash
docker exec zowe-cli ls
```

#### Stop the container

```bash
docker stop zowe-cli
```

### Jenkins

The Jenkins agent is defined to be a Docker container that is using this image (`zowe-cli`) for your private registory (e.g.  Artifactory).

You need to define credentials to Artifactory in your Jenkins with the ID `artifactoryCredentials`:

```groovy
agent {
    docker {
        image 'zowe-cli:latest'
        label 'docker'  // Use a label that is used by Jenkins agents with Docker
        registryUrl 'https://your-docker-registry/'
        registryCredentialsId 'artifactoryCredentials'
    }
}
```
