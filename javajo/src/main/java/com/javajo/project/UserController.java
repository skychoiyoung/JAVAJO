package com.javajo.project;

import java.util.HashMap;
import java.util.Map;
import java.util.Random;
import java.util.UUID;

import javax.mail.internet.MimeMessage;
import javax.servlet.http.Cookie;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.json.simple.JSONObject;
import org.json.simple.parser.JSONParser;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.mail.javamail.JavaMailSender;
import org.springframework.mail.javamail.MimeMessageHelper;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.github.scribejava.core.model.OAuth2AccessToken;
import com.javajo.project.dto.UserDTO;
import com.javajo.project.service.UserMapper;
import com.javajo.project.socialLogin.GoogleLoginService;
import com.javajo.project.socialLogin.KakaoLoginService;
import com.javajo.project.socialLogin.NaverLoginService;

@Controller
public class UserController {

	@Autowired
	UserMapper userMapper;
	@Autowired
	JavaMailSender mailSender;
	@Autowired
	private NaverLoginService naverLogin;
	@Autowired
	private KakaoLoginService kakaoLogin;
	@Autowired
	private GoogleLoginService googleLogin;

	@RequestMapping(value = { "/", "/login.do" }, method = RequestMethod.GET)
	public String login(HttpServletRequest req) {
		/* 네이버아이디로 인증 URL을 생성하기 위하여 naverLoginBO클래스의 getAuthorizationUrl메소드 호출 */
		String naverAuthUrl = naverLogin.getAuthorizationUrl(req.getSession());
		String kakaoAuthUrl = kakaoLogin.kakaoGetUrl();
		String googleAuthUrl = googleLogin.getAuthorizationUrl();
		req.setAttribute("googleUrl", googleAuthUrl);
		req.setAttribute("naverUrl", naverAuthUrl);
		req.setAttribute("kakaoUrl", kakaoAuthUrl);
		return "login_form";

	}

	@RequestMapping(value = { "/login.do" }, method = RequestMethod.POST)
	public String loginCheck(@RequestParam Map<String, String> params, HttpServletRequest req,
			HttpServletResponse resp) {
		UserDTO dto = userMapper.findUserById(params.get("user_id"));
		if (dto != null) {
			if (dto.getUser_enable().equals("N")) {
				req.setAttribute("msg", "이용이 불가능한 아이디입니다. 다시 가입 후 이용해주세요.");
				req.setAttribute("url", "login.do");
				return "message";
			}
			if (dto.getUser_passwd().equals(params.get("user_passwd"))) {
				Cookie ck = new Cookie("saveId", params.get("user_id"));
				if (params.containsKey("saveId")) {
					ck.setMaxAge(24 * 60 * 60);
				} else {
					ck.setMaxAge(0);
				}
				resp.addCookie(ck);
				req.getSession().setAttribute("inUser", dto);
				req.setAttribute("msg", dto.getUser_id() + "님이 로그인 하셨습니다.");
				req.setAttribute("url", "guest_index.do");

				// 관리자 아이디로 로그인 시 관리자페이지로 이동.

				if (dto.getUser_loginType().equals("admin")) {
					req.setAttribute("msg", "관리자아이디로 로그인 되었습니다. 관리자페이지로 이동합니다.");
					req.setAttribute("url", "list_notice.do");
					return "message";
				}

			} else {
				req.setAttribute("msg", "비밀번호가 틀렸습니다. 다시 확인 후 로그인 해주세요.");
				req.setAttribute("url", "login.do");
			}
		} else {
			req.setAttribute("msg", "등록되지 않은 ID입니다. 다시 확인 후 로그인 해주세요.");
			req.setAttribute("url", "login.do");
		}
		return "message";

	}

