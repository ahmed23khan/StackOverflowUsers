# StackOverflow Users

Shows the top 20 StackOverflow users by reputation. Users can be followed and unfollowed locally, and that state persists between launches.

## Running

Open `StackOverflowUsers.xcodeproj` in Xcode 15+, choose an iOS 16+ simulator, and run the app.  
Run tests with `Cmd+U`.

No third-party dependencies.

## Architecture

I used MVVM with a Coordinator.

The ViewModel handles loading data, preparing it for display, and managing screen state. The ViewController is responsible for rendering the UI and handling user interaction.

I added a repository layer between the ViewModel and the network code to keep the ViewModel easier to test.

## Concurrency

The app uses `URLSession` with async/await. The ViewModel is marked `@MainActor` so UI state updates stay on the main thread.

## Persistence

Followed user IDs are stored in `UserDefaults` as a `Set<Int>`. I kept this simple since the feature is local-only and lightweight.

## Testing

Tests cover ViewModel state changes, JSON parsing, follow persistence, and reputation formatting. Mocks are hand-written.
