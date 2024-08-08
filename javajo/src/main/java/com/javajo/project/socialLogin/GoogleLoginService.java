package com.javajo.project.socialLogin;

import java.io.BufferedReader;
import java.io.InputStreamReader;
import java.io.OutputStreamWriter;
import java.net.HttpURLConnection;
import java.net.URL;
import java.util.HashMap;
import java.util.Map;

import org.json.simple.JSONObject;
import org.json.simple.parser.JSONParser;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.context.annotation.PropertySource;
import org.springframework.stereotype.Service;

@PropertySource({"classpath:application.properties"})
@Service
public class GoogleLoginService {
	
	@Value("${google.clientiId}")
	private String clientiId;
	@Value("${google.clientSecret}")
	private String clientSecret;
	@Value("${google.redirectUri}")
	private String redirectUri;
	@Value("${google.tokenUrl}")
	private String tokenUrl;
	@Value("${google.userInfoUrl}")
	private String userInfoUrl;

	// 로그인 url 생성
	public String getAuthorizationUrl() {
		String url = "https://accounts.google.com/o/oauth2/v2/auth?" + "client_id=" + clientiId + "&redirect_uri="
				+ redirectUri + "&response_type=code" + "&scope=email profile";
		return url;
	}
	
	// client 정보로 accessToken 받아오기
	public String getAccessToken(String authorizationCode) throws Exception {
		URL url = new URL(tokenUrl);
		HttpURLConnection conn = (HttpURLConnection) url.openConnection();
		conn.setRequestMethod("POST");
		conn.setDoOutput(true);

		String params = "code=" + authorizationCode + "&client_id=" + clientiId + "&client_secret=" + clientSecret
				+ "&redirect_uri=" + redirectUri + "&grant_type=authorization_code";

		OutputStreamWriter writer = new OutputStreamWriter(conn.getOutputStream());
		writer.write(params);
		writer.flush();

		BufferedReader reader = new BufferedReader(new InputStreamReader(conn.getInputStream()));
		String line;
		StringBuilder response = new StringBuilder();
		while ((line = reader.readLine()) != null) {
			response.append(line);
		}
		reader.close();
		writer.close();

		JSONParser parser = new JSONParser();
		JSONObject json = (JSONObject) parser.parse(response.toString());
		return (String) json.get("access_token");
	}

	// accessTocken 으로 유저정보 받아오기
	public Map<String, String> getUserInfo(String accessToken) throws Exception {
		URL url = new URL(userInfoUrl);
		HttpURLConnection conn = (HttpURLConnection) url.openConnection();
		conn.setRequestMethod("GET");
		conn.setRequestProperty("Authorization", "Bearer " + accessToken);

		BufferedReader reader = new BufferedReader(new InputStreamReader(conn.getInputStream()));
		String line;
		StringBuilder response = new StringBuilder();
		while ((line = reader.readLine()) != null) {
			response.append(line);
		}
		reader.close();

		JSONParser parser = new JSONParser();
		JSONObject json = (JSONObject) parser.parse(response.toString());

		Map<String, String> userInfo = new HashMap<>();
		userInfo.put("id", (String) json.get("id"));
		userInfo.put("email", (String) json.get("email"));
		userInfo.put("name", (String) json.get("name"));
		userInfo.put("picture", (String) json.get("picture"));
		return userInfo;
	}
}