#!/bin/bash
set -e

# Load .env variables
if [ -f .env ]; then
  export $(grep -v '^#' .env | xargs)
else
  echo ".env file not found!"
  exit 1
fi

# Build project
echo "Building project..."
cd "$PROJECT_DIR"
mvn clean package

WAR_FILE=$(find target -name "*.war" | head -n 1)

# Deployment
if [ "$DEPLOY_TYPE" = "local" ]; then
  echo "Deploying WAR to local Tomcat..."
  cp "$WAR_FILE" "$TOMCAT_WEBAPPS_PATH"
  
  echo "Setting ownership to Tomcat user..."
  sudo chown tomcat:tomcat "$TOMCAT_WEBAPPS_PATH/$(basename "$WAR_FILE")"
  
  echo "Deployment complete."

else
  echo "Deploying WAR to remote Tomcat..."

  if [ "$AUTH_METHOD" = "key" ]; then
    echo "Using SSH key authentication..."
    scp -i "$SSH_PRIVATE_KEY" "$WAR_FILE" "$REMOTE_USER@$REMOTE_HOST:$REMOTE_TOMCAT_WEBAPPS_PATH"
    ssh -i "$SSH_PRIVATE_KEY" "$REMOTE_USER@$REMOTE_HOST" "sudo chown tomcat:tomcat $REMOTE_TOMCAT_WEBAPPS_PATH/$(basename "$WAR_FILE") && sudo systemctl restart tomcat"
  
  elif [ "$AUTH_METHOD" = "password" ]; then
    echo "Using password authentication..."
    if ! command -v sshpass &> /dev/null; then
      echo "sshpass is required for password authentication. Please install it and try again."
      exit 1
    fi

    sshpass -p "$REMOTE_PASSWORD" scp "$WAR_FILE" "$REMOTE_USER@$REMOTE_HOST:$REMOTE_TOMCAT_WEBAPPS_PATH"
    sshpass -p "$REMOTE_PASSWORD" ssh "$REMOTE_USER@$REMOTE_HOST" "sudo chown tomcat:tomcat $REMOTE_TOMCAT_WEBAPPS_PATH/$(basename "$WAR_FILE") && sudo systemctl restart tomcat"
  
  else
    echo "Invalid AUTH_METHOD. Use 'key' or 'password'."
    exit 1
  fi

  echo "Remote deployment complete."
fi
