# TomDeploy

TomDeploy is a simple shell script that helps you build and deploy Java WAR files to an Apache Tomcat server.  
It supports both local and remote deployments using SSH key or username/password authentication.  
You only need to configure a `.env` file and run the script.

No need for complex tools like Jenkins, GitLab CI, or Docker. Just one file and a few variables.

## Features

- Build Java projects using Maven
- Deploy WAR files to a local or remote Tomcat server
- Support for both SSH private key and username/password authentication
- Simple configuration using a `.env` file
- Useful for small projects, internal tools, or development environments

## Prerequisites

Make sure the following are installed on your system:

- Java and Maven
- Apache Tomcat (on local or remote machine)
- ssh, scp
- sshpass (only required if using password authentication)

## .env Configuration

Create a `.env` file in the same directory as the script. Below is an example:

```dotenv
# Path to the Maven project directory (contains pom.xml)
PROJECT_DIR=/home/user/myproject

# Type of deployment: "local" or "remote"
DEPLOY_TYPE=remote

# If DEPLOY_TYPE is "local"
TOMCAT_WEBAPPS_PATH=/opt/tomcat/webapps

# If DEPLOY_TYPE is "remote"
REMOTE_HOST=192.168.1.10
REMOTE_USER=tomcatuser
REMOTE_TOMCAT_WEBAPPS_PATH=/opt/tomcat/webapps

# Authentication method: "key" or "password"
AUTH_METHOD=key

# If using SSH key authentication
SSH_PRIVATE_KEY=~/.ssh/id_rsa

# If using password authentication
REMOTE_PASSWORD=yourpassword
