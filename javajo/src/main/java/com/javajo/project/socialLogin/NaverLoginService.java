package com.javajo.project.socialLogin;

import java.io.IOException;
import java.util.UUID;

import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.context.annotation.PropertySource;
import org.springframework.stereotype.Service;
import org.springframework.util.StringUtils;

import com.github.scribejava.core.builder.ServiceBuilder;
import com.github.scribejava.core.builder.api.DefaultApi20;
import com.github.scribejava.core.model.OAuth2AccessToken;
import com.github.scribejava.core.model.OAuthRequest;
import com.github.scribejava.core.model.Response;
import com.github.scribejava.core.model.Verb;
import com.github.scribejava.core.oauth.OAuth20Service;

@PropertySource({"classpath:application.properties"})
@Service
public class NaverLoginService extends DefaultApi20 {
	
	@Value("${naver.clientId}")
	private String clientId ;
	@Value("${naver.clientSecret}")
	private String clientSecret;
	@Value("${naver.redirectUri}")
    private String redirectUri;
	
	@Override
	public String getAccessTokenEndpoint() {
		return "https://nid.naver.com/oauth2.0/token?grant_type=authorization_code";
	}

	@Override
	protected String getAuthorizationBaseUrl() {
		return "https://nid.naver.com/oauth2.0/authorize";
	}

	/* 네이버 아이디로 인증 URL 생성 Method */
	public String getAuthorizationUrl(HttpSession session) {

		/* 세션 유효성 검증을 위하여 난수를 생성 */
		String state = UUID.randomUUID().toString();
		/* 생성한 난수 값을 session에 저장 */
		session.setAttribute("oauth_state", state);

		/* Scribe에서 제공하는 인증 URL 생성 기능을 이용하여 네아로 인증 URL 생성 */
		OAuth20Service oauthService = new ServiceBuilder().apiKey(clientId).apiSecret(clientSecret)
				.callback(redirectUri).state(state) // 앞서 생성한 난수값을 인증 URL생성시 사용함
				.build(NaverLoginService.this);

		return oauthService.getAuthorizationUrl();
	}

	/* 네이버아이디로 Callback 처리 및 AccessToken 획득 Method */
	public OAuth2AccessToken getAccessToken(HttpSession session, String code, String state) throws IOException {

		/* Callback으로 전달받은 세선검증용 난수값과 세션에 저장되어있는 값이 일치하는지 확인 */
		String sessionState = (String) session.getAttribute("oauth_state");
		if (StringUtils.pathEquals(sessionState, state)) {

			OAuth20Service oauthService = new ServiceBuilder().apiKey(clientId).apiSecret(clientSecret)
					.callback(redirectUri).state(state)
					.build(NaverLoginService.this);

			/* Scribe에서 제공하는 AccessToken 획득 기능으로 네아로 Access Token을 획득 */
			OAuth2AccessToken accessToken = oauthService.getAccessToken(code);
			return accessToken;
		}
		return null;
	}

	/* Access Token을 이용하여 네이버 사용자 프로필 API를 호출 */
	public String getUserProfile(OAuth2AccessToken oauthToken) throws IOException {
		OAuth20Service oauthService = new ServiceBuilder().apiKey(clientId).apiSecret(clientSecret)
				.callback(redirectUri).build(NaverLoginService.this);

		OAuthRequest request = new OAuthRequest(Verb.GET, "https://openapi.naver.com/v1/nid/me", oauthService);
		oauthService.signRequest(oauthToken, request);
		Response response = request.send();
		return response.getBody();
	}
}