import { createClient } from "@supabase/supabase-js";
import { useEffect, useRef, type ReactNode, createElement } from "react";
const url = import.meta.env.VITE_PUBLIC_SUPABASE_URL || import.meta.env.VITE_SUPABASE_URL,
  key = import.meta.env.VITE_PUBLIC_SUPABASE_PUBLISHABLE_KEY || import.meta.env.VITE_SUPABASE_PUBLISHABLE_KEY;
export const db = url && key ? createClient(url, key) : null;
export type Dish = { name: string; price: number; photo: string; unit: string };
export type Branch = {
  id: string;
  name: string;
  address: string;
  lat: number;
  lon: number;
  map: string;
  place_id?: string;
  verified_at: string;
  published?: boolean;
  dishes: Dish[];
};
export const money = (v: number) =>
  new Intl.NumberFormat("vi-VN").format(Math.round(v)) + " ₫";
export const h1: [number, number] = [10.8802804, 106.8046857];
export function km([lat, lon]: number[], b: Branch) {
  const rad = Math.PI / 180;
  const d =
    Math.sin(((b.lat - lat) * rad) / 2) ** 2 +
    Math.cos(lat * rad) *
      Math.cos(b.lat * rad) *
      Math.sin(((b.lon - lon) * rad) / 2) ** 2;
  return 12742 * Math.asin(Math.sqrt(Math.min(1, d)));
}
export const fold = (s: string) =>
  s
    .toLowerCase()
    .normalize("NFD")
    .replace(/[\u0300-\u036f]/g, "")
    .replace(/đ/g, "d")
    .replace(/\bmy\b/g, "mi")
    .trim();
export const today = () =>
  new Intl.DateTimeFormat("sv-SE", { timeZone: "Asia/Ho_Chi_Minh" }).format(
    new Date(),
  );
export function shift(s: string, n: number) {
  const d = new Date(s + "T12:00:00Z");
  d.setUTCDate(d.getUTCDate() + n);
  return d.toISOString().slice(0, 10);
}
export const monday = (s: string) =>
  shift(s, -((new Date(s + "T12:00Z").getUTCDay() + 6) % 7));
export const errText = (e: unknown) =>
  e && typeof e === "object" && "message" in e
    ? String(e.message)
    : "Có lỗi kết nối. Hãy thử lại.";
export const img = (key: string) =>
  ["com", "bun", "pho", "lau", "banh", "mi", "chay", "bo"].includes(key)
    ? "/food/" + key + ".jpg"
    : undefined;
export function Dialog({
  title,
  children,
  close,
}: {
  title: string;
  children: ReactNode;
  close: () => void;
}) {
  const ref = useRef<HTMLDialogElement>(null);
  useEffect(() => {
    const el = ref.current!;
    el.showModal();
    return () => el.close();
  }, []);
  return createElement(
    "dialog",
    { ref, onCancel: close, "aria-label": title },
    createElement(
      "header",
      { className: "split" },
      createElement("h2", {}, title),
      createElement(
        "button",
        { className: "quiet", onClick: close, "aria-label": "Đóng" },
        "×",
      ),
    ),
    children,
  );
}
