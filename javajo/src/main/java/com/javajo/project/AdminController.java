package com.javajo.project;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;

import com.javajo.project.dto.AdminQnaDTO;
import com.javajo.project.dto.NoticeDTO;
import com.javajo.project.dto.ReservDTO;
import com.javajo.project.dto.UserDTO;
import com.javajo.project.service.AdminMapper;
import com.javajo.project.service.UserMapper;

@Controller
public class AdminController {

	@Autowired
	UserMapper userMapper;

	@Autowired
	AdminMapper adminMapper;

	// 페이징처리 메소드
	public Map<String, Object> paginate(int count, int pageNum) {
		// 한 페이지에 보여질 게시글 수
		int pageSize = 10;
		// 페이지 넘버
		int startRow = ((pageNum - 1) * pageSize) + 1; // 페이지별로 시작 넘버 // 1
		int endRow = startRow + pageSize - 1; // 페이지별로 끝 넘버 // 5
		if (endRow > count)
			endRow = count;
		// 화면에 보여질 번호
		int no = count - startRow + 1; // 21 17 12 ... 페이지별 시작 넘버
		// 페이징번호 보여줄 [1][2][3] 최대 갯수
		int pageBlock = 3;
		// 총 페이징 번호 갯수
		int pageCount = count / pageSize + (count % pageSize == 0 ? 0 : 1);
		// 페이징 시작 번호 [1], [4], [7]...
		int startPage = (pageNum - 1) / pageBlock * pageBlock + 1;
		// 페이징 끝 번호 [3], [6], [9]...
		int endPage = startPage + pageBlock - 1;
		if (endPage > pageCount)
			endPage = pageCount;

		Map<String, Object> rowMap = new HashMap<>();
		rowMap.put("no", no);
		rowMap.put("startRow", startRow);
		rowMap.put("endRow", endRow);
		rowMap.put("pageBlock", pageBlock);
		rowMap.put("pageCount", pageCount);
		rowMap.put("startPage", startPage);
		rowMap.put("endPage", endPage);

		return rowMap;
	}

	// 회원 조회
	// 회원 조회 메인 페이지
	@RequestMapping(value = { "/list_user.do" }, method = RequestMethod.GET)
	public String listUser(HttpServletRequest req,
			@RequestParam(value = "pageNum", required = false, defaultValue = "1") int pageNum) {
		// 페이징처리
		int userCount = userMapper.getUserCount();

		Map<String, Object> row = paginate(userCount, pageNum);

		List<UserDTO> list = userMapper.listAllUser(row);
		
		req.setAttribute("startPage", (int) row.get("startPage"));
		req.setAttribute("endPage", (int) row.get("endPage"));
		req.setAttribute("pageBlock", (int) row.get("pageBlock"));
		req.setAttribute("pageCount", (int) row.get("pageCount"));
		req.setAttribute("listUser", list);

		return "admin/admin_userList";
	}

	// 회원 검색
	@RequestMapping("/find_user.do")
	public String findUser(HttpServletRequest req, @RequestParam Map<String, Object> params,
			@RequestParam(value = "pageNum", required = false, defaultValue = "1") int pageNum) {

		// 페이징처리
		int searchCount = userMapper.getSearchCount(params);

		Map<String, Object> row = paginate(searchCount, pageNum);

		params.put("startRow", (int) row.get("startRow"));
		params.put("endRow", (int) row.get("endRow"));
		
		System.out.println("userEnable:"+params.get("userEnable"));
		List<UserDTO> list = userMapper.findUserType(params); // 사용자 목록 가져오기

		req.setAttribute("findUser", list); // 결과를 JSP에 전달
		req.setAttribute("startPage", (int) row.get("startPage"));
		req.setAttribute("endPage", (int) row.get("endPage"));
		req.setAttribute("pageCount", (int) row.get("pageCount"));
		req.setAttribute("pageBlock", (int) row.get("pageBlock"));
		req.setAttribute("search", params.get("search"));
		req.setAttribute("searchString", params.get("searchString"));
		req.setAttribute("userEnable", params.get("userEnable"));
		return "admin/admin_userList";
	}

