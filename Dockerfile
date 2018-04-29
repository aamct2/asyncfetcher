# Identifier
FROM swift:4.1
LABEL Description="Docker image for building and testing the AsyncFetcher framework."

# Copy Directories
COPY ./Sources /root/Sources
COPY ./Tests /root/Tests

# Copy Files
COPY ./Package.swift /root/Package.swift

# Perform Initial Build
RUN swift build --package-path /root
