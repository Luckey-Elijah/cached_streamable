## 1.1.0

- Remove `abstract` from class definition to allow inline streamable creation

**Example**:

```dart
final counter = CachedStreamable<int>(0);
counter.value++;
```

### BREAKING CHANGE

- Use `value` instead of `cache`

## 1.0.2+2

- Update description

## 1.0.2+1

- Fixes `README` typos
- Removes `documentation` URL in `pubspec.yaml`

## 1.0.2

- Updates `meta` to `1.7.0` for compatibility

## 1.0.1

- Removes `mocktail` dependency
- Moves `meta` to `dependencies` (from `dev_dependencies`)

## 1.0.0

- Initial version with `CachedStreamable<T>`