	// 공지사항
	// 공지사항 메인 페이지 - 페이징처리
	@RequestMapping(value = { "/list_notice.do" }, method = RequestMethod.GET) // 두개 페이지가 하나로 가야될때 이렇게 {}로 처리
	public String listNotice(HttpServletRequest req,
			@RequestParam(value = "pageNum", required = false, defaultValue = "1") int pageNum) {
		int noticeCount = adminMapper.noticeCount();

		Map<String, Object> row = paginate(noticeCount, pageNum);

		List<NoticeDTO> list = adminMapper.listNotice(row);

		req.setAttribute("startPage", (int) row.get("startPage"));
		req.setAttribute("endPage", (int) row.get("endPage"));
		req.setAttribute("pageCount", (int) row.get("pageCount"));
		req.setAttribute("pageBlock", (int) row.get("pageBlock"));
		req.setAttribute("no", (int) row.get("no"));
		req.setAttribute("listNotice", list);
		return "admin/admin_list";
	}

	// 공지사항 등록
	// list.jsp에서 등록 버튼 클릭시 writeForm 공지사항 form 페이지로 이동
	@RequestMapping(value = { "/write_notice.do" }, method = RequestMethod.GET)
	public String writeForm() {
		return "admin/admin_writeForm";
	}

	// writeForm.jsp에서 데이터 담고 다시 공지사항 페이지로 이동
	@RequestMapping(value = { "/write_noticeOk.do" }, method = RequestMethod.POST)
	public String writeProForm(HttpServletRequest req, NoticeDTO dto) {
		int res = adminMapper.insertNotice(dto);
		if (res > 0) {
			req.setAttribute("msg", "공지사항이 등록되었습니다.");
		} else {
			req.setAttribute("msg", "공지사항 등록에 실패하였습니다. 관리자에게 문의바랍니다.");
		}
		req.setAttribute("url", "list_notice.do");
		return "message";
	}

	@RequestMapping(value = { "/admin_noticont.do" })
	public String noticeCont(HttpServletRequest req, @RequestParam("notice_num") int notice_num) {
		NoticeDTO dto = adminMapper.getNoticeByNum(notice_num);
		req.setAttribute("getNotice", dto);
		return "admin/admin_noticont";
	}

	// list.jsp에서 제목 클릭시 수정 페이지로 이동하는데,
	// notice_num을 파라미터를 통해 기존 데이터를 가져온다.
	@RequestMapping(value = { "/update_notice.do" }, method = RequestMethod.GET)
	public String updateForm(HttpServletRequest req, @RequestParam("notice_num") int notice_num) {
		NoticeDTO dto = adminMapper.getNoticeByNum(notice_num);
		req.setAttribute("getNotice", dto);
		return "admin/admin_updateForm";
	}

	// 공지사항 수정
	@RequestMapping(value = { "/update_noticeOk.do" }, method = RequestMethod.POST)
	public String updateOkNotice(HttpServletRequest req, @ModelAttribute NoticeDTO dto,
			@RequestParam("notice_num") int notice_num) {
		int res = adminMapper.updateNotice(dto);
		if (res > 0) {
			req.setAttribute("msg", "공지사항이 수정되었습니다.");
		} else {
			req.setAttribute("msg", "수정에 실패하였습니다. 관리자에게 문의바랍니다.");
		}
		req.setAttribute("url", "list_notice.do");
		return "message";

	}

	// 공지사항 삭제
	@RequestMapping(value = { "/delete_noticeOk.do" }, method = RequestMethod.GET)
	public String deleteOkNotice(HttpServletRequest req, @RequestParam("notice_num") int notice_num) {
		int res = adminMapper.deleteNotice(notice_num);
		if (res > 0) {
			req.setAttribute("msg", "공지사항이 삭제되었습니다.");
			req.setAttribute("url", "list_notice.do");
		} else {
			req.setAttribute("msg", "삭제에 실패하였습니다. 관리자에게 문의바랍니다.");
			req.setAttribute("url", "admin_noticont.do?notice_num=" + notice_num);
		}
		return "message";
	}

