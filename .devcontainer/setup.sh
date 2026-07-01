echo "Starting..."
cd /workspaces/RTWrapper
sudo apt update
sdk install java 21.0.2-tem
sdk use java 21.0.2-tem
chmod +x gradlew
./gradlew vscode