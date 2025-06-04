# Step 2: Run Program 1 Without Debug Mode

## Docker Build
First, I built the Docker image using the command:
```bash
docker build -t sample-problems .
```

This completed successfully, creating a Docker image named `sample-problems` based on the Dockerfile that uses Ubuntu 20.04 as its base image.

## Running Program 1
I ran program1 without any debug flags using:
```bash
docker run sample-problems program1
```

## Observed Error Behavior

### Output
```
time="2025-06-04T23:00:59Z" level=info msg="Initialising application..."
time="2025-06-04T23:00:59Z" level=info msg="Loading credentials from database"
time="2025-06-04T23:01:01Z" level=info msg="Starting authentication thread"
time="2025-06-04T23:01:03Z" level=info msg="Starting listener on port 6000"
time="2025-06-04T23:01:03Z" level=info msg="Starting listener on port 6001"
time="2025-06-04T23:01:04Z" level=fatal msg="Failed to intialise application"
```

### Exit Code
The program exited with exit code 1, indicating an error condition.

## Initial Observations and Hypotheses

Based on the default error behavior, I can make the following initial observations and hypotheses about program1:

1. **Application Initialization Process**: The application goes through several initialization steps:
   - Initial startup
   - Loading credentials from a database
   - Starting an authentication thread
   - Starting listeners on ports 6000 and 6001

2. **Failure Point**: The application fails during initialization with a fatal error after starting listeners on the specified ports.

3. **Possible Causes**:
   - **Database Connectivity Issues**: The log mentions "Loading credentials from database," but there's no indication of a successful connection or if the database exists in the container.
   - **Port Conflicts**: The application attempts to start listeners on ports 6000 and 6001. There might be issues binding to these ports.
   - **Missing Dependencies**: There may be missing libraries or dependencies not included in the base Ubuntu image.
   - **Authentication Issues**: After starting the "authentication thread," something might be failing in the authentication process.
   - **Configuration Problems**: There might be missing configuration files or environment variables needed for proper initialization.

4. **Timing Information**: There's a noticeable delay between each step in the initialization process:
   - ~2 seconds between loading credentials and starting the authentication thread
   - ~2 seconds between starting the authentication thread and the listeners
   - ~1 second between starting the listeners and the fatal error

5. **Limited Error Details**: The default error output is not very specific about what caused the initialization to fail. Running with debug mode enabled will likely provide more detailed information.

## Next Steps

To further diagnose the issue with program1, we will:
1. Run program1 with debug mode enabled to get more detailed logging information
2. Look for specific errors or warnings that might indicate what's causing the initialization failure
3. Determine if the problem is related to missing dependencies, configuration, or other environmental factors
