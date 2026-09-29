---
name: integrate-api
description: Bước 4 của Flutter App Factory. Đọc/fetch OpenAPI/Swagger, map endpoint vào feature, tạo Dio service/data source, DTO, mapper, repository implementation, Riverpod wiring và sample/mock từ response thật. Dùng sau plan-app hoặc khi user yêu cầu tích hợp API.
---

# integrate-api

Input: API spec URL/file + `output/plan.md`.
Output:
- `output/api/openapi.json` (hoặc yaml copy);
- `output/api/endpoints.md`;
- `output/api/samples/*.json`;
- code dưới `features/<feature>/data` + provider wiring;
- unit tests data/repository quan trọng.

## Quy tắc kiến trúc

- Screen/ViewModel không gọi Dio.
- Mỗi external source có service/data source rõ ràng.
- DTO ở data; domain entity không annotate theo transport protocol.
- Map DioException -> AppException/Result tại data boundary.
- Không catch programming error rồi biến mọi thứ thành “network error”.
- Auth header/interceptor dùng shared network layer; không copy token injection vào từng service.

## Quy trình

### 1. Lấy spec

Nếu user cho URL docs, tìm URL JSON/YAML thật (`openapi.json`, `swagger.json`, endpoint config). Lưu snapshot vào `output/api/` và ghi source URL + timestamp.

Không sửa contract để code “dễ hơn”. Nếu live response khác spec, ghi diff.

### 2. Inventory endpoint

Sinh `endpoints.md`:

| operation | method/path | request | response | auth | feature | status |

Chỉ implement endpoint thuộc scope `plan.md`.

### 3. Code strategy

Base mặc định **không bắt buộc generator**. Chọn một trong hai và ghi vào `output/api/README.md`:

A. Small/medium API: viết service + DTO có kiểm soát bằng Dart thuần.
B. Large contract: dùng OpenAPI generator `dart-dio` hoặc generator team đã chuẩn hóa, đặt generated code tách khỏi hand-written repository/mapper.

Không trộn generated model trực tiếp vào presentation.

### 4. Service / DTO / mapper

Ví dụ dependency path:

```text
Dio
 -> FooRemoteDataSource
 -> FooDto.fromJson
 -> FooRepositoryImpl
 -> Foo domain entity
```

Validate field nullable/required theo **response thật**, không chỉ spec.

### 5. Sample thật

Gọi API với credential/config user cung cấp khi được phép. Lưu response đã scrub secret/PII vào `output/api/samples/` để:
- repository test;
- mock mode UI;
- diff spec-vs-live.

Không commit auth token/API key vào sample hoặc source.

### 6. Riverpod wiring

Providers chỉ compose dependency:

```dart
final fooRepositoryProvider = Provider<FooRepository>((ref) {
  return FooRepositoryImpl(ref.watch(fooRemoteDataSourceProvider));
});
```

Không nhét transform/business flow dài vào closure.

### 7. Test

Tối thiểu:
- DTO parse happy + missing/nullable case quan trọng;
- repository maps success/failure;
- ViewModel test ở design-layout khi feature consumption được viết.

Chạy:

```bash
./scripts/check.sh
```

## Output diff

`output/api/spec-live-diff.md` ghi:
- field spec có nhưng live thiếu;
- field live có nhưng spec thiếu;
- type mismatch;
- enum/value ngoài spec;
- status/error body thực tế.

## Không làm

- Không expose Dio Response lên domain/presentation.
- Không bịa endpoint/field.
- Không hardcode prod base URL/token.
- Không add local DB/cache nếu plan không cần.
