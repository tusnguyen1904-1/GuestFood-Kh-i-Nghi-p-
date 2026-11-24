import { createClient } from "@supabase/supabase-js";

export default async function handler(request, response) {
  response.setHeader("Cache-Control", "no-store");
  if (request.method !== "POST") {
    response.setHeader("Allow", "POST");
    return response.status(405).end();
  }
  const token = request.headers.authorization?.match(/^Bearer (.+)$/i)?.[1];
  if (!token) return response.status(401).end();
  const admin = createClient(process.env.SUPABASE_URL, process.env.SUPABASE_SECRET_KEY, {
    auth: { persistSession: false, autoRefreshToken: false },
  });
  const { data, error } = await admin.auth.getUser(token);
  if (error || !data.user) return response.status(401).end();
  const deletion = await admin.auth.admin.deleteUser(data.user.id);
  return response.status(deletion.error ? 500 : 204).end();
}
