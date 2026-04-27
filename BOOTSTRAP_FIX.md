# Flutter Service Protocol Connection Error - Fix

## Problem
The Marx app was failing to start with:
```
Error connecting to the service protocol: failed to connect to http://127.0.0.1:59934/A-7lxYJ4G5c=/ 
HttpException: Connection closed before full header was received
```

## Root Cause
The `AppBootstrap.initialize()` method was performing heavy I/O operations on the UI thread:
1. **Database initialization** (`AppDatabase()`) - Creates and opens SQLite connection
2. **Quote seeding** (`quoteRepository.ensureSeeded()`) - Loads ~100MB quotes.json, parses JSON, validates entries, writes to database
3. **History facts seeding** (`historyRepository.ensureSeeded()`) - Loads history_facts.json, parses JSON, writes to database
4. **Widget sync** (`WidgetSyncService.syncDailyContent()`) - Synchronizes widget data
5. **Multiple SharedPreferences calls** - Reads from persistent storage multiple times

While these operations are async, they were still executing sequentially on the UI thread (event loop), preventing the Flutter engine from responding to service protocol connection attempts within the timeout period.

## Solution
Moved heavy I/O operations to a separate isolate using `compute()` from `package:flutter/foundation.dart`:

### Key Changes in `lib/core/bootstrap/app_bootstrap.dart`:

1. **Created a top-level function** `_initializeDatabaseAndSyncInIsolate()` that contains all heavy I/O:
   - Database initialization
   - Repository seeding (in parallel with `Future.wait()`)
   - Daily content resolution
   - Widget sync

2. **Updated AppBootstrap.initialize()** to:
   - Keep quick operations on UI thread (notification service initialization)
   - Run heavy I/O in a separate isolate via `await compute(_initializeDatabaseAndSyncInIsolate, null)`
   - Continue with background tasks setup on UI thread

3. **Added imports**:
   - `import 'dart:async';`
   - `import 'package:flutter/foundation.dart';` (for `compute()`)

### Benefits
- UI thread remains responsive to service protocol connection attempts
- Loading screen displays immediately without freezing
- Database operations don't block the Flutter engine's event loop
- JSON parsing and validation happen in a separate isolate
- App can initialize without timing out the service protocol

## Testing
The fix allows:
1. `flutter run` to complete without service protocol errors
2. App to show loading screen during bootstrap
3. App to fully initialize and display main UI

## Technical Details
- `compute()` uses isolate infrastructure to run the callback function in a separate thread
- The callback must be a top-level function (can access static methods of classes)
- All objects passed between isolates must be serializable
- Improves perceived performance as UI is responsive during initialization
