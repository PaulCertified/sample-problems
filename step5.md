# Step 5: Run Program 2 With Debug Mode

## Running Program 2 with Debug Enabled
I ran program2 with debug logging enabled using:
```bash
docker run -e PROGRAM_DEBUG=true sample-problems program2
```

## Debug Output
```
time="2025-06-04T23:15:34Z" level=info msg="Debugging enabled"
time="2025-06-04T23:15:34Z" level=info msg="Initialising application..."
time="2025-06-04T23:15:34Z" level=info msg="Loading credentials from database"
time="2025-06-04T23:15:36Z" level=info msg="Starting authentication thread"
time="2025-06-04T23:15:36Z" level=trace msg="Loaded 752 entries from database"
time="2025-06-04T23:15:37Z" level=trace msg="Authentication thread started"
time="2025-06-04T23:15:37Z" level=info msg="Starting listener on port 6000"
time="2025-06-04T23:15:37Z" level=info msg="Starting listener on port 6001"
time="2025-06-04T23:15:38Z" level=info msg="Listening on port 6000"
time="2025-06-04T23:15:38Z" level=info msg="Listening on port 6001"
time="2025-06-04T23:15:38Z" level=info msg="Discovering main database"
time="2025-06-04T23:15:39Z" level=trace msg="Connected to master config server 'config.local'"
time="2025-06-04T23:15:39Z" level=trace msg="Successfully read configuration, got 4 entries"
time="2025-06-04T23:15:39Z" level=info msg="Found database 'main.local'"
time="2025-06-04T23:15:39Z" level=info msg="Connecting to database 'main.local"
time="2025-06-04T23:15:39Z" level=trace msg="Connecting to 'main.local' on port 5432"
time="2025-06-04T23:15:40Z" level=trace msg="Timeout connecting to 'main.local' on port 5432"
time="2025-06-04T23:15:41Z" level=trace msg="Timeout connecting to 'main.local' on port 5432"
time="2025-06-04T23:15:42Z" level=trace msg="Timeout connecting to 'main.local' on port 5432"
time="2025-06-04T23:15:42Z" level=fatal msg="Failed to intialise application"
```

## Analysis of Debug Information

### Key Findings
1. **Root Cause Identified**: The debug logs clearly indicate that the initialization failure is due to timeout errors when trying to connect to the 'main.local' database on port 5432 (which is the default PostgreSQL port).

2. **Application Flow Details**: With debug mode enabled, we get additional trace-level logs that provide more context about the application's startup process:
   - The application successfully loads 752 entries from a local credentials database
   - The authentication thread starts successfully
   - Both listeners on ports 6000 and 6001 start successfully
   - The application connects to a "master config server" named 'config.local'
   - It reads configuration data (4 entries)
   - It identifies the main database as 'main.local'
   - It tries to connect to 'main.local' on port 5432 but times out after three attempts

3. **Database Connection Architecture**: The debug logs reveal a multi-tier database architecture:
   - There appears to be a local credentials database that works fine
   - There's a config server ('config.local') that the application successfully connects to
   - The main database ('main.local') that the application cannot connect to

4. **Connection Attempts**: The application makes three separate attempts to connect to the database before giving up and terminating with a fatal error.

## Updated Hypotheses

Based on the debug information, I can refine my hypotheses about program2's failure:

1. **Confirmed Issue - Database Connection Timeout**: 
   - Program2 requires a connection to a PostgreSQL database named 'main.local' on port 5432
   - The database is either not running, not reachable, or not responding
   - After three timeout attempts, the application fails with a fatal error

2. **Potential Underlying Causes**:
   - Missing Database: The 'main.local' database service is not running in the container or network
   - Hostname Resolution: There might be issues resolving the 'main.local' hostname
   - Network Configuration: The database might be running but on a different network that's not accessible
   - Firewall/Security: There might be firewall rules blocking access to port 5432
   - Database Service Config: PostgreSQL might be configured not to listen on the expected interface

3. **Excluded Hypotheses**:
   - Port binding issues (shown to work correctly)
   - Database authentication problems (connection times out before authentication)
   - Missing database drivers (the code gets to the connection attempt stage)

## Conclusion

Program2 is failing to initialize because it cannot connect to a PostgreSQL database named 'main.local' on port 5432, resulting in connection timeouts. This is a common issue in multi-tier applications and could be resolved by:

1. Ensuring the PostgreSQL database service is running and accessible
2. Configuring proper network connectivity between the application and database
3. Verifying hostname resolution for 'main.local'
4. Adding retry logic with better error handling for database connection failures

In a real-world scenario, this would typically involve setting up the required PostgreSQL database service and ensuring proper network configuration. However, as mentioned in the README, these programs are designed to always error and cannot be fixed as part of this exercise.
