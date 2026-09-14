# DocTab

DocTab is a private, user-controlled workspace for notes, reminders, memory, and future AI assistance.

## Current V1 scope

The first usable slice is intentionally small:

- Home
- Notes list
- Add Note
- Note detail/edit
- Search
- Local note persistence

The current acceptance flow is:

`Open DocTab -> Add Note -> Save -> Close/reopen -> Note still exists -> Edit -> Search -> Open again`

## Architecture boundaries

This app work does **not** change:

- DocPets production
- shared authentication
- production DocAxis extraction
- production MCP
- Apple signing or provisioning
- Codemagic
- the live DocTab website

DocTab remains the system of record. Future AI integrations are clients of DocTab, not the owner of its data.

## Local verification

After pulling changes:

```bash
flutter pub get
flutter analyze
flutter test
flutter run
```

The V1 notes branch uses `shared_preferences` only for local disposable persistence. Backend/auth integration is deliberately out of scope for this slice.