	// admin_top 고객문의 클릭시 문의 list
	// 페이징 처리
	@RequestMapping(value = { "/customer_qna.do" }, method = RequestMethod.GET)
	public String custom(HttpServletRequest req,
			@RequestParam(value = "pageNum", required = false, defaultValue = "1") int pageNum) {
		int adminQnaCount = adminMapper.adminQnaCount();

		Map<String, Object> row = paginate(adminQnaCount, pageNum);

		List<AdminQnaDTO> list = adminMapper.listAdminQna(row);

		req.setAttribute("startPage", (int) row.get("startPage"));
		req.setAttribute("endPage", (int) row.get("endPage"));
		req.setAttribute("pageCount", (int) row.get("pageCount"));
		req.setAttribute("pageBlock", (int) row.get("pageBlock"));
		req.setAttribute("no", (int) row.get("no"));
		req.setAttribute("listAdminQna", list);

		return "admin/admin_custom";
	}

	// 고객문의 페이지에서 제목 클릭시 form 페이지로 이동
	@RequestMapping(value = { "/custom_noti.do" }, method = RequestMethod.GET)
	public String customerQnaForm(HttpServletRequest req, @RequestParam("adminqna_num") int adminqna_num) {

		AdminQnaDTO dto = adminMapper.getAdminQnaByNum(adminqna_num);
		req.setAttribute("getAdminQnaByNum", dto);
		return "admin/admin_customForm";
	}

	@RequestMapping(value = { "/adminQnaEdit.do" }, method = RequestMethod.POST)
	public String updateOkAdminqna(HttpServletRequest req, @ModelAttribute AdminQnaDTO dto,
			@RequestParam("adminqna_num") int adminqna_num) {
		dto.setAdminqna_status("답변완료");
		int res = adminMapper.updateAdminQna(dto);
		if (res > 0) {
			req.setAttribute("msg", "답변이 등록되었습니다.");
		} else {
			req.setAttribute("msg", "등록에 실패하였습니다. 관리자에게 문의바랍니다.");
		}
		req.setAttribute("url", "custom_noti.do?adminqna_num=" + dto.getAdminqna_num());
		return "message";
	}

	@RequestMapping(value = { "/adminQnaDelete.do" }, method = RequestMethod.POST)
	public String deleteAdminAnswer(HttpServletRequest req, @RequestParam("adminqna_num") int adminqna_num) {
		int res = adminMapper.deleteAdminAnswer(adminqna_num);
		if (res > 0) {
			req.setAttribute("msg", "고객문의 답변이 삭제되었습니다.");
		} else {
			req.setAttribute("msg", "삭제에 실패하였습니다. 관리자에게 문의바랍니다.");
		}
		req.setAttribute("url", "custom_noti.do?adminqna_num=" + adminqna_num);
		return "message";
	}

	// 정산관리
	@RequestMapping(value = { "/settlement_manage.do" }, method = RequestMethod.GET)
	public String settlementManage(HttpServletRequest req) {
		
		// 연도별 초기 데이터
		int totPaycharge_year = 0;
		List<ReservDTO> list_year = new ArrayList<ReservDTO>();
		Map<String, Object> row_year = new HashMap<String, Object>();		
		Map<String, Object> params_year = new HashMap<String, Object>();
		params_year.put("searchYear", "2024");
		
		int pageNum_year = 1;
		int adminAccount = adminMapper.adminAccount(params_year);
		row_year = paginate(adminAccount, pageNum_year);
		params_year.put("startRow", (int) row_year.get("startRow"));
		params_year.put("endRow", (int) row_year.get("endRow"));
		
		list_year = adminMapper.listAccount(params_year);
		totPaycharge_year = adminMapper.totPaychargeYear(params_year);

		req.setAttribute("totPaycharge", totPaycharge_year);
		req.setAttribute("listAccount", list_year);
		req.setAttribute("pageCount", (int) row_year.get("pageCount"));
		req.setAttribute("pageBlock", (int) row_year.get("pageBlock"));
		req.setAttribute("search", "year");
		req.setAttribute("startPage", (int) row_year.get("startPage"));
		req.setAttribute("endPage", (int) row_year.get("endPage"));
		req.setAttribute("searchYear", params_year.get("searchYear"));
		req.setAttribute("no", (int) row_year.get("no"));		
		
		
		// 월별 초기 데이터
		String year_month = "2024";
		int totPaycharge_month = 0;
		List<ReservDTO> list_month = new ArrayList<ReservDTO>();

		list_month = adminMapper.monthAccount(year_month);
		totPaycharge_month = adminMapper.totPaychargeMonth(year_month);

		req.setAttribute("totPaycharge_m", totPaycharge_month);
		req.setAttribute("listAccount_m", list_month);
		
		
		
		return "admin/admin_account";
	}

