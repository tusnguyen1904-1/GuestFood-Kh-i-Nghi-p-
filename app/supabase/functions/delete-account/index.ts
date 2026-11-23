import { createClient } from "npm:@supabase/supabase-js@2";
const headers = {
  "Access-Control-Allow-Origin": "*",
  "Access-Control-Allow-Headers":
    "authorization, apikey, content-type, x-client-info",
  "Access-Control-Allow-Methods": "POST, OPTIONS",
};
Deno.serve(async (req) => {
  if (req.method === "OPTIONS") return new Response(null, { headers });
  if (req.method !== "POST")
    return new Response(null, { status: 405, headers });
  const token = req.headers.get("Authorization")?.replace(/^Bearer /, "");
  if (!token) return new Response(null, { status: 401, headers });
  const admin = createClient(
    Deno.env.get("SUPABASE_URL")!,
    Deno.env.get("SUPABASE_SERVICE_ROLE_KEY")!,
    { auth: { persistSession: false } },
  );
  const { data, error } = await admin.auth.getUser(token);
  if (error || !data.user) return new Response(null, { status: 401, headers });
  const deletion = await admin.auth.admin.deleteUser(data.user.id);
  return Response.json(
    { ok: !deletion.error },
    { status: deletion.error ? 500 : 200, headers },
  );
});
