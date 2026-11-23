import { useEffect, useState } from "react";
import { db, Dialog, errText, today, h1, type Branch, type Dish } from "./lib";
type Report = { id: string; branch_id: string; note: string };
export function Admin({ updated }: { updated: () => void }) {
  const [rows, setRows] = useState<Branch[]>([]),
    [reports, setReports] = useState<Report[]>([]),
    [edit, setEdit] = useState<Branch | null>(null),
    [items, setItems] = useState<Dish[]>([]),
    [error, setError] = useState(""),
    [busy, setBusy] = useState(false),
    [rev, setRev] = useState(0);
  useEffect(() => {
    let live = true;
    Promise.all([
      db!.from("branches").select("*,dishes(*)").order("name"),
      db!
        .from("location_reports")
        .select("id,branch_id,note")
        .eq("resolved", false),
    ]).then(([a, b]) => {
      if (!live) return;
      if (a.error || b.error) {
        setError(errText(a.error || b.error));
        return;
      }
      setRows(a.data as Branch[]);
      setReports(b.data as Report[]);
    });
    return () => {
      live = false;
    };
  }, [rev]);
  function start(b?: Branch) {
    setError("");
    setEdit(
      b || {
        id: crypto.randomUUID(),
        name: "",
        address: "",
        map: "",
        lat: h1[0],
        lon: h1[1],
        verified_at: today(),
        published: false,
        dishes: [],
      },
    );
    setItems(
      b?.dishes.map((d) => ({ ...d })) || [
        { name: "", unit: "phần", price: 30000, photo: "" },
      ],
    );
  }
  function dish(index: number, change: Partial<Dish>) {
    setItems(items.map((d, i) => (i === index ? { ...d, ...change } : d)));
  }
  return (
    <>
      <div className="split">
        <h1>Quản lý danh mục</h1>
        <button onClick={() => start()}>Thêm chi nhánh</button>
      </div>
      <section className="panel">
        <h2>Báo sai đang chờ</h2>
        {reports.length ? (
          reports.map((r) => (
            <div key={r.id} className="row">
              <span>
                {rows.find((b) => b.id === r.branch_id)?.name} · {r.note}
              </span>
              <button
                onClick={async () => {
                  const { error } = await db!
                    .from("location_reports")
                    .update({ resolved: true })
                    .eq("id", r.id);
                  if (error) setError(errText(error));
                  else setRev((n) => n + 1);
                }}
              >
                Đã xử lý
              </button>
            </div>
          ))
        ) : (
          <p>Chưa có báo sai.</p>
        )}
      </section>
      <section className="panel">
        {rows.map((b) => (
          <div className="row" key={b.id}>
            <div>
              <b>{b.name}</b>
              <p>
                {b.published ? "Đang hiển thị" : "Bản nháp"} · {b.address}
              </p>
            </div>
            <button onClick={() => start(b)}>Sửa</button>
          </div>
        ))}
      </section>
      {error && !edit && <p role="alert">{error}</p>}
      {edit && (
        <Dialog
          title="Chi nhánh và thực đơn"
          close={() => !busy && setEdit(null)}
        >
          <form
            onSubmit={async (e) => {
              e.preventDefault();
              if (busy) return;
              setBusy(true);
              const f = Object.fromEntries(new FormData(e.currentTarget));
              try {
                const { error } = await db!.rpc("save_branch", {
                  p_id: edit.id,
                  p_record: {
                    ...f,
                    published: f.published === "on",
                    lat: +f.lat,
                    lon: +f.lon,
                  },
                  p_evidence: f.evidence,
                  p_dishes: items,
                });
                if (error) throw error;
                setEdit(null);
                setRev((n) => n + 1);
                updated();
              } catch (e) {
                setError(errText(e));
              } finally {
                setBusy(false);
              }
            }}
          >
            {(
              [
                "name",
                "address",
                "map",
                "place_id",
                "lat",
                "lon",
                "verified_at",
              ] as const
            ).map((k, i) => (
              <label key={k}>
                {
                  [
                    "Tên quán",
                    "Địa chỉ",
                    "Link hồ sơ Google Maps",
                    "Google Place ID",
                    "Vĩ độ",
                    "Kinh độ",
                    "Ngày đối chiếu",
                  ][i]
                }
                <input
                  name={k}
                  required={k !== "place_id"}
                  type={
                    k === "map"
                      ? "url"
                      : k === "verified_at"
                        ? "date"
                        : ["lon", "lat"].includes(k)
                          ? "number"
                          : "text"
                  }
                  step="any"
                  defaultValue={edit[k] ?? ""}
                />
              </label>
            ))}
            <h3>Thực đơn mẫu</h3>
            {items.map((d, i) => (
              <fieldset key={i}>
                <label>
                  Tên món
                  <input
                    required
                    value={d.name}
                    onChange={(e) => dish(i, { name: e.target.value })}
                  />
                </label>
                <div className="fields">
                  <label>
                    Giá
                    <input
                      required
                      min="1"
                      type="number"
                      value={d.price}
                      onChange={(e) => dish(i, { price: +e.target.value })}
                    />
                  </label>
                  <label>
                    Đơn vị
                    <input
                      required
                      value={d.unit}
                      onChange={(e) => dish(i, { unit: e.target.value })}
                    />
                  </label>
                </div>
                <label>
                  Ảnh minh họa
                  <select
                    value={d.photo}
                    onChange={(e) => dish(i, { photo: e.target.value })}
                  >
                    {[
                      "",
                      "com",
                      "bun",
                      "pho",
                      "lau",
                      "banh",
                      "mi",
                      "chay",
                      "bo",
                    ].map((p, j) => (
                      <option key={p} value={p}>
                        {
                          [
                            "Chỉ hiện chữ",
                            "Cơm",
                            "Bún",
                            "Phở",
                            "Lẩu",
                            "Bánh mì",
                            "Mì",
                            "Chay",
                            "Bò",
                          ][j]
                        }
                      </option>
                    ))}
                  </select>
                </label>
                {items.length > 1 && (
                  <button
                    type="button"
                    onClick={() => setItems(items.filter((_, j) => j !== i))}
                  >
                    Bỏ món
                  </button>
                )}
              </fieldset>
            ))}
            <button
              type="button"
              onClick={() =>
                setItems([
                  ...items,
                  { name: "", price: 30000, photo: "", unit: "phần" },
                ])
              }
            >
              Thêm món
            </button>
            <label>
              Bằng chứng / lý do thay đổi
              <textarea required name="evidence" />
            </label>
            <label className="check">
              <input
                type="checkbox"
                name="published"
                defaultChecked={edit.published}
              />
              Công khai chi nhánh
            </label>
            <p role="alert">{error}</p>
            <button disabled={busy} className="primary">
              Lưu thay đổi
            </button>
          </form>
        </Dialog>
      )}
    </>
  );
}