	// google 로그인 callBack
	@RequestMapping(value = "/googleCallback.do", method = { RequestMethod.GET, RequestMethod.POST })
	public String googleCallback(@RequestParam("code") String code, HttpServletRequest req) throws Exception {

		String accessToken = googleLogin.getAccessToken(code);
		Map<String, String> userInfo = googleLogin.getUserInfo(accessToken);

		String[] n_email = ((String) userInfo.get("email")).split("@");

		Map<String, String> params = new HashMap<>();
		params.put("user_email1", n_email[0]);
		params.put("user_email2", n_email[1]);
		params.put("user_loginType", "google");
		// 받아온 사용자 아이디
		String user_sid = (String) userInfo.get("id");
		// 자바조 아이디 : email1 에 _g 추가
		String user_id = n_email[0] + "_g";
		params.put("user_sid", user_sid);

		// 기존 일반 회원 체크
		UserDTO jdto = userMapper.findUserByEmail(params);
		if (jdto != null) {
			if (jdto.getUser_email1().equals(n_email[0]) && jdto.getUser_email2().equals(n_email[1])
					&& jdto.getUser_loginType().equals("join")) {
				int res = userMapper.socailJoinCheck(params);
				req.setAttribute("msg", jdto.getUser_id() + "님 기존 가입된 아이디로 로그인 됩니다.");
				req.getSession().setAttribute("inUser", jdto);
				req.setAttribute("url", "guest_index.do");
				return "message";
			}
		}

		// 로그인타입, 이메일로 가입유무
		UserDTO dto = userMapper.findUserBySocial(params);
		if (dto == null) {
			// enable 이 n 이었던 유저
			if (userMapper.findUserBySid(user_sid) != null) {
				int res = userMapper.enableChangeY(params);
				req.setAttribute("msg", user_id + "님 사이트이용을 위해 비밀번호와 전화번호를 설정해주세요.");
				req.getSession().setAttribute("inUser", userMapper.findUserBySid(user_sid));
				req.setAttribute("url", "social_edit.do?sr=srg");
				return "message";
			}
			// 등록안되있는 경우 구글정보 받아서 회원가입
			UserDTO udto = new UserDTO();
			udto.setUser_id(user_id);
			udto.setUser_sid(user_sid);
			udto.setUser_passwd(UUID.randomUUID().toString().replace("-", "").substring(0, 13));
			udto.setUser_name(userInfo.get("name"));
			udto.setUser_hp1("010");
			udto.setUser_hp2("0000");
			udto.setUser_hp3("0000");
			udto.setUser_email1(n_email[0]);
			udto.setUser_email2(n_email[1]);
			udto.setUser_loginType("google");
			int res = userMapper.insertUser(udto);
			if (res > 0) {
				req.getSession().setAttribute("inUser", udto);
				// 구글 전화번호 x 직접 입력하도록 요청
				req.setAttribute("msg", user_id + "님 사이트이용을 위해 비밀번호와 전화번호를 설정해주세요.");
				req.setAttribute("url", "social_edit.do?sr=srg");
			} else {
				req.setAttribute("msg", "등록 실패. 다시 시도 해주세요.");
				req.setAttribute("url", "login_do");
			}
		} else {
			req.setAttribute("msg", dto.getUser_id() + "님이 로그인 하셨습니다.");
			req.getSession().setAttribute("inUser", dto);
			req.setAttribute("url", "guest_index.do");
		}
		return "message";
	}

