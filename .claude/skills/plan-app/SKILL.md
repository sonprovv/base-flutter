---
name: plan-app
description: Bước 3 của Flutter App Factory, checkpoint 1. Từ screens.json + design-system + API spec, quyết định flow, feature boundaries, routes, Clean Architecture mapping, platform requirements và differentiation. Xuất output/plan.md rồi dừng chờ duyệt.
---

# plan-app

Input: `output/screens.json`, `output/screens.md`, `output/design-system.md`, API spec/URL nếu có, product name/package/bundle info user cung cấp.
Output: `output/plan.md`.

**Sau khi ghi plan, dừng ở checkpoint 1. Không tự code tiếp nếu workflow đang chạy theo chế độ review.**

## Quy trình

1. Tóm tắt core user journey từ screenshot.
2. Resolve `missing_screens` theo quyết định user.
3. Chia feature theo **user capability**, không theo loại widget. Ví dụ: `onboarding`, `home`, `editor`, `history`, `settings`.
4. Map screen -> `GoRoute`/nested route/shell route.
5. Map feature -> data sources/repository/use case cần thiết.
6. Đọc API spec và map endpoint -> feature. Endpoint chưa rõ thì ghi question, không bịa contract.
7. Xác định state persistence:
   - session memory;
   - secure storage;
   - local cache/database;
   - backend source of truth.
8. Xác định platform requirement: camera/photos/files/share/notification/deep link/ATT/ads; ghi Android + iOS permission/capability tương ứng.
9. Xác định differentiation/product identity: flow, naming, copy, palette adjustments, original assets; không copy brand/app tham khảo.
10. Ưu tiên P0/P1/P2 để `design-layout` và test biết scope.

## Architecture decision

Mặc định mỗi feature:

```text
features/<feature>/
  domain/
    entities/
    repositories/
    usecases/        # chỉ khi cần
  data/
    datasources/
    models/
    repositories/
  presentation/
    screens/
    view_models/
    widgets/
```

Cho feature cực đơn giản/read-only có thể bỏ usecase và thậm chí domain entity riêng nếu DTO không leak abstraction; nhưng plan phải ghi rõ lý do. Không tạo boilerplate máy móc.

## Mẫu plan.md

```md
# Plan — <App> (<android applicationId> / <iOS bundleId>)

## 1. Product summary
## 2. Screen decisions
| source screen | new screen | keep/change/hide/design | feature | priority |

## 3. Navigation
- entry:
- routes:
- redirects/deep links:

## 4. Feature architecture
| feature | view model | repository | services | use case | persisted state |

## 5. API mapping
| feature | endpoint | model | live sample needed | notes |

## 6. Design/product differentiation
## 7. Assets plan
## 8. Platform matrix
| capability | Flutter plugin/native | Android | iOS | permission/capability |

## 9. Test plan
- unit:
- widget:
- integration P0:

## 10. Monetization plan (if applicable)
## 11. Risks / blockers / questions
## 12. Ordered implementation list
```

## Quy tắc

- Không tự thêm dependency chưa cần; ghi candidate + lý do trong plan.
- Không tự chọn package thay user nếu có ràng buộc business/licensing mà input chưa nói; với plumbing chuẩn có thể dùng stack base.
- Không xem iOS như bản phụ của Android: capability/permission/release phải có cột riêng.
- Route nào không có screen hoặc resolution -> plan chưa pass.
