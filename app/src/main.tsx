import { useCallback, useEffect, useState } from "react";
import { createRoot } from "react-dom/client";
import type { Session } from "@supabase/supabase-js";
import { db, Dialog, errText, type Branch, type Dish } from "./lib";
import { Catalog } from "./Catalog";
import { Wallet, type Starter } from "./Wallet";
import { Auth } from "./Auth";
import { Admin } from "./Admin";
import catalog from "./catalog.json";
import "./style.css";

function App() {
  const [route, setRoute] = useState(location.hash.slice(1) || "tim-mon"),
    [session, setSession] = useState<Session | null>(null),
    [admin, setAdmin] = useState(false);
  const [rows, setRows] = useState<Branch[]>(db ? [] : catalog),
    [loading, setLoading] = useState(!!db),
    [rev, setRev] = useState(0),
    [error, setError] = useState(""),
    [auth, setAuth] = useState(""),
    [account, setAccount] = useState(false),
    [deleting, setDeleting] = useState(false),
    [message, setMessage] = useState("");
  const [sample, setSample] = useState(false);
  const [draft, setDraft] = useState<Starter | null>(null),
    done = useCallback(() => setDraft(null), []);
  useEffect(() => {
    const update = () => {
      setRoute(location.hash.slice(1) || "tim-mon");
      window.scrollTo(0, 0);
    };
    window.addEventListener("hashchange", update);
    return () => window.removeEventListener("hashchange", update);
  }, []);
  useEffect(() => {
    if (!db) return;
    const { data } = db.auth.onAuthStateChange((event, s) => {
      setSession(s);
      if (event === "PASSWORD_RECOVERY") setAuth("recovery");
      if (event === "SIGNED_OUT") {
        setAdmin(false);
        setAccount(false);
        setDraft(null);
      }
    });
    return () => data.subscription.unsubscribe();
  }, []);
  const uid = session?.user.id;
  useEffect(() => {
    setAdmin(false);
    if (!db || !uid) return;
    let live = true;
    db.from("admin_roles")
      .select("user_id")
      .eq("user_id", uid)
      .maybeSingle()
      .then(({ data }) => {
        if (live) setAdmin(!!data);
      });
    return () => {
      live = false;
    };
  }, [uid]);
  useEffect(() => {
    if (!db) return;
    let live = true;
    setLoading(true);
    setError("");
    db.from("branches")
      .select("*,dishes(name,price,unit,photo)")
      .eq("published", true)
      .order("id")
      .then(({ data, error }) => {
        if (!live) return;
        setLoading(false);
        if (error) {
          setError(errText(error));
          setRows([]);
        } else setRows((data || []) as Branch[]);
      });
    return () => {
      live = false;
    };
  }, [rev]);
  const wallet = route === "chi-tieu",
    manage = route === "quan-tri";
  function record(b: Branch, d: Dish) {
    setSample(false);
    setDraft({ shop: b.name, dish: d.name, amount: d.price });
    location.hash = "chi-tieu";
    if (!uid) setAuth("login");
  }
  function closeAccount() {
    if (!deleting) {
      setAccount(false);
      setMessage("");
    }
  }
  return (
    <>
      <header className="site">
        <div className="wrap top">
          <a className="brand" href="#tim-mon">
            <img src="/guestfood-logo.svg" alt="guestfood" width="104" height="61" />
          </a>
          <nav>
            <a
              aria-current={!wallet && !manage ? "page" : undefined}
              href="#tim-mon"
            >
              Tìm món
            </a>
            <a aria-current={wallet ? "page" : undefined} href="#chi-tieu">
              Chi tiêu
            </a>
            {admin && <a href="#quan-tri">Quản trị</a>}
          </nav>
          <button
            className="account"
            onClick={() => (uid ? setAccount(true) : setAuth("login"))}
          >
            {uid ? "Tài khoản" : "Đăng nhập"}
          </button>
        </div>
      </header>
      <main className="wrap">
        <div hidden={wallet || manage}>
          {error ? (
            <div className="panel">
              <h2>Chưa tải được danh mục</h2>
              <p>{error}</p>
              <button onClick={() => setRev((n) => n + 1)}>Thử lại</button>
            </div>
          ) : loading ? (
            <p>Đang tải danh mục…</p>
          ) : (
            <Catalog
              branches={rows}
              active={route.startsWith("quan/") ? route.slice(5) : ""}
              open={(id) => {
                location.hash = id ? "quan/" + id : "tim-mon";
              }}
              signed={!!uid}
              record={record}
            />
          )}
        </div>
        {wallet && (
          <button className="text" onClick={() => setSample(!sample)}>
            {sample ? "Về sổ cá nhân" : "Xem sổ mẫu"}
          </button>
        )}
        {wallet &&
          (sample ? (
            <Wallet key="sample" uid="" sample start={null} done={done} />
          ) : uid ? (
            <Wallet key={uid} uid={uid} start={draft} done={done} />
          ) : (
            <section className="panel welcome">
              <h1>Sổ chi của bạn</h1>
              <p>Đăng nhập để lưu bữa ăn và xem ngân sách trên các thiết bị.</p>
              <button className="primary" onClick={() => setAuth("login")}>
                Đăng nhập / Tạo tài khoản
              </button>
            </section>
          ))}
        {manage &&
          (admin ? (
            <Admin updated={() => setRev((n) => n + 1)} />
          ) : (
            <p>Trang dành cho quản trị danh mục.</p>
          ))}
      </main>
      <footer className="wrap">
        guestFood · Bách khoa Dĩ An · Ảnh, thực đơn, giá và quảng cáo minh họa.{" "}
        <a href="https://www.openstreetmap.org/way/290484111">
          Mốc H1 © OpenStreetMap contributors
        </a>
      </footer>
      {auth && (
        <Auth recovery={auth === "recovery"} close={() => setAuth("")} />
      )}
      {account && session && (
        <Dialog title="Tài khoản của bạn" close={closeAccount}>
          <p>{session.user.email}</p>
          <button
            onClick={async () => {
              const { error } = await db!.auth.signOut();
              if (error) setMessage(errText(error));
              else setAccount(false);
            }}
          >
            Đăng xuất
          </button>
          <details>
            <summary>Xóa tài khoản</summary>
            <p>Toàn bộ ngân sách và khoản chi của bạn sẽ bị xóa.</p>
            <button
              disabled={deleting}
              onClick={async () => {
                setDeleting(true);
                try {
                  if (import.meta.env.PROD) {
                    const res = await fetch("/api/delete-account", {
                      method: "POST",
                      headers: { Authorization: "Bearer " + session.access_token },
                    });
                    if (!res.ok) throw new Error("Chưa xóa được tài khoản. Vui lòng đăng nhập lại và thử lại.");
                  } else {
                    const { error } = await db!.functions.invoke("delete-account", {body: {}});
                    if (error) throw error;
                  }
                  await db!.auth.signOut({ scope: "local" });
                  setAccount(false);
                } catch (e) {
                  setMessage(errText(e));
                } finally {
                  setDeleting(false);
                }
              }}
            >
              Xác nhận xóa tài khoản và sổ chi
            </button>
          </details>
          <p role="status">{message}</p>
        </Dialog>
      )}
    </>
  );
}
createRoot(document.getElementById("root")!).render(<App />);