	// 네이버 로그인 callBack
	@RequestMapping(value = "/naverCallback.do", method = { RequestMethod.GET, RequestMethod.POST })
	public String naverCallback(HttpServletRequest req, @RequestParam String code, @RequestParam String state)
			throws Exception {
		OAuth2AccessToken oauthToken;
		oauthToken = naverLogin.getAccessToken(req.getSession(), code, state);
		// 로그인 사용자 정보를 읽어온다.
		String apiResult = naverLogin.getUserProfile(oauthToken);
		req.setAttribute("result", apiResult);

		JSONParser parser = new JSONParser();
		JSONObject jsonObj = (JSONObject) parser.parse(apiResult);
		JSONObject resObj = (JSONObject) jsonObj.get("response");

		// "id":"CwcmtlCsh9RL2AS_gK-m_ET1UrQsTzcmer_RYWLJt7o",
		// "email":"sky2463@naver.com",
		// "mobile":"010-6859-4432",
		// "mobile_e164":"+821068594432",
		// "name":"\ucd5c\uc9c4\uc601"}}
		String[] n_email = ((String) resObj.get("email")).split("@");
		String[] n_hp = ((String) resObj.get("mobile")).split("-");

		Map<String, String> params = new HashMap<>();
		params.put("user_email1", n_email[0]);
		params.put("user_email2", n_email[1]);
		params.put("user_loginType", "naver");
		// 받아온 사용자 아이디
		String user_sid = (String) resObj.get("id");
		// 자바조 아이디 : email1 에 _n 추가
		String user_id = n_email[0] + "_n";
		params.put("user_sid", user_sid);

		// 기존 일반 회원 체크
		UserDTO jdto = userMapper.findUserByEmail(params);
		if (jdto != null) {
			if (jdto.getUser_email1().equals(n_email[0]) && jdto.getUser_email2().equals(n_email[1])
					&& jdto.getUser_loginType().equals("join")) {
				int res = userMapper.socailJoinCheck(params);
				req.setAttribute("msg", jdto.getUser_id() + "님 기존 가입된 아이디로 로그인 됩니다.");
				req.getSession().setAttribute("inUser", jdto);
				req.setAttribute("url", "guest_index.do");
				return "message";
			}
		}

		// 로그인타입, 이메일로 가입유무
		UserDTO dto = userMapper.findUserBySocial(params);
		if (dto == null) {
			// enable 이 n 이었던 유저
			if (userMapper.findUserBySid(user_sid) != null) {
				int res = userMapper.enableChangeY(params);
				req.setAttribute("msg", user_id + "님 사이트이용을 위해 비밀번호를 설정해주세요.");
				UserDTO inUser = userMapper.findUserBySid(user_sid);
				inUser.setUser_hp1(n_hp[0]);
				inUser.setUser_hp2(n_hp[1]);
				inUser.setUser_hp3(n_hp[2]);
				req.getSession().setAttribute("inUser", inUser);
				req.setAttribute("url", "social_edit.do?sr=sr");
				return "message";
			}
			// 등록안되있는 경우 네이버정보 받아서 회원가입
			UserDTO udto = new UserDTO();
			udto.setUser_id(user_id);
			udto.setUser_sid(user_sid);
			udto.setUser_passwd(UUID.randomUUID().toString().replace("-", "").substring(0, 13));
			udto.setUser_name((String) resObj.get("name"));
			udto.setUser_hp1(n_hp[0]);
			udto.setUser_hp2(n_hp[1]);
			udto.setUser_hp3(n_hp[2]);
			udto.setUser_email1(n_email[0]);
			udto.setUser_email2(n_email[1]);
			udto.setUser_loginType("naver");
			int res = userMapper.insertUser(udto);
			if (res > 0) {
				req.getSession().setAttribute("inUser", udto);
				req.setAttribute("msg", user_id + "님 사이트이용을 위해 비밀번호를 설정해주세요.");
				req.setAttribute("url", "social_edit.do?sr=sr");
			} else {
				req.setAttribute("msg", "등록 실패. 다시 시도 해주세요.");
				req.setAttribute("url", "login_do");
			}
		} else {
			req.setAttribute("msg", dto.getUser_id() + "님이 로그인 하셨습니다.");
			req.getSession().setAttribute("inUser", dto);
			req.setAttribute("url", "guest_index.do");
		}
		return "message";
	}

