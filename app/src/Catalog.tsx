import { useState } from "react";
import {
  db,
  Dialog,
  errText,
  fold,
  h1,
  img,
  km,
  money,
  type Branch,
  type Dish,
} from "./lib";
export function Catalog({
  branches,
  open,
  active,
  record,
  signed,
}: {
  branches: Branch[];
  open: (id: string) => void;
  active: string;
  record: (b: Branch, d: Dish) => void;
  signed: boolean;
}) {
  const [query, setQuery] = useState(""),
    [cap, setCap] = useState(""),
    [low, setLow] = useState(""),
    [radius, setRadius] = useState(3),
    [sort, setSort] = useState("near"),
    [more, setMore] = useState(false);
  const [origin, setOrigin] = useState<number[]>(h1),
    [accuracy, setAccuracy] = useState<number | null>(null),
    [gps, setGps] = useState(""),
    [busy, setBusy] = useState(false),
    [feedback, setFeedback] = useState(false),
    [message, setMessage] = useState("");
  function locate() {
    if (!navigator.geolocation) {
      setGps("Thiết bị chưa hỗ trợ định vị.");
      return;
    }
    setBusy(true);
    setGps("Đang lấy vị trí…");
    navigator.geolocation.getCurrentPosition(
      (p) => {
        setBusy(false);
        setOrigin([p.coords.latitude, p.coords.longitude]);
        setAccuracy(p.coords.accuracy);
        setGps(
          p.coords.accuracy > 100
            ? "Vị trí gần đúng. Bạn có thể đo lại."
            : "Đã dùng vị trí hiện tại.",
        );
      },
      () => {
        setBusy(false);
        setGps(
          "Chưa lấy được vị trí. Kiểm tra quyền định vị hoặc dùng mốc H1.",
        );
      },
      { enableHighAccuracy: true, maximumAge: 60000, timeout: 10000 },
    );
  }
  const words = fold(query).split(/\s+/).filter(Boolean),
    invalid =
      Number(low) < 0 ||
      Number(cap) < 0 ||
      (!!cap && Number(low) > Number(cap));
  const match = (d: Dish) =>
    words.every((t) =>
      fold(d.name)
        .split(/\s+/)
        .some((x) => x.startsWith(t)),
    ) &&
    (!cap || d.price <= +cap) &&
    (!low || d.price >= +low) &&
    (!(cap || low) || !["nồi", "mẹt nhóm"].includes(d.unit));
  const sponsored = (branch: Branch) =>
    branch.id === "v29" &&
    new Date().toISOString().slice(0, 10) <= "2027-12-31";
  const results = branches
    .map((b) => ({
      b,
      dist: km(origin, b),
      d: b.dishes.filter(match).sort((x, y) => x.price - y.price),
    }))
    .filter((x) => x.d.length && x.dist <= radius && !invalid)
    .sort(
      (a, b) =>
        Number(sponsored(b.b)) - Number(sponsored(a.b)) ||
        (sort === "price"
          ? a.d[0].price - b.d[0].price || a.dist - b.dist
          : a.dist - b.dist),
    );
  const selected = branches.find((b) => b.id === active);
  const tag = sponsored;
  function options(b: Branch) {
    const dest = new URL("https://www.google.com/maps/dir/");
    dest.search = new URLSearchParams({
      api: "1",
      destination: b.lat + "," + b.lon,
      travelmode: "walking",
    }).toString();
    if (b.place_id) dest.searchParams.set("destination_place_id", b.place_id);
    return dest.href;
  }
  if (selected) {
    const b = selected;
    return (
      <section>
        <button className="quiet" onClick={() => open("")}>
          ‹ Kết quả tìm món
        </button>
        <div className="details">
          <div>
            {img(b.dishes[0]?.photo) && (
              <img
                className="cover"
                src={img(b.dishes[0].photo)}
                alt="Ảnh món minh họa"
              />
            )}
          </div>
          <div>
            <h1>{b.name}</h1>
            <p>{b.address}</p>
            <small>
              Ghim Google Maps đối chiếu {b.verified_at} ·{" "}
              {km(origin, b).toFixed(1)} km đường chim bay
            </small>
            <div className="actions">
              <a
                className="button primary"
                href={b.map}
                target="_blank"
                rel="noreferrer"
              >
                Xem quán trên Maps
              </a>
              <a
                className="button"
                href={options(b)}
                target="_blank"
                rel="noreferrer"
              >
                Đi bộ đến quán
              </a>
            </div>
          </div>
        </div>
        <section className="panel">
          <h2>Thực đơn mẫu</h2>
          {[...b.dishes]
            .sort((a, c) => Number(match(c)) - Number(match(a)))
            .map((d) => (
              <div className="row" key={d.name}>
                <div>
                  <b>{d.name}</b>
                  <p>
                    {money(d.price)} / {d.unit}
                  </p>
                </div>
                <button onClick={() => record(b, d)}>Ghi chi</button>
              </div>
            ))}
        </section>
        {tag(b) && <Offer id={b.id} />}
        <button
          onClick={() => {
            setMessage("");
            setFeedback(true);
          }}
        >
          Báo sai địa điểm
        </button>
        {feedback && (
          <Dialog title="Báo sai địa điểm" close={() => setFeedback(false)}>
            {signed && db ? (
              <form
                onSubmit={async (e) => {
                  e.preventDefault();
                  const form = e.currentTarget,
                    note = String(new FormData(form).get("note")).trim();
                  if (!note) return;
                  const { error } = await db!
                    .from("location_reports")
                    .insert({ branch_id: b.id, note });
                  setMessage(error ? errText(error) : "Đã gửi báo sai.");
                  if (!error) form.reset();
                }}
              >
                <label>
                  Mô tả vị trí đúng
                  <textarea name="note" required maxLength={500} />
                </label>
                <button className="primary">Gửi báo sai</button>
                <p role="status">{message}</p>
              </form>
            ) : (
              <p>Đăng nhập để gửi báo sai địa điểm.</p>
            )}
          </Dialog>
        )}
      </section>
    );
  }
  return (
    <>
      <section className="hero">
        <div>
          <span className="eyebrow">BÁCH KHOA · DĨ AN</span>
          <h1>
            Bữa ngon
            <br />
            quanh trường
          </h1>
          <p>Tìm món vừa túi tiền, từ nơi bạn đang đứng.</p>
        </div>
        <img src="/food/com.jpg" alt="Cơm tấm minh họa" />
      </section>
      <section className="searchPanel">
        <label className="search">
          <span aria-hidden="true">⌕</span>
          <input
            type="search"
            placeholder="Tìm món ăn, ví dụ cơm gà…"
            aria-label="Tìm tên món"
            value={query}
            onChange={(e) => setQuery(e.target.value)}
          />
        </label>
        <div className="actions">
          <b>Mỗi phần</b>
          {[30000, 40000, 50000].map((x) => (
            <button
              className={+cap === x ? "sel" : ""}
              key={x}
              onClick={() => {
                setCap(+cap === x ? "" : String(x));
                setLow("");
              }}
            >
              Đến {x / 1000}k
            </button>
          ))}
          <button aria-expanded={more} onClick={() => setMore(!more)}>
            Bộ lọc
          </button>
        </div>
        {more && (
          <div className="fields">
            <label>
              Giá từ (₫)
              <input
                type="number"
                min="0"
                value={low}
                onChange={(e) => setLow(e.target.value)}
              />
            </label>
            <label>
              Giá đến (₫)
              <input
                type="number"
                min="0"
                value={cap}
                onChange={(e) => setCap(e.target.value)}
              />
            </label>
            <label>
              Bán kính
              <select
                value={radius}
                onChange={(e) => setRadius(+e.target.value)}
              >
                {[1, 2, 3, 5].map((x) => (
                  <option key={x} value={x}>
                    {x} km
                  </option>
                ))}
              </select>
            </label>
          </div>
        )}
        {invalid && (
          <p role="alert">Kiểm tra lại mức giá thấp nhất và cao nhất.</p>
        )}
        <div className="actions">
          <small>
            {accuracy === null
              ? "Quanh H1"
              : "Quanh bạn · sai số ước tính " +
                Math.round(accuracy) +
                " m"}{" "}
            · {radius} km
          </small>
          <button className="text" disabled={busy} onClick={locate}>
            {accuracy === null ? "Dùng vị trí của tôi" : "Đo lại"}
          </button>
          {accuracy !== null && (
            <button
              className="text"
              onClick={() => {
                setOrigin(h1);
                setAccuracy(null);
                setGps("");
              }}
            >
              Dùng mốc H1
            </button>
          )}
        </div>
        <small role="status">{gps}</small>
      </section>
      <div className="split">
        <div>
          <h2>Quán quanh bạn</h2>
          <small>
            {results.length} quán ·{" "}
            {results.reduce((n, x) => n + x.d.length, 0)} món phù hợp
          </small>
        </div>
        <select
          aria-label="Sắp xếp"
          value={sort}
          onChange={(e) => setSort(e.target.value)}
        >
          <option value="near">Gần nhất</option>
          <option value="price">Giá thấp nhất</option>
        </select>
      </div>
      <div className="grid">
        {results.map(({ b, d, dist }) => (
          <button className="card" key={b.id} onClick={() => open(b.id)}>
            {img(d[0].photo) && (
              <img src={img(d[0].photo)} alt="" loading="lazy" />
            )}
            <div>
              <span className="meta">
                {dist.toFixed(1)} km · đường chim bay
              </span>
              <h3>{d[0].name}</h3>
              <strong>
                {money(d[0].price)} / {d[0].unit}
              </strong>
              <p>
                {b.name} {sponsored(b) && <small>· Tài trợ mẫu</small>}
              </p>
            </div>
          </button>
        ))}
      </div>
      {!results.length && (
        <div className="panel">
          <h3>Chưa tìm thấy món</h3>
          <button
            onClick={() => {
              setQuery("");
              setLow("");
              setCap("");
              setRadius(3);
              setOrigin(h1);
              setAccuracy(null);
              setGps("");
            }}
          >
            Tìm lại quanh H1
          </button>
        </div>
      )}
      {results.length > 2 && (
        <aside className="ad">
          <small>Quảng cáo mẫu</small>
          <b>{results[2].b.name}</b>
          <button onClick={() => open(results[2].b.id)}>Xem quán</button>
        </aside>
      )}
    </>
  );
}
function Offer({ id }: { id: string }) {
  const key = "guestfood.offer." + id;
  const [used, setUsed] = useState(() => {
    try {
      return !!localStorage.getItem(key);
    } catch {
      return false;
    }
  });
  return (
    <aside className="ad">
      <small>Ưu đãi mẫu</small>
      <b>Giảm 5.000 ₫ cho hóa đơn từ 35.000 ₫ · Hạn 31/12/2027</b>
      <button
        disabled={used}
        onClick={() => {
          setUsed(true);
          try {
            localStorage.setItem(key, "1");
          } catch {
            /* session only */
          }
        }}
      >
        {used ? "Đã mô phỏng" : "Mô phỏng đổi mã"}
      </button>
    </aside>
  );
}
