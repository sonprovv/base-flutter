# LOAD_DATA — GIF & Video loading ở màn Video (BabyDance)

## Tổng quan quyết định

Mỗi template item trong danh sách có thể có **mp4 URL** hoặc chỉ có **GIF/WebP URL**.
Hai trường hợp này dùng hai widget hoàn toàn khác nhau:

```
item.previewMp4Url không rỗng
  └─> VideoThumbnailCard   (native video, ExoPlayer/AVPlayer)

item.previewMp4Url rỗng
  └─> PlayOnVisibleCard    (GIF/WebP qua CachedNetworkImage)
```

---

## Trường hợp 1 — VideoThumbnailCard (có mp4)

### Nguyên tắc hoạt động

Card **không khởi tạo video ngay khi build**. Nó đợi cho đến khi ≥50% diện tích card hiển thị trên màn hình, rồi mới bắt đầu init controller.

```
Card được build
  └─> Hiển thị ảnh cover (JPEG/WebP tĩnh)

User scroll → card hiện ≥50%
  └─> Tạo VideoPlayerController với mp4 URL
  └─> setLooping(true) + setVolume(0)  ← luôn muted, luôn loop
  └─> initialize()  ← async, cover vẫn hiện trong lúc chờ
  └─> play()  ← chỉ play nếu vẫn còn visible sau khi init xong

User scroll ra → card < 50%
  └─> pause()  ← không dispose, chỉ dừng

User scroll vào lại
  └─> play()  ← dùng lại controller cũ, không init lại
```

### Điểm quan trọng
- Controller chỉ được tạo **một lần** cho mỗi card trong suốt vòng đời widget.
- Nếu init xong mà card đã bị scroll khỏi màn → **không play**.
- `mixWithOthers: true` — nhiều card play đồng thời không tranh giành audio session.
- Khi widget bị dispose (scroll quá xa, tab đổi) → controller bị dispose hẳn.

---

## Trường hợp 2 — PlayOnVisibleCard (chỉ có GIF)

### Nguyên tắc hoạt động

Card dùng **hai URL khác nhau** cho cùng một `CachedNetworkImage`:

```
Card off-screen (< 50% visible)
  └─> Hiển thị staticUrl  ← JPEG/PNG tĩnh, load nhanh, không animate

Card on-screen (≥ 50% visible)
  └─> Hiển thị gifUrl     ← animated WebP hoặc GIF, bắt đầu animate
```

Khi visibility thay đổi, widget chỉ **đổi URL** truyền vào `CachedNetworkImage`. Flutter rebuild widget với URL mới. `CachedNetworkImage` tự cache cả hai URL riêng biệt trên disk.

### Điểm quan trọng
- Không có controller, không có dispose — chỉ là swap URL.
- GIF không có cơ chế pause thực sự; khi off-screen URL bị đổi về static thì animation ngừng.
- Nếu `gifUrl == staticUrl` → card luôn hiện một ảnh tĩnh (fallback graceful).

---

## So sánh hai widget

| | VideoThumbnailCard | PlayOnVisibleCard |
|---|---|---|
| Nguồn media | mp4 (network stream) | GIF / animated WebP |
| Khi off-screen | Pause video | Show static cover |
| Khi on-screen | Init + play (lần đầu) / resume (lần sau) | Switch sang GIF URL |
| Có âm thanh | Không (muted cứng) | Không (GIF không có âm) |
| Tốn RAM | Cao hơn (decoder native) | Thấp hơn |
| Tốn network | Stream liên tục | Tải file GIF một lần, cache |

---

## Detail screen — DanceDetailScreen (khi tap vào card)

Khi user tap vào một item, chuyển sang màn detail với PageView:

```
Màn detail mở
  └─> Center card: tạo VideoPlayerController mới với mp4 URL
        └─> initialize → loop → play

User swipe sang card bên cạnh
  └─> Dispose controller cũ
  └─> Tạo VideoPlayerController mới cho item mới
  └─> Side cards: hiển thị GIF/WebP (CachedNetworkImage, không có video)

Màn detail đóng
  └─> Dispose controller hiện tại
```

**Chỉ một controller tồn tại tại một thời điểm** — không giữ controller cho side cards.

---

## Fallback hierarchy (áp dụng cho cả hai trường hợp)

```
preview_webp_url  (animated WebP — nhỏ nhất)
  └─ rỗng / lỗi → cover_url  (JPEG tĩnh)
                    └─ rỗng / lỗi → màu nền surfaceVariant
```

---

## Những điều KHÔNG được làm

- ❌ Khởi tạo `VideoPlayerController` trong `initState` hoặc `build` — luôn lazy theo visibility
- ❌ Giữ nhiều controller cùng lúc trong detail screen
- ❌ Dùng `jumpToPage()` sau khi load xong danh sách — gây flash từ trang 0
- ❌ Play video khi card vừa init xong nhưng đã bị scroll ra ngoài