	// 카카오 로그인 callBack
	@RequestMapping(value = "kakaoCallback.do")
	public String kakaoCallback(HttpServletRequest req, @RequestParam(value = "code", required = false) String code)
			throws Exception {
		String access_Token = kakaoLogin.kakaoGetAccessToken(code);
		Map<String, String> userInfo = kakaoLogin.kakaoGetUserInfo(access_Token);
		userInfo.put("user_loginType", "kakao");
		// 기존에 정보가 등록되어 있는 지 체크
		UserDTO dto = userMapper.findUserBySocial(userInfo);
		// 받아온 사용자 아이디
		String user_sid = (String) userInfo.get("kakao_id");
		// 자바조 아이디 : email1 에 _k 추가
		String user_id = userInfo.get("user_email1") + "_k";
		userInfo.put("user_sid", user_sid);

		// 기존 일반 회원 체크
		UserDTO jdto = userMapper.findUserByEmail(userInfo);
		if (jdto != null) {
			if (jdto.getUser_email1().equals(userInfo.get("user_email1"))
					&& jdto.getUser_email2().equals(userInfo.get("user_email2"))
					&& jdto.getUser_loginType().equals("join")) {
				int res = userMapper.socailJoinCheck(userInfo);
				req.setAttribute("msg", jdto.getUser_id() + "님 기존 가입된 아이디로 로그인 됩니다.");
				req.getSession().setAttribute("inUser", jdto);
				req.setAttribute("url", "guest_index.do");
				return "message";
			}
		}
		if (dto == null) {
			// enable 이 n 이었던 유저
			if (userMapper.findUserBySid(user_sid) != null) {
				int res = userMapper.enableChangeY(userInfo);
				req.setAttribute("msg", user_id + "님 사이트이용을 위해 비밀번호를 설정해주세요.");
				UserDTO inUser = userMapper.findUserBySid(user_sid);
				inUser.setUser_hp1(userInfo.get("user_hp1"));
				inUser.setUser_hp2(userInfo.get("user_hp2"));
				inUser.setUser_hp3(userInfo.get("user_hp3"));
				req.getSession().setAttribute("inUser", inUser);
				req.setAttribute("url", "social_edit.do?sr=sr");
				return "message";
			}
			// 없으면 카카오 정보 받아서 가입시킴
			UserDTO udto = new UserDTO();
			udto.setUser_id(user_id);
			udto.setUser_sid(user_sid);
			udto.setUser_passwd(UUID.randomUUID().toString());
			udto.setUser_name(userInfo.get("user_name"));
			udto.setUser_hp1(userInfo.get("user_hp1"));
			udto.setUser_hp2(userInfo.get("user_hp2"));
			udto.setUser_hp3(userInfo.get("user_hp3"));
			udto.setUser_email1(userInfo.get("user_email1"));
			udto.setUser_email2(userInfo.get("user_email2"));
			udto.setUser_loginType("kakao");
			int res = userMapper.insertUser(udto);
			if (res > 0) {
				req.getSession().setAttribute("inUser", udto);
				req.setAttribute("msg", user_id + "님 사이트이용을 위해 비밀번호를 설정해주세요.");
				req.setAttribute("url", "social_edit.do?sr=sr");
			} else {
				req.setAttribute("msg", "등록 실패. 다시 시도 해주세요.");
				req.setAttribute("url", "login_do");
			}
		} else {
			req.setAttribute("msg", dto.getUser_id() + "님이 로그인 하셨습니다.");
			req.getSession().setAttribute("inUser", dto);
			req.setAttribute("url", "guest_index.do");
		}
		return "message";
	}

	@RequestMapping(value = { "/join_form.do" }, method = RequestMethod.GET)
	public String joinform() {
		return "join_form";
	}

	@RequestMapping(value = { "/join_form.do" }, method = RequestMethod.POST)
	public String joinformOk(@ModelAttribute UserDTO dto, HttpServletRequest req) {
		int res = userMapper.insertUser(dto);
		if (res > 0) {
			req.setAttribute("msg", "회원등록성공. 로그인 페이지로 이동합니다.");
			req.setAttribute("url", "login.do");
			return "message";
		} else {
			req.setAttribute("msg", "회원등록실패. 다시 시도 해주세요.");
			req.setAttribute("url", "join_form.do");
			return "message";
		}
	}

	@ResponseBody
	@RequestMapping(value = { "/idCheck.do" })
	public String checkId(@RequestParam("id") String id) {
		int res = userMapper.checkId(id);
		if (res == 0) {
			return "OK";
		} else {
			return "FAIL";
		}
	}

	@ResponseBody
	@RequestMapping(value = { "/emailCheck.do" })
	public String checkEamil(@RequestParam Map<String, String> params) {
		UserDTO dto = userMapper.findUserByEmail(params);
		// SNS로 등록 된 적 있는 지 확인 + 메일 중복체크
		if (dto != null) {
			if (dto.getUser_sid().equals("") || dto.getUser_sid() != null) {
				return "SNS";
			}
			return "FAIL";
		}
		return "OK";
	}

