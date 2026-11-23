import { useState } from "react";
import { db, Dialog, errText } from "./lib";
export function Auth({
  close,
  recovery = false,
}: {
  close: () => void;
  recovery?: boolean;
}) {
  const [mode, setMode] = useState(recovery ? "update" : "login"),
    [busy, setBusy] = useState(false),
    [message, setMessage] = useState("");
  const titles: Record<string, string> = {
    login: "Đăng nhập",
    signup: "Tạo tài khoản",
    reset: "Khôi phục mật khẩu",
    update: "Đặt mật khẩu mới",
  };
  return (
    <Dialog title={titles[mode]} close={close}>
      {!db ? (
        <p>
          Kết nối Supabase đang chờ cấu hình. Bạn có thể tìm món và mở bản đồ
          ngay.
        </p>
      ) : (
        <form
          key={mode}
          onSubmit={async (e) => {
            e.preventDefault();
            if (busy) return;
            setBusy(true);
            setMessage("");
            const f = new FormData(e.currentTarget),
              email = String(f.get("email") || "").trim(),
              password = String(f.get("password") || "");
            try {
              if (mode === "reset") {
                const { error } = await db!.auth.resetPasswordForEmail(email, {
                  redirectTo: location.origin,
                });
                if (error) throw error;
                setMessage("Kiểm tra hộp thư để tiếp tục.");
              } else if (mode === "update") {
                const { error } = await db!.auth.updateUser({ password });
                if (error) throw error;
                close();
              } else {
                const { data, error } =
                  mode === "signup"
                    ? await db!.auth.signUp({ email, password })
                    : await db!.auth.signInWithPassword({ email, password });
                if (error) throw error;
                if (data.session) close();
                else
                  setMessage(
                    "Chưa nhận được phiên đăng nhập. Kiểm tra cấu hình Confirm email của project.",
                  );
              }
            } catch (e) {
              setMessage(errText(e));
            } finally {
              setBusy(false);
            }
          }}
        >
          {mode !== "update" && (
            <label>
              Email
              <input name="email" type="email" autoComplete="email" required />
            </label>
          )}
          {mode !== "reset" && (
            <label>
              Mật khẩu
              <input
                name="password"
                type="password"
                autoComplete={
                  mode === "login" ? "current-password" : "new-password"
                }
                minLength={mode === "login" ? 1 : 6}
                required
              />
            </label>
          )}
          <button className="primary" disabled={busy}>
            {busy ? "Đang xử lý…" : titles[mode]}
          </button>
          <p role="status">{message}</p>
          <div className="actions">
            {mode !== "login" && (
              <button
                type="button"
                onClick={() => {
                  setMode("login");
                  setMessage("");
                }}
              >
                Đăng nhập
              </button>
            )}
            {mode === "login" && (
              <>
                <button
                  type="button"
                  onClick={() => {
                    setMode("signup");
                    setMessage("");
                  }}
                >
                  Tạo tài khoản
                </button>
                <button
                  type="button"
                  className="text"
                  onClick={() => {
                    setMode("reset");
                    setMessage("");
                  }}
                >
                  Quên mật khẩu
                </button>
              </>
            )}
          </div>
        </form>
      )}
    </Dialog>
  );
}
