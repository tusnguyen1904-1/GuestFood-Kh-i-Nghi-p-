import { useEffect, useState } from "react";
import { db, Dialog, errText, money, today, monday, shift } from "./lib";
const categories = [
  "Bữa sáng",
  "Bữa trưa",
  "Bữa tối",
  "Ăn vặt",
  "Đồ uống",
  "Khác",
];
type Entry = {
  id: string;
  day: string;
  amount: number;
  shop: string;
  dish: string;
  category: string;
  note: string;
};
export type Starter = Pick<Entry, "shop" | "dish" | "amount">;
const blank = (start?: Starter): Entry => ({
  id: crypto.randomUUID(),
  day: today(),
  shop: "",
  dish: "",
  amount: 0,
  category: "Bữa trưa",
  note: "",
  ...start,
});
const sum = (rows: Entry[]) => rows.reduce((t, x) => t + x.amount, 0);
export function Wallet({
  uid,
  start,
  done,
  sample = false,
}: {
  sample?: boolean;
  uid: string;
  start: Starter | null;
  done: () => void;
}) {
  const [period, setPeriod] = useState("week"),
    [customFrom, setCustomFrom] = useState(monday(today())),
    [customTo, setCustomTo] = useState(today());
  const now = today(),
    wk = monday(now),
    month = now.slice(0, 7) + "-01";
  const from =
    period === "week"
      ? wk
      : period === "month"
        ? month
        : period === "today"
          ? now
          : customFrom;
  const to =
    period === "week"
      ? shift(wk, 6)
      : period === "month"
        ? new Date(Date.UTC(+now.slice(0, 4), +now.slice(5, 7), 0))
            .toISOString()
            .slice(0, 10)
        : period === "today"
          ? now
          : customTo;
  const [rows, setRows] = useState<Entry[]>([]),
    [limit, setLimit] = useState<number | null>(null),
    [refresh, setRefresh] = useState(0),
    [loading, setLoading] = useState(true),
    [stats, setStats] = useState(false);
  const [editor, setEditor] = useState<Entry | null>(null),
    [budget, setBudget] = useState(false),
    [remove, setRemove] = useState(false),
    [busy, setBusy] = useState(false),
    [error, setError] = useState(""),
    [formError, setFormError] = useState("");
  const [by, setBy] = useState("category"),
    [drill, setDrill] = useState<{ key: string; value: string } | null>(null);
  useEffect(() => {
    if (start) {
      setEditor(blank(start));
      setFormError("");
      done();
    }
  }, [start, done]);
  useEffect(() => {
    let live = true;
    setError("");
    setLoading(true);
    setRows([]);
    setLimit(null);
    setDrill(null);
    if (!from || !to || from > to) {
      setLoading(false);
      setError("Chọn khoảng ngày hợp lệ.");
      return;
    }
    if (sample) {
      const fixtures = [
        ["Bữa trưa", 35000],
        ["Đồ uống", 15000],
        ["Bữa tối", 40000],
      ] as const;
      setRows(
        fixtures.map(([category, amount], i) => ({
          id: "sample" + i,
          shop: ["Cơm tấm Mai", "Quán nước mẫu", "Nướng ngói 76"][i],
          dish: category,
          category,
          amount,
          day: shift(now, -i),
          note: "Khoản chi minh họa",
        })),
      );
      setLimit(300000);
      setLoading(false);
      return;
    }
    const earliest = [from, shift(wk, -7)].sort()[0],
      latest = [to, shift(wk, 6)].sort()[1];
    async function fetchRows() {
      const result: Entry[] = [];
      for (let offset = 0; ; offset += 500) {
        const { data, error } = await db!
          .from("expenses")
          .select("id,day,amount,shop,dish,category,note")
          .eq("user_id", uid)
          .gte("day", earliest)
          .lte("day", latest)
          .order("day", { ascending: false })
          .order("id")
          .range(offset, offset + 499);
        if (error) throw error;
        result.push(...(data as Entry[]));
        if (!live || data.length < 500) return result;
      }
    }
    Promise.all([
      fetchRows(),
      db!
        .from("weekly_budgets")
        .select("amount")
        .eq("user_id", uid)
        .eq("week", wk)
        .maybeSingle(),
    ])
      .then(([entries, bal]) => {
        if (bal.error) throw bal.error;
        if (live) {
          setRows(entries);
          setLimit(bal.data?.amount ?? null);
        }
      })
      .catch((e) => live && setError(errText(e)))
      .finally(() => live && setLoading(false));
    return () => {
      live = false;
    };
  }, [uid, from, to, wk, refresh, sample, now]);
  const chosen = rows.filter((r) => r.day >= from && r.day <= to),
    spent = sum(rows.filter((r) => r.day >= wk && r.day <= shift(wk, 6))),
    total = sum(chosen);
  const groupedWeeks =
    !!from && !!to && Date.parse(to) - Date.parse(from) > 30 * 86400000;
  const keyOf = (r: Entry, key: string) =>
    key === "day" && groupedWeeks
      ? monday(r.day)
      : key === "shop"
        ? r.shop || "Chưa ghi quán"
        : key === "category"
          ? r.category
          : r.day;
  const shown = drill
    ? chosen.filter((r) => keyOf(r, drill.key) === drill.value)
    : chosen;
  const buckets = (key: string) => {
    const map = new Map<string, number>();
    if (
      key === "day" &&
      from &&
      to &&
      from <= to &&
      Date.parse(to) - Date.parse(from) < 10 * 366 * 86400000
    ) {
      for (
        let date = groupedWeeks ? monday(from) : from;
        date <= to;
        date = shift(date, groupedWeeks ? 7 : 1)
      )
        map.set(date, 0);
    }
    for (const r of chosen) {
      const k = keyOf(r, key);
      map.set(k, (map.get(k) || 0) + r.amount);
    }
    return [...map].sort((a, b) =>
      key === "day" ? a[0].localeCompare(b[0]) : b[1] - a[1],
    );
  };
  const previous = sum(
      rows.filter((r) => r.day >= shift(wk, -7) && r.day <= shift(now, -7)),
    ),
    thisWeek = sum(rows.filter((r) => r.day >= wk && r.day <= now));
  async function mutate(run: () => PromiseLike<{ error: unknown }>) {
    if (busy) return;
    setBusy(true);
    setFormError("");
    try {
      const res = await run();
      if (res.error) throw res.error;
      setEditor(null);
      setBudget(false);
      setRemove(false);
      setRefresh((n) => n + 1);
    } catch (e) {
      setFormError(errText(e));
    } finally {
      setBusy(false);
    }
  }
  function edit(r: Entry) {
    setFormError("");
    setEditor(r);
    setRemove(false);
  }
  function bars(key: string) {
    const items = buckets(key);
    return items.length ? (
      items.map(([value, n]) => (
        <button
          key={value}
          className="bar"
          aria-pressed={drill?.key === key && drill.value === value}
          onClick={() => setDrill({ key, value })}
        >
          <span>{value}</span>
          <i>
            <em
              style={{
                width: (100 * n) / Math.max(1, ...items.map((x) => x[1])) + "%",
              }}
            />
          </i>
          <b>{money(n)}</b>
        </button>
      ))
    ) : (
      <p>Chưa có khoản chi trong kỳ.</p>
    );
  }
  return (
    <>
      <div className="split">
        <h1>{sample ? "Sổ chi mẫu" : "Sổ chi của bạn"}</h1>
        {!sample && (
          <button className="primary" onClick={() => edit(blank())}>
            + Ghi khoản chi
          </button>
        )}
      </div>
      <div className="metrics">
        <article className="balance">
          <small>
            {limit === null
              ? "Ngân sách tuần này"
              : spent > limit
                ? "Đã vượt trong tuần"
                : "Còn lại trong tuần"}
          </small>
          <strong>
            {loading
              ? "…"
              : limit === null
                ? "Chưa đặt"
                : money(Math.abs(limit - spent))}
          </strong>
          {!sample && (
            <button
              onClick={() => {
                setBudget(true);
                setFormError("");
              }}
            >
              Đặt ngân sách
            </button>
          )}
        </article>
        <article>
          <small>Tổng chi trong kỳ</small>
          <strong>{loading ? "…" : money(total)}</strong>
          {chosen.length} khoản
        </article>
        <article>
          <small>Trung bình mỗi khoản</small>
          <strong>{chosen.length ? money(total / chosen.length) : "—"}</strong>
        </article>
      </div>
      <div className="split">
        <div className="actions">
          <button
            className={!stats ? "sel" : ""}
            onClick={() => {
              setStats(false);
              setDrill(null);
            }}
          >
            Sổ chi
          </button>
          <button className={stats ? "sel" : ""} onClick={() => setStats(true)}>
            Thống kê
          </button>
        </div>
        <select
          aria-label="Kỳ thống kê"
          value={period}
          onChange={(e) => setPeriod(e.target.value)}
        >
          {Object.entries({
            today: "Hôm nay",
            week: "Tuần này",
            month: "Tháng này",
            custom: "Khoảng ngày",
          }).map(([k, v]) => (
            <option key={k} value={k}>
              {v}
            </option>
          ))}
        </select>
      </div>
      {period === "custom" && (
        <div className="fields">
          <label>
            Từ ngày
            <input
              type="date"
              value={customFrom}
              onChange={(e) => setCustomFrom(e.target.value)}
            />
          </label>
          <label>
            Đến ngày
            <input
              type="date"
              value={customTo}
              onChange={(e) => setCustomTo(e.target.value)}
            />
          </label>
        </div>
      )}
      {error && (
        <p role="alert">
          {error}{" "}
          <button onClick={() => setRefresh((n) => n + 1)}>Thử lại</button>
        </p>
      )}
      {stats && (
        <div className="columns">
          <article className="panel">
            <h2>{groupedWeeks ? "Chi theo tuần" : "Chi theo ngày"}</h2>
            {bars("day")}
            <small>
              Tuần này đến hôm nay so với cùng kỳ tuần trước:{" "}
              {money(Math.abs(thisWeek - previous))}{" "}
              {thisWeek >= previous ? "cao hơn" : "thấp hơn"}.
            </small>
          </article>
          <article className="panel">
            <h2>Phân bổ chi tiêu</h2>
            <select
              aria-label="Nhóm thống kê"
              value={by}
              onChange={(e) => {
                setBy(e.target.value);
                setDrill(null);
              }}
            >
              <option value="category">Theo nhóm</option>
              <option value="shop">Theo quán</option>
            </select>
            {bars(by)}
          </article>
        </div>
      )}
      <section className="panel">
        <h2>{drill ? drill.value : "Các khoản đã ghi"}</h2>
        {drill && (
          <button onClick={() => setDrill(null)}>
            Bỏ lọc · {money(sum(shown))}
          </button>
        )}
        {loading ? (
          <p>Đang tải…</p>
        ) : shown.length ? (
          shown.map((r) => (
            <div className="row" key={r.id}>
              <div>
                <b>{r.dish || r.shop || r.category}</b>
                <p>
                  {r.day} · {r.category} · {r.shop}
                </p>
                {r.note && <small>{r.note}</small>}
              </div>
              <div>
                <b>{money(r.amount)}</b>
                {!sample && (
                  <>
                    <button onClick={() => edit(r)}>Sửa</button>
                    <button
                      onClick={() =>
                        edit({ ...r, id: crypto.randomUUID(), day: now })
                      }
                    >
                      Ghi lại
                    </button>
                  </>
                )}
              </div>
            </div>
          ))
        ) : (
          !error && <p>Chưa có khoản chi trong kỳ.</p>
        )}
      </section>
      {budget && (
        <Dialog
          title="Ngân sách tuần này"
          close={() => !busy && setBudget(false)}
        >
          <form
            onSubmit={(e) => {
              e.preventDefault();
              const amount = Number(
                new FormData(e.currentTarget).get("amount"),
              );
              void mutate(() =>
                db!
                  .from("weekly_budgets")
                  .upsert({ user_id: uid, week: wk, amount }),
              );
            }}
          >
            <label>
              Số tiền (₫)
              <input
                name="amount"
                type="number"
                min="1"
                max="2147483647"
                required
                defaultValue={limit ?? ""}
              />
            </label>
            <p>{formError}</p>
            <button disabled={busy} className="primary">
              Lưu ngân sách
            </button>
          </form>
        </Dialog>
      )}
      {editor && (
        <Dialog
          title={remove ? "Xóa khoản chi này?" : "Ghi khoản chi"}
          close={() => !busy && setEditor(null)}
        >
          {remove ? (
            <>
              <p>
                {editor.dish} · {money(editor.amount)}
              </p>
              <button
                disabled={busy}
                onClick={() =>
                  void mutate(() =>
                    db!
                      .from("expenses")
                      .delete()
                      .eq("id", editor.id)
                      .eq("user_id", uid),
                  )
                }
              >
                Xác nhận xóa
              </button>
              <button onClick={() => setRemove(false)}>Quay lại</button>
            </>
          ) : (
            <form
              onSubmit={(e) => {
                e.preventDefault();
                const d = Object.fromEntries(new FormData(e.currentTarget));
                void mutate(() =>
                  db!.from("expenses").upsert({
                    ...d,
                    id: editor.id,
                    user_id: uid,
                    amount: Number(d.amount),
                  }),
                );
              }}
            >
              <label>
                Quán
                <input name="shop" maxLength={120} defaultValue={editor.shop} />
              </label>
              <label>
                Món ăn
                <input name="dish" maxLength={120} defaultValue={editor.dish} />
              </label>
              <div className="fields">
                <label>
                  Thực trả (₫)
                  <input
                    required
                    type="number"
                    min="1"
                    max="2147483647"
                    name="amount"
                    defaultValue={editor.amount || ""}
                  />
                </label>
                <label>
                  Ngày ăn
                  <input
                    required
                    type="date"
                    max={now}
                    name="day"
                    defaultValue={editor.day}
                  />
                </label>
              </div>
              <label>
                Nhóm chi
                <select name="category" defaultValue={editor.category}>
                  {categories.map((c) => (
                    <option key={c}>{c}</option>
                  ))}
                </select>
              </label>
              <label>
                Ghi chú
                <textarea
                  name="note"
                  maxLength={500}
                  defaultValue={editor.note}
                />
              </label>
              <div className="actions">
                <button className="primary" disabled={busy}>
                  Lưu khoản chi
                </button>
                {rows.some((r) => r.id === editor.id) && (
                  <button type="button" onClick={() => setRemove(true)}>
                    Xóa khoản
                  </button>
                )}
              </div>
            </form>
          )}
          <p role="alert">{formError}</p>
        </Dialog>
      )}
    </>
  );
}