	@ResponseBody
	@RequestMapping(value = { "/sendEmail.do" })
	public String sendMail(@RequestParam Map<String, String> params, HttpServletResponse resp, HttpServletRequest req)
			throws Exception {
		MimeMessage msg = mailSender.createMimeMessage();
		MimeMessageHelper helper = new MimeMessageHelper(msg, true);
		String email = params.get("user_email1") + "@" + params.get("user_email2");
		Random random = new Random();
		String code = String.valueOf(random.nextInt(900000) + 100000);
		// 랜덤으로 생성된 code 값 쿠키에 저장.
		Cookie cookie = new Cookie("checkCode", code);
		cookie.setMaxAge(60 * 3); // 쿠키수명 3분
		resp.addCookie(cookie);

		// 보내는 사람 이메일 주소 설정.
		helper.setFrom("skychoiyoung@gmail.com");
		helper.setTo(email);
		helper.setSubject("JAVAJO 인증메일 입니다.");
		helper.setText("안녕하세요!! JAVOJO 입니다.\n\n 이메일 인증 번호 : " + code
				+ "\n\n 회원가입을 진행 하시려면 해당 인증번호를 해당 칸에 입력해주세요.\n 이용해주셔서 감사합니다.");
		mailSender.send(msg);

		return "OK";
	}

	// 입력 받은 코드와 쿠키에 저장된 코드 비교
	@ResponseBody
	@RequestMapping(value = { "/codeCheck.do" })
	public String codeCheck(@RequestParam("code") String code, HttpServletRequest req) {
		Cookie[] ck = req.getCookies();
		if (ck != null) {
			for (Cookie cookie : ck) {
				if (cookie.getName().contentEquals("checkCode")) {
					if (cookie.getValue().equals(code)) {
						return "OK";
					}
				}
			}
		}
		return "FAIL";
	}

	@RequestMapping(value = { "/logout.do" })
	public String logout(HttpServletRequest req) {
		req.getSession().invalidate();
		req.setAttribute("msg", "로그아웃 되었습니다.");
		req.setAttribute("url", "login.do");
		return "message";
	}

	@RequestMapping(value = { "/find_info.do" }, method = RequestMethod.GET)
	public String findInfo(HttpServletRequest req, String mode) {
		req.setAttribute("mode", mode);
		return "find_info";
	}

	@RequestMapping(value = { "/find_info.do" }, method = RequestMethod.POST)
	public String findInfoOk(@RequestParam Map<String, String> params, HttpServletRequest req) throws Exception {
		MimeMessage msg = mailSender.createMimeMessage();
		MimeMessageHelper helper = new MimeMessageHelper(msg, true);
		UserDTO dto = userMapper.findUserByEmail(params);
		if (dto == null) {
			req.setAttribute("msg", "등록되지 않은 이메일입니다.");
			return "windowClose";
		}
		if (!dto.getUser_loginType().equals("join")) {
			req.setAttribute("msg", "소셜로그인로 가입된 아이디가 있습니다. 확인 후 이용해주세요.");
			return "windowClose";
		}
		if (params.get("user_id") == null) {
			req.setAttribute("msg", "찾으시는 아이디는 " + dto.getUser_id() + " 입니다.");
		} else {
			String email = params.get("user_email1") + "@" + params.get("user_email2");
			// 보내는 사람 이메일 주소 설정.
			helper.setFrom("skychoiyoung@gmail.com");
			helper.setTo(email);
			helper.setSubject("JAVAJO 요청하신 정보입니다.");
			helper.setText("안녕하세요!! JAVOJO 입니다.\n\n 현재 비밀번호 : " + dto.getUser_passwd()
					+ " \n\n 개인 정보 변경은 로그인 후 회원정보수정 이용 바랍니다.\n 이용해주셔서 감사합니다.");
			mailSender.send(msg);
			req.setAttribute("msg", "해당 이메일로 정보를 전송하였습니다.");
		}
		return "windowClose";
	}