	@RequestMapping(value = { "/settlement_manage_year.do" }, method = { RequestMethod.GET, RequestMethod.POST })
	public String search_year(HttpServletRequest req, @RequestParam Map<String, Object> params,
			@RequestParam(value = "search", required = false, defaultValue = "year") String search,
			@RequestParam(value = "pageNum", required = false, defaultValue = "1") int pageNum) {

		int totPaycharge = 0;
		List<ReservDTO> list = new ArrayList<ReservDTO>();
		Map<String, Object> row = new HashMap<String, Object>();

		int adminAccount = adminMapper.adminAccount(params);
		row = paginate(adminAccount, pageNum);
		params.put("startRow", (int) row.get("startRow"));
		params.put("endRow", (int) row.get("endRow"));

		list = adminMapper.listAccount(params);

		// 연도별 총 수수료 금액
		totPaycharge = adminMapper.totPaychargeYear(params);

		req.setAttribute("totPaycharge", totPaycharge);
		req.setAttribute("listAccount", list);

		req.setAttribute("pageCount", (int) row.get("pageCount"));
		req.setAttribute("pageBlock", (int) row.get("pageBlock"));
		req.setAttribute("search", search);
		req.setAttribute("startPage", (int) row.get("startPage"));
		req.setAttribute("endPage", (int) row.get("endPage"));
		req.setAttribute("searchYear", params.get("searchYear"));
		req.setAttribute("no", (int) row.get("no"));

		return "admin/admin_account";
	}

	@RequestMapping(value = { "/settlement_manage_period.do" }, method = { RequestMethod.GET, RequestMethod.POST })
	public String search_period(HttpServletRequest req, @RequestParam Map<String, Object> params,
			@RequestParam(value = "search", required = false, defaultValue = "year") String search,
			@RequestParam(value = "pageNum", required = false, defaultValue = "1") int pageNum) {

		int totPaycharge = 0;
		List<ReservDTO> list = new ArrayList<ReservDTO>();
		Map<String, Object> row = new HashMap<String, Object>();

		int periodCount = adminMapper.periodCount(params);
		row = paginate(periodCount, pageNum);
		params.put("startRow", (int) row.get("startRow"));
		params.put("endRow", (int) row.get("endRow"));
		list = adminMapper.periodAccount(params);
		// 기간별 총 수수료 금액
		totPaycharge = adminMapper.totPaycharge(params);

		req.setAttribute("totPaycharge_p", totPaycharge);
		req.setAttribute("listAccount_p", list);
		req.setAttribute("pageCount", (int) row.get("pageCount"));
		req.setAttribute("pageBlock", (int) row.get("pageBlock"));
		req.setAttribute("search", search);
		req.setAttribute("startPage", (int) row.get("startPage"));
		req.setAttribute("endPage", (int) row.get("endPage"));
		req.setAttribute("searchYear", params.get("searchYear"));
		req.setAttribute("startDay", params.get("startDay"));
		req.setAttribute("endDay", params.get("endDay"));
		req.setAttribute("no", (int) row.get("no"));

		return "admin/admin_account";
	}

	// 정산관리_월별
	// --------------------------------------------------------------------------------
	@RequestMapping(value = { "/settlement_manage_month.do" }, method = RequestMethod.POST)
	public String search_month(HttpServletRequest req, @RequestParam Map<String, Object> params,
			@RequestParam(value = "search", required = false, defaultValue = "month") String search,
			String searchYear_m) {

		String year = (String) params.get("searchYear_m");
		int totPaycharge = 0;
		List<ReservDTO> list = new ArrayList<ReservDTO>();

		list = adminMapper.monthAccount(year);
		totPaycharge = adminMapper.totPaychargeMonth(year);

		req.setAttribute("totPaycharge_m", totPaycharge);
		req.setAttribute("listAccount_m", list);
		req.setAttribute("searchYear_m", year);
		return "admin/admin_account";
	}

}