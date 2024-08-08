package com.javajo.project.socialLogin;

import java.io.BufferedReader;
import java.io.BufferedWriter;
import java.io.IOException;
import java.io.InputStreamReader;
import java.io.OutputStreamWriter;
import java.net.HttpURLConnection;
import java.net.URL;
import java.util.HashMap;
import java.util.Map;

import org.json.simple.JSONObject;
import org.json.simple.parser.JSONParser;
import org.json.simple.parser.ParseException;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.context.annotation.PropertySource;
import org.springframework.stereotype.Service;

@PropertySource({"classpath:application.properties"})
@Service
public class KakaoLoginService {

	@Value("${kakao.clientId}")
	private String clientId ;
	@Value("${kakao.redirectUri}")
	private String redirectUri ;
	@Value("${kakao.tokenUrl}")
	private String tokenUrl ;
	@Value("${kakao.authorizeUrl}")
	private String authorizeUrl;
	@Value("${kakao.userInfoUrl}")
	private String userInfoUrl;

	public String kakaoGetUrl() {
		StringBuilder url = new StringBuilder(authorizeUrl);
		url.append("?response_type=code");
		url.append("&client_id=").append(clientId);
		url.append("&redirect_uri=").append(encodeURIComponent(redirectUri));
		url.append("&state=").append("RANDOM_STATE_STRING"); // CSRF 방지를 위한 상태 값

		return url.toString();
	}

	public String kakaoGetAccessToken(String authorize_code) throws IOException, ParseException {
		String access_Token = "";
		String refresh_Token = "";

		URL url = new URL(tokenUrl);

		HttpURLConnection conn = (HttpURLConnection) url.openConnection();

		// POST 요청을 위해 기본값이 false인 setDoOutput을 true로
		conn.setRequestMethod("POST");
		conn.setDoOutput(true);

		// POST 요청에 필요로 요구하는 파라미터 스트림을 통해 전송
		BufferedWriter bw = new BufferedWriter(new OutputStreamWriter(conn.getOutputStream()));
		StringBuilder sb = new StringBuilder();
		sb.append("grant_type=authorization_code");
		sb.append("&client_id=" + clientId); // 본인이 발급받은 key
		sb.append("&redirect_uri=" + redirectUri); // 본인이 설정해 놓은 경로
		sb.append("&code=" + authorize_code);
		bw.write(sb.toString());
		bw.flush();

		// 결과 코드가 200이라면 성공
		// int responseCode = conn.getResponseCode();

		// 요청을 통해 얻은 JSON타입의 Response 메세지 읽어오기
		BufferedReader br = new BufferedReader(new InputStreamReader(conn.getInputStream()));
		String line = "";
		String result = "";

		while ((line = br.readLine()) != null) {
			result += line;
		}

		// Gson 라이브러리에 포함된 클래스로 JSON파싱 객체 생성
		JSONParser parser = new JSONParser();

		// JSON 문자열을 파싱하여 JSONObject로 변환
		JSONObject jsonObject = (JSONObject) parser.parse(result);

		// 토큰 추출
		access_Token = (String) jsonObject.get("access_token");
		refresh_Token = (String) jsonObject.get("refresh_token");

		// 결과 출력

		br.close();
		bw.close();

		return access_Token;
	}

	public Map<String, String> kakaoGetUserInfo(String access_Token) throws IOException, ParseException {

		// 요청하는 클라이언트마다 가진 정보가 다를 수 있기에 HashMap타입으로 선언
		Map<String, String> userInfo = new HashMap<>();

		URL url = new URL(userInfoUrl);
		HttpURLConnection conn = (HttpURLConnection) url.openConnection();
		conn.setRequestMethod("GET");

		// 요청에 필요한 Header에 포함될 내용
		conn.setRequestProperty("Authorization", "Bearer " + access_Token);

		// int responseCode = conn.getResponseCode();

		BufferedReader br = new BufferedReader(new InputStreamReader(conn.getInputStream()));

		String line = "";
		String result = "";

		while ((line = br.readLine()) != null) {
			result += line;
		}

		JSONParser parser = new JSONParser();
		JSONObject jsonObj = (JSONObject) parser.parse(result);
		JSONObject resObj = (JSONObject) jsonObj.get("kakao_account");

//		{"id":3588036900,"connected_at":"2024-06-20T04:39:05Z",
//			"name":"최진영","has_email":true,
//			"email":"skychoiyoung@nate.com","has_phone_number":true,"phone_number_needs_agreement":false,
//			"phone_number":"+82 10-6859-4432"}}

		String kakao_id = String.valueOf(jsonObj.get("id"));
		String kakao_name = (String) resObj.get("name");
		String[] kakao_email = ((String) resObj.get("email")).split("@");
		String hp = (String) resObj.get("phone_number");
		hp = hp.replace("+82 ", "");
		hp = "0" + hp;
		String[] kakao_phone = hp.split("-");

		userInfo.put("kakao_id", kakao_id);
		userInfo.put("user_name", kakao_name);
		userInfo.put("user_email1", kakao_email[0]);
		userInfo.put("user_email2", kakao_email[1]);
		userInfo.put("user_hp1", kakao_phone[0]);
		userInfo.put("user_hp2", kakao_phone[1]);
		userInfo.put("user_hp3", kakao_phone[2]);

		return userInfo;
	}

	private String encodeURIComponent(String value) {
		try {
			return java.net.URLEncoder.encode(value, "UTF-8");
		} catch (Exception e) {
			return value;
		}
	}
}