	@RequestMapping(value = { "/enable_user.do" })
	public String enableUser(HttpServletRequest req) {
		UserDTO dto = (UserDTO) req.getSession().getAttribute("inUser");
		int houseRemain = userMapper.checkRemainsHouse(dto.getUser_id());
		int reservRemain = userMapper.checkRemainsGuest(dto.getUser_id());
		if (houseRemain > 0) {
			req.setAttribute("msg", "등록된 숙소를 삭제 후 이용해주세요.");
			return "message";
		} else if (reservRemain > 0) {
			req.setAttribute("msg", "예약된 숙소내역이 남아 있습니다.");
			return "message";
		}

		Map<String, String> userInfo = new HashMap<String, String>();
		userInfo.put("id", dto.getUser_id());
		userInfo.put("type", dto.getUser_loginType());
		int res = userMapper.enableUser(userInfo);
		req.getSession().invalidate();
		if (res > 0) {
			req.setAttribute("msg", "그동안 JAVAJO를 이용해주셔서 감사합니다.");
			req.setAttribute("url", "login.do");
		} else {
			req.setAttribute("msg", "실패했습니다. 메인페이지로 이동합니다.");
			req.setAttribute("url", "guest_index.do");
		}
		return "message";
	}

	@ResponseBody
	@RequestMapping(value = { "/passwdCheck.do" }, method = { RequestMethod.GET, RequestMethod.POST })
	public String passwdCheck(HttpServletRequest req, @RequestParam("inputPw") String inputPw) {
		UserDTO dto = (UserDTO) req.getSession().getAttribute("inUser");
		if (dto.getUser_passwd().equals(inputPw)) {
			return "OK";
		} else {
			return "FAIL";
		}
	}

	@RequestMapping(value = { "/social_edit.do" }, method = RequestMethod.GET)
	public String socialEdit(HttpServletRequest req) {
		req.getSession().getAttribute("inUser");
		return "social_edit";
	}

	@RequestMapping(value = { "/social_edit.do" }, method = RequestMethod.POST)
	public String socialEditOk(HttpServletRequest req, @RequestParam Map<String, String> params,
			@ModelAttribute UserDTO update_dto) {
		int res = userMapper.updateUser(update_dto);
		UserDTO dto = userMapper.findUserById(params.get("user_id"));
		if (res > 0) {
			req.setAttribute("msg", "정보가 등록되었습니다.");
			req.setAttribute("url", "guest_index.do");
			req.getSession().setAttribute("inUser", dto);
		} else {
			req.setAttribute("msg", "정보등록에 실패했습니다. ");
		}
		return "message";
	}

	@RequestMapping(value = { "/edit_form.do" }, method = RequestMethod.GET)
	public String editUser(HttpServletRequest req) {
		req.getSession().getAttribute("inUser");
		return "guest/edit_form";
	}

	@RequestMapping(value = { "/edit_form.do" }, method = RequestMethod.POST)
	public String editOkUser(HttpServletRequest req, @RequestParam Map<String, String> params,
			@ModelAttribute UserDTO update_dto) {
		int res = userMapper.updateUser(update_dto);
		UserDTO dto = userMapper.findUserById(params.get("user_id"));
		if (res > 0) {
			req.getSession().setAttribute("inUser", dto);
			req.setAttribute("msg", "정보가 수정되었습니다.");
			req.setAttribute("url", "guest_index.do");
		} else {
			req.setAttribute("msg", "정보수정에 실패했습니다. ");
			req.setAttribute("url", "edit_form.do");
		}
		return "message";
	}

	@RequestMapping("/term.do")
	public String termJavajo(HttpServletRequest req, @RequestParam("term") String term) {
		if (term.equals("term"))
			return "javajoTerm";
		else
			return "javajoTerm2";
	}

	@ResponseBody
	@RequestMapping(value = { "/sessionUserCheck" })
	public boolean sessionUserCheck(HttpServletRequest req) {
		return req.getSession() != null && req.getSession().getAttribute("inUser") != null;
	}

	// 회원 DB에서 삭제
//	@RequestMapping(value = { "/delete_user.do" })
//	public String deleteUser(HttpServletRequest req, @RequestParam("id") String id) {
//		int res = userMapper.deleteUser(id);
//		if (res > 0) {
//			req.setAttribute("msg", "삭제되었습니다.");
//		} else {
//			req.setAttribute("msg", "삭제에 실패했습니다.");
//		}
//		return "message";
//	}
}