import { useEffect, useRef, useState } from "react";
import { db } from "./lib";

type Entry = { stars: number; body: string; updated_at: string };
type Result = { total: number; average: number | null; items: Entry[]; mine: Pick<Entry,"stars"|"body"> | null };

export function Reviews({ branch, signed }: { branch: string; signed: boolean }) {
  const [data, setData] = useState<Result | null>(null);
  const [page, setPage] = useState(0);
  const [revision, refresh] = useState(0);
  const [stars, setStars] = useState(0);
  const [body, setBody] = useState("");
  const [busy, setBusy] = useState(false);
  const [failed, setFailed] = useState(false);
  const [message, setMessage] = useState("");
  const initialized = useRef(false);
  useEffect(() => {
    let current = true;
    async function load() {
      setFailed(false);
      setData(null);
      if (!db) { setFailed(true); return; }
      const { data, error } = await db.rpc("read_branch_reviews", { p_branch: branch, p_page: page });
      if (!current) return;
      if (error) { setFailed(true); return; }
      const result = data as Result;
      setData(result);
      if (!initialized.current) {
        setStars(result.mine?.stars ?? 0);
        setBody(result.mine?.body ?? "");
        initialized.current = true;
      }
    }
    void load();
    return () => { current = false; };
  }, [branch, page, revision]);

  return <section className="panel reviews">
    <h2>Đánh giá quán</h2>
    {failed ? <p role="alert">Chưa tải được đánh giá. <button onClick={() => refresh(n => n + 1)}>Thử lại</button></p>
      : !data ? <p>Đang tải đánh giá…</p> : <>
      <p>{data.total ? <><b>★ {data.average?.toLocaleString("vi-VN")} / 5</b> · {data.total} lượt đánh giá</> : "Quán chưa có đánh giá."}</p>
      {signed ? <form onSubmit={async e => {
        e.preventDefault();
        if (!db || !stars || busy) return;
        setBusy(true);
        try {
          const { error } = await db.rpc("save_branch_review", {p_branch: branch, p_stars: stars, p_body: body.trim()});
          if (error) throw error;
          setMessage("Đã lưu đánh giá của bạn.");
          setBody(body.trim());
          setPage(0);
          refresh(n => n + 1);
        } catch { setMessage("Chưa lưu được đánh giá. Vui lòng thử lại."); }
        finally { setBusy(false); }
      }}>
        <fieldset disabled={busy}><legend>Bạn chấm quán mấy sao?</legend>
          <div className="rating-options">{[1,2,3,4,5].map(n =>
            <label key={n}><input type="radio" name="stars" aria-label={n+" sao"} checked={stars===n} onChange={() => setStars(n)} required />
              <span aria-hidden="true">{n <= stars ? "★" : "☆"}</span></label>)}</div>
        </fieldset>
        <label>Nhận xét của bạn (tùy chọn)<textarea value={body} maxLength={1000} disabled={busy} onChange={e => setBody(e.target.value)} /></label>
        <button className="primary" disabled={!stars || busy}>{busy ? "Đang lưu…" : data.mine ? "Cập nhật đánh giá" : "Gửi đánh giá"}</button>
      </form> : <p>Đăng nhập để chấm sao và viết nhận xét.</p>}
      {data.items.map((entry, i) => <article key={i}>
        <b>{entry.stars} / 5 ★</b> · <time dateTime={entry.updated_at}>{new Date(entry.updated_at).toLocaleDateString("vi-VN")}</time>
        {entry.body && <p>{entry.body}</p>}
      </article>)}
      {(page > 0 || data.total > 10) && <div className="actions">
        <button disabled={!page} onClick={() => setPage(n => n-1)}>Trang trước</button>
        <span>Trang {page+1}</span>
        <button disabled={(page+1)*10 >= data.total} onClick={() => setPage(n => n+1)}>Trang sau</button>
      </div>}
    </>}
    <small role="status">{message}</small>
  </section>;
}
