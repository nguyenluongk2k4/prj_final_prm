// import { RtcRole, RtcTokenBuilder } from "npm:agora-access-token@2.0.4";

// type TokenRequest = {
// 	channel: string;
// 	userId: string;
// 	role?: "publisher" | "subscriber";
// 	expireSeconds?: number;
// };

// const corsHeaders = {
// 	"Access-Control-Allow-Origin": "*",
// 	"Access-Control-Allow-Headers":
// 		"authorization, x-client-info, apikey, content-type",
// };

// function getEnv(name: string): string {
// 	const value = Deno.env.get(name);
// 	if (!value) throw new Error(`Missing env: ${name}`);
// 	return value;
// }

// Deno.serve(async (req) => {
// 	if (req.method === "OPTIONS") {
// 		return new Response("ok", { headers: corsHeaders });
// 	}

// 	if (req.method !== "POST") {
// 		return new Response("Method Not Allowed", {
// 			status: 405,
// 			headers: corsHeaders,
// 		});
// 	}

// 	try {
// 		const body = (await req.json()) as TokenRequest;
// 		const channel = (body.channel ?? "").trim();
// 		const userId = (body.userId ?? "").trim();
// 		const role = body.role ?? "publisher";
// 		const expireSeconds = body.expireSeconds ?? 3600;

// 		if (!channel || !userId) {
// 			return new Response("Missing channel or userId", {
// 				status: 400,
// 				headers: corsHeaders,
// 			});
// 		}

// 		const appId = getEnv("AGORA_APP_ID");
// 		const appCertificate = getEnv("AGORA_APP_CERTIFICATE");
// 		const agoraRole =
// 			role === "subscriber" ? RtcRole.SUBSCRIBER : RtcRole.PUBLISHER;

// 		const now = Math.floor(Date.now() / 1000);
// 		const privilegeExpiredTs = now + expireSeconds;
// 		const token = RtcTokenBuilder.buildTokenWithAccount(
// 			appId,
// 			appCertificate,
// 			channel,
// 			userId,
// 			agoraRole,
// 			privilegeExpiredTs,
// 		);

// 		return new Response(
// 			JSON.stringify({ token }),
// 			{
// 				headers: { ...corsHeaders, "Content-Type": "application/json" },
// 				status: 200,
// 			},
// 		);
// 	} catch (err) {
// 		return new Response(`Error: ${err?.message ?? err}`,
// 			{
// 				status: 500,
// 				headers: corsHeaders,
// 			},
// 		);
// 	}
// });
