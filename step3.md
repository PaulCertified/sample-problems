# Step 3: Run Program 1 With Debug Mode

## Running Program 1 with Debug Enabled
I ran program1 with debug logging enabled using:
```bash
docker run -e PROGRAM_DEBUG=true sample-problems program1
```

## Debug Output
```
time="2025-06-04T23:07:47Z" level=info msg="Debugging enabled"
time="2025-06-04T23:07:47Z" level=info msg="Initialising application..."
time="2025-06-04T23:07:47Z" level=info msg="Loading credentials from database"
time="2025-06-04T23:07:49Z" level=info msg="Starting authentication thread"
time="2025-06-04T23:07:49Z" level=trace msg="Loaded 752 entries from database"
time="2025-06-04T23:07:50Z" level=trace msg="Authentication thread started"
time="2025-06-04T23:07:50Z" level=info msg="Starting listener on port 6000"
time="2025-06-04T23:07:50Z" level=info msg="Starting listener on port 6001"
time="2025-06-04T23:07:51Z" level=trace msg="Port 6000 already in use"
time="2025-06-04T23:07:51Z" level=fatal msg="Failed to intialise application"
```

## Analysis of Debug Information

### Key Findings
1. **Root Cause Identified**: The debug logs clearly indicate that the initialization failure is due to "Port 6000 already in use" - a port conflict issue.

2. **Application Flow Details**: With debug mode enabled, we get additional trace-level logs that provide more context about the application's startup process:
   - The application successfully loads 752 entries from the database
   - The authentication thread starts successfully
   - The application then attempts to start listeners on ports 6000 and 6001
   - The initialization fails because port 6000 is already in use by another process

3. **Database Connection**: Unlike our initial hypothesis, the database connectivity does not appear to be an issue. The trace logs confirm that the application successfully loaded data from the database.

4. **Authentication Process**: The authentication thread appears to start correctly, so authentication is not the source of the error.

5. **Timing Pattern**: The debug logs confirm the timing pattern observed in the non-debug mode, with delays between initialization steps.

## Updated Hypotheses

Based on the debug information, I can refine my hypotheses about program1's failure:

1. **Confirmed Issue - Port Conflict**: 
   - Program1 requires port 6000 to be available but it's already in use by another process
   - This is preventing the application from properly initializing
   - This is the direct cause of the fatal error

2. **Potential Underlying Causes**:
   - The application may not have proper error handling for when ports are unavailable
   - There may be another instance of the same application already running
   - Another service in the Docker container or on the host might be binding to port 6000
   - The application might not be designed to use alternative ports when the default is unavailable

3. **Excluded Hypotheses**:
   - Database connectivity issues (disproven by successful loading of entries)
   - Authentication failures (disproven by successful thread start)
   - Missing dependencies or configuration (these are not mentioned in the logs)

## Conclusion

Program1 is failing to initialize because it cannot bind to port 6000, which is already in use. This is a common issue in networked applications and could be resolved by:
1. Ensuring no other processes are using port 6000
2. Configuring the application to use a different port
3. Implementing better error handling for port conflicts

In a real-world scenario, this would be relatively straightforward to fix by either stopping the conflicting service or configuring the application to use a different port. However, as mentioned in the README, these programs are designed to always error and cannot be fixed as part of this exercise.
