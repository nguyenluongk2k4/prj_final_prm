// import { SignJWT, importPKCS8 } from "https://deno.land/x/jose@v4.14.4/index.ts";

// const TOKEN_URI = "https://oauth2.googleapis.com/token";

// const getEnv = (key: string): string => {
// 	const value = Deno.env.get(key);
// 	if (!value) {
// 		throw new Error(`Missing env: ${key}`);
// 	}
// 	return value;
// };

// const getAccessToken = async (): Promise<string> => {
// 	const projectId = getEnv("FCM_PROJECT_ID");
// 	const clientEmail = getEnv("FCM_CLIENT_EMAIL");
// 	const privateKey = getEnv("FCM_PRIVATE_KEY").replace(/\\n/g, "\n");

// 	const now = Math.floor(Date.now() / 1000);
// 	const jwt = await new SignJWT({
// 		scope: "https://www.googleapis.com/auth/firebase.messaging",
// 	})
// 		.setProtectedHeader({ alg: "RS256", typ: "JWT" })
// 		.setIssuedAt(now)
// 		.setExpirationTime(now + 3600)
// 		.setIssuer(clientEmail)
// 		.setSubject(clientEmail)
// 		.setAudience(TOKEN_URI)
// 		.sign(await importPKCS8(privateKey, "RS256"));

// 	const response = await fetch(TOKEN_URI, {
// 		method: "POST",
// 		headers: { "Content-Type": "application/x-www-form-urlencoded" },
// 		body: new URLSearchParams({
// 			grant_type: "urn:ietf:params:oauth:grant-type:jwt-bearer",
// 			assertion: jwt,
// 		}),
// 	});

// 	if (!response.ok) {
// 		const errorText = await response.text();
// 		throw new Error(`Token exchange failed: ${errorText}`);
// 	}

// 	const data = await response.json();
// 	return data.access_token as string;
// };

// Deno.serve(async (req) => {
// 	try {
// 		if (req.method !== "POST") {
// 			return new Response("Method Not Allowed", { status: 405 });
// 		}

// 		const payload = await req.json();
// 		const token = payload.token as string | undefined;
// 		if (!token) {
// 			return new Response("Missing token", { status: 400 });
// 		}

// 		const accessToken = await getAccessToken();
// 		const projectId = getEnv("FCM_PROJECT_ID");

// 		const message: Record<string, unknown> = {
// 			message: {
// 				token,
// 				data: payload.data ?? {},
// 				android: {
// 					priority: "high",
// 				},
// 				apns: {
// 					headers: {
// 						"apns-priority": "10",
// 					},
// 				},
// 			},
// 		};

// 		// Only add notification block for non-call messages (call uses callkit UI)
// 		const msgType = (payload.data?.type ?? "").toString().toLowerCase();
// 		if (msgType !== "call") {
// 			(message["message"] as Record<string, unknown>)["notification"] = {
// 				title: payload.title ?? "Notification",
// 				body: payload.body ?? "",
// 			};
// 		}

// 		const response = await fetch(
// 			`https://fcm.googleapis.com/v1/projects/${projectId}/messages:send`,
// 			{
// 				method: "POST",
// 				headers: {
// 					Authorization: `Bearer ${accessToken}`,
// 					"Content-Type": "application/json",
// 				},
// 				body: JSON.stringify(message),
// 			},
// 		);

// 		const text = await response.text();
// 		return new Response(text, { status: response.status });
// 	} catch (e) {
// 		return new Response(`Error: ${e}`, { status: 500 });
// 	}
// });
