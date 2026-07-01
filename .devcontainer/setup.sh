echo "Starting..."
cd /workspaces/RTWrapper
sudo apt update
sdk install java 21.0.3-tem
sdk use java 21.0.3-tem
chmod +x gradlew
./gradlew vscode