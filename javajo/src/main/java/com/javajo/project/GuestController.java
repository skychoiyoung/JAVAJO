package com.javajo.project;

import java.io.File;
import java.io.IOException;
import java.text.DecimalFormat;
import java.text.SimpleDateFormat;
import java.time.LocalDate;
import java.time.format.DateTimeFormatter;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;


import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.multipart.MultipartHttpServletRequest;

import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.javajo.project.dto.AdminQnaDTO;
import com.javajo.project.dto.FacDTO;
import com.javajo.project.dto.HostQnaDTO;
import com.javajo.project.dto.HouseDTO;
import com.javajo.project.dto.NoticeDTO;
import com.javajo.project.dto.ReservDTO;
import com.javajo.project.dto.ReviewDTO;
import com.javajo.project.dto.ThemeDTO;
import com.javajo.project.dto.UserDTO;
import com.javajo.project.dto.WishListDTO;
import com.javajo.project.service.GuestMapper;

@Controller
public class GuestController {
	
	@Autowired
	GuestMapper mapper;

	@ResponseBody
	@RequestMapping("/guest_index.ajax")
	public ResponseEntity<Map<String, Object>> guestIndexSort(HttpServletRequest req, 
			@RequestParam(value = "sort", required = false, defaultValue = "score") String sort,
			@RequestParam(value = "selectedTab", required = false, defaultValue = "htheme01") String select) {
		List<ThemeDTO> list = mapper.listTheme();
		
		Map<String, List<HouseDTO>> housesByTheme = new HashMap<>();
		for (ThemeDTO theme : list) {
			if(theme.getHtheme().equals("htheme01") && select.equals("htheme01")) {
				List<HouseDTO> listHouse = mapper.listHouse(sort);
				housesByTheme.put("htheme01", listHouse);
			}else {
				List<HouseDTO> listHousebyTheme = mapper.listHousebyTheme(theme.getHtheme(), sort);
		        housesByTheme.put(theme.getHtheme(), listHousebyTheme);
			}		        
	    }
		
		// 로그인 아이디
		HttpSession session = req.getSession();
		UserDTO dto = (UserDTO)session.getAttribute("inUser");		
		String user_id = dto.getUser_id();	
				
		// 위시리스트
		List<WishListDTO> wishList = mapper.getWishList(user_id);
		
		// 게스트선호 리스트
		List<HouseDTO> guestPreferList = mapper.guestPreferList();
		
		Map<String, Object> response = new HashMap<>();
	    response.put("housesByTheme", housesByTheme);
	    response.put("sort", sort);
	    response.put("selectedTab", select);
	    response.put("wishList", wishList);
	    response.put("guestPreferList", guestPreferList);
	    
	    return ResponseEntity.ok(response);
	}
	
	// 게스트 - 메인 페이지
	@RequestMapping("/guest_index.do") 
	public String guestIndex(HttpServletRequest req, 
			@RequestParam(value = "sort", required = false, defaultValue = "score") String sort){

		// 테마 아이콘
		List<ThemeDTO> list = mapper.listTheme();
		req.setAttribute("listTheme", list);			

		// 테마별 숙소 리스트 (정렬 적용)
		Map<String, List<HouseDTO>> housesByTheme = new HashMap<>();
		for (ThemeDTO theme : list) {
			if(theme.getHtheme().equals("htheme01")) {
				List<HouseDTO> listHouse = mapper.listHouse(sort);
				housesByTheme.put("htheme01", listHouse);
			}else {
				List<HouseDTO> listHousebyTheme = mapper.listHousebyTheme(theme.getHtheme(), sort);
		        housesByTheme.put(theme.getHtheme(), listHousebyTheme);
			}		        
	    }
		
		// 로그인 아이디
		HttpSession session = req.getSession();
		UserDTO dto = (UserDTO)session.getAttribute("inUser");		
		String user_id = dto.getUser_id();	
		
		// 위시리스트
		List<WishListDTO> wishList = mapper.getWishList(user_id);
		
		// 게스트선호 리스트
		List<HouseDTO> guestPreferList = mapper.guestPreferList();
		
		req.setAttribute("housesByTheme", housesByTheme);
		req.setAttribute("sort", sort);
		req.setAttribute("user_id", user_id);
		req.setAttribute("wishList", wishList);
		req.setAttribute("guestPreferList", guestPreferList);
		
		return "guest/guest_index";
	}
	
	
	// 메인 - 위시리스트 추가
	@PostMapping("/addWish.ajax")
	@ResponseBody
	public ResponseEntity<String> addWish(@RequestBody WishListDTO dto) {
	    try {
	        int res = mapper.addToWishlist(dto);
	        if (res > 0) {
	            return ResponseEntity.ok("찜리스트 등록 완료");
	        } else {
	            return ResponseEntity.ok("찜리스트 등록 실패");
	        }
	    } catch (Exception e) {
	        e.printStackTrace();
	        return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).build();
	    }
	}

	// 메인 - 위시리스트 삭제
	@ResponseBody
	@DeleteMapping("/delWish.ajax")
	public ResponseEntity<String> delWish(@RequestBody WishListDTO dto) {
	    try {
	        mapper.removeFromWishlist(dto);
	        return ResponseEntity.ok("찜리스트에서 삭제되었습니다.");
	    } catch (Exception e) {
	        return ResponseEntity.badRequest().body("찜리스트 삭제에 실패했습니다.");
	    }
	}

	@ResponseBody
	@PostMapping("/housePriceCal.ajax")
	public Map<String, Object> housePriceCal(HttpServletRequest req, @RequestBody Map<String, Object> request) {
		String checkinDate = (String) request.get("checkinDate");
        String checkoutDate = (String) request.get("checkoutDate");
        int countStay = Integer.parseInt(request.get("stayCount").toString());
        double housePrice = Double.parseDouble(request.get("housePrice").toString());
        double housePriceCal = 0.0;
        double sumHousePriceCal = 0.0;

        DateTimeFormatter formatter = DateTimeFormatter.ofPattern("yyyy-MM-dd");
        LocalDate startDate = LocalDate.parse(checkinDate, formatter);

        for (int i = 0; i < countStay; i++) {
            LocalDate currentDate = startDate.plusDays(i);
            int year = currentDate.getYear();
            String month = currentDate.getMonth().toString();
            String dayOfWeek = currentDate.getDayOfWeek().toString();

            // 계산
            if ((month.equals("JULY") || month.equals("AUGUST")) && (dayOfWeek.equals("SATURDAY") || dayOfWeek.equals("SUNDAY"))) {
                housePriceCal = housePrice * 3;
                System.out.println("성수기+주말 : " + housePriceCal);
            } else if (month.equals("JULY") || month.equals("AUGUST")) {
                housePriceCal = housePrice * 2;
                System.out.println("성수기 : " + housePriceCal);
            } else if (dayOfWeek.equals("SATURDAY") || dayOfWeek.equals("SUNDAY")) {
                housePriceCal = housePrice * 1.5;
                System.out.println("비성수기 주말 : " + housePriceCal);
            } else {
                housePriceCal = housePrice;
                System.out.println("비성수기 평일: " + housePriceCal);
            }
            sumHousePriceCal += housePriceCal;
        }
        
        // 포맷팅 하기 전 값
        int housePricebyCal = (int)(sumHousePriceCal / countStay);
        int stayPrice = (int)(housePricebyCal * countStay);
        int javajoVat = (int)(stayPrice * 0.1);
        int totalPrice = (int)(stayPrice + javajoVat);
        
        // 포맷팅된 값
        DecimalFormat df = new DecimalFormat("###,###");
        String fmHousePricebyCal = df.format(housePricebyCal);
        String fmStayPrice = df.format(stayPrice);
        String fmJavajoVat = df.format(javajoVat);
        String fmTotalPrice = df.format(totalPrice);        
        
        Map<String, Object> response = new HashMap<>();
        // 포맷팅 안한 값 (reserve_detail.do에서 사용되는 파라미터)
        response.put("stayPrice", stayPrice);
        response.put("javajoVat", javajoVat);
        response.put("totalPrice", totalPrice);
        
        // 포맷팅한 값(house_info.do에서 화면에 표현되는 값)
        response.put("avgPricefm", fmHousePricebyCal);
        response.put("stayPricefm", fmStayPrice);
        response.put("javajoVatfm", fmJavajoVat);
        response.put("totalPricefm", fmTotalPrice);

        return response;
	
	}
	
	// top 검색
	@RequestMapping("/guest_search.do")
	public String guestsearch(HttpServletRequest req, @RequestParam Map<String, Object> params) {
	
		// sort 파라미터가 비어있거나 null인 경우에 기본값 "score" 설정
	    if (params.get("sort") == null || params.get("sort").toString().isEmpty()) {
	        params.put("sort", "score");
	    }
	    
	    List<HouseDTO> availableListHouse = null;
	       
	    if (params.get("build_type") == null || params.get("build_type") == ""){
	    	if(params.get("area").toString().isEmpty() && params.get("checkin").toString().isEmpty() && params.get("checkout").toString().isEmpty()) {
	    		availableListHouse = mapper.getAvailableHouse1(params);   	
		    } else if(params.get("area").toString().isEmpty()) {
		    	availableListHouse = mapper.getAvailableHouse2(params);
		    } else if(params.get("checkin").toString().isEmpty() && params.get("checkout").toString().isEmpty()) {
		    	availableListHouse = mapper.getAvailableHouse3(params);
		    } else {
		    	availableListHouse = mapper.getAvailableHouse4(params);
		    } 
	    } else {
	    	if(params.get("area").toString().isEmpty() && params.get("checkin").toString().isEmpty() && params.get("checkout").toString().isEmpty()) {
		    	availableListHouse = mapper.getAvailableHouse5(params);
		    } else if(params.get("area").toString().isEmpty()) {
		    	availableListHouse = mapper.getAvailableHouse6(params);
		    } else if(params.get("checkin").toString().isEmpty() && params.get("checkout").toString().isEmpty()) {
		    	availableListHouse = mapper.getAvailableHouse7(params);
		    } else {
		    	availableListHouse = mapper.getAvailableHouse8(params);
		    }
	    }	 
	    
	    // 로그인 아이디
 		HttpSession session = req.getSession();
 		UserDTO dto = (UserDTO)session.getAttribute("inUser");		
 		String user_id = dto.getUser_id();	
	 		
 		// 위시리스트
 		List<WishListDTO> wishList = mapper.getWishList(user_id);
 		
 		// 게스트선호 리스트
 		List<HouseDTO> guestPreferList = mapper.guestPreferList();
		
		req.setAttribute("searchParams", params);
		req.setAttribute("searchResult", availableListHouse);
		req.setAttribute("searchResultCnt", availableListHouse.size());
		req.setAttribute("wishList", wishList);
		req.setAttribute("guestPreferList", guestPreferList);
		return "guest/guest_search";
	}
	
	// 예약내역 페이지
	@RequestMapping("/reserve_list.do")
    public String reserveAll(HttpServletRequest req, ReservDTO dto, @RequestParam(defaultValue = "1") int pageNum) {
        HttpSession session = req.getSession();
        UserDTO udto = (UserDTO) session.getAttribute("inUser");
        String user_id = udto.getUser_id(); 

        // 상태 업데이트(modified by 민영)
        System.out.println("try 전");
        try {
        	System.out.println("try 들어옴");
        	int res1 = mapper.checkinCheck(user_id);
            System.out.println("결제완료 상태 이용중으로 변경 완료");
    		int res2 = mapper.checkinUpdate(user_id);
    		System.out.println("이용중 상태 이용완료로 변경 완료 체크 완료");
    		int res3 = mapper.checkoutCheck(user_id);
    		System.out.println("이용완료 체크 완료");
        } catch(Exception e){
        	e.printStackTrace();
        }
        
        // 해당 아이디 전체 예약내역 수
 		int totalReserv = mapper.countReserv(user_id);
 		int pageSize = 5;
 		int startRow = ((pageNum - 1) * pageSize) +1; // 페이지별로 시작 넘버
 		int endRow = startRow + pageSize - 1; // 페이지별로 끝 넘버
 		if (endRow > totalReserv)
 			endRow = totalReserv;
 		int no = totalReserv-startRow+1;
 		int pageBlock = 3;
 		int pageCount = totalReserv / pageSize + (totalReserv % pageSize == 0 ? 0 : 1);
 		int startPage = (pageNum - 1) / pageBlock * pageBlock + 1;
 		int endPage = startPage + pageBlock - 1;
 		if (endPage > pageCount) endPage = pageCount;
        
 		Map<String, Object> params = new HashMap<>();
 	    params.put("user_id", user_id);
 	    params.put("startRow", startRow);
 	    params.put("endRow", endRow);
 	    
        List<ReservDTO> reserveList = mapper.reserveAll(params);        
        req.setAttribute("pageCount", pageCount);
		req.setAttribute("totalReserv", totalReserv);
		req.setAttribute("pageSize", pageSize);
		req.setAttribute("pageBlock", pageBlock);
		req.setAttribute("startPage", startPage);
		req.setAttribute("endPage", endPage);
		req.setAttribute("reserveList", reserveList);
		req.setAttribute("currentPage", pageNum);
		
		System.out.println("totalReserv :" + totalReserv);
		System.out.println("pageSize :" + pageSize);
		System.out.println("startRow :" + startRow);
		System.out.println("endRow :" + endRow);
		System.out.println("pageBlock :" + pageBlock);
		System.out.println("pageCount :" + pageCount);     
		System.out.println("startPage :" + startPage);
		System.out.println("endPage :" + endPage);
		System.out.println("currentPage :" + pageNum);

		
        return "guest/reserve_list";
    }
	
	// 예약내역 페이지 - 예약취소
	@PostMapping("/updateReserveStatus.ajax")
	@ResponseBody
	public ResponseEntity<String> updateReserveStatus(HttpServletRequest req, @RequestBody ReservDTO dto) {
        HttpSession session = req.getSession();
        UserDTO udto = (UserDTO) session.getAttribute("inUser");
        String user_id = udto.getUser_id();
        
        try {
			int res = mapper.updateReserveStatus(dto);
			HttpHeaders headers = new HttpHeaders();
		    headers.add("Content-Type", "text/plain; charset=UTF-8");
	        if (res > 0) {
	        	return ResponseEntity.ok().headers(headers).body("숙소 예약이 취소되었습니다.");
	        } else {
	            return ResponseEntity.ok().headers(headers).body("숙소 예약 취소에 실패하였습니다. 관리자에게 문의 바랍니다.");
	        }
	    } catch (Exception e) {
	        e.printStackTrace();
	        return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).build();
	    }
	}
	
	// 예약내역 페이지 - 리뷰등록
	@PostMapping("/insertReview.ajax")
	@ResponseBody
	public ResponseEntity<String> ReviewInsert(HttpServletRequest req,
	        @RequestParam int house_num, @RequestParam int review_score,
	        @RequestParam String review_content, @RequestParam int reserv_num)
	        throws IllegalStateException, IOException {
	    HttpSession session = req.getSession();
	    UserDTO udto = (UserDTO) session.getAttribute("inUser");
	    String user_id = udto.getUser_id();

	    MultipartHttpServletRequest mr = (MultipartHttpServletRequest) req;
	    MultipartFile mf = mr.getFile("review_image");

	    boolean hasFile = (mf != null && !mf.isEmpty());

	    // 파일명 중복방지 추가
 		Calendar cal = Calendar.getInstance()  ;
 		SimpleDateFormat timeForamt = new SimpleDateFormat("yyMMddhhmmss");
 		String serial = timeForamt.format(cal.getTime());		

 		String originFileName = null;
 		String saveFileName = null;	    
	    
	    if (hasFile) {
	    	originFileName = mf.getOriginalFilename();
	    	saveFileName = serial + originFileName;
	        String path = "C:/Users/SAMSUNG/Desktop/FINTECH/project2/javajo/src/main/webapp/resources/upload_guestReview";
	        File file = new File(path, saveFileName);
	        mf.transferTo(file);
	    }

	    ReviewDTO rev = new ReviewDTO();
	    rev.setUser_id(user_id);
	    rev.setHouse_num(house_num);
	    rev.setReview_score(review_score);
	    rev.setReview_content(review_content);
	    rev.setReserv_num(reserv_num);

	    if (hasFile) {
	        rev.setReview_image(saveFileName);
	    }

	    int res;
	    if (hasFile) {
	        res = mapper.insertImgReview(rev); // 이미지 첨부 리뷰
	    } else {
	        res = mapper.insertReview(rev); // 이미지 미첨부 리뷰
	    }

	    if (res > 0) {
	        // 리뷰 등록 성공 시 리뷰 상태 업데이트
	        ReviewDTO upReview = new ReviewDTO();
	        upReview.setHouse_num(house_num);
	        upReview.setUser_id(user_id);

	        int updateRev = mapper.updateReviewStatus(upReview);

	        HttpHeaders headers = new HttpHeaders();
	        headers.add("Content-Type", "text/plain; charset=UTF-8");

	        if (updateRev > 0) {
	            return ResponseEntity.ok().headers(headers).body("리뷰 등록 및 상태 업데이트가 완료되었습니다.");
	        } else {
	            return ResponseEntity.ok().headers(headers).body("리뷰 등록은 성공하였으나, 상태 업데이트에 실패하였습니다.");
	        }
	    } else {
	        return ResponseEntity.ok().body("리뷰 등록에 실패하였습니다. 관리자에게 문의 바랍니다.");
	    }
	}
	
	// 위시리스트 메뉴 - 위시리스트 조회
	@RequestMapping("/wish_list.do")
	public String wishList(HttpServletRequest req) {
		HttpSession session = req.getSession();
		UserDTO dto = (UserDTO)session.getAttribute("inUser");
		if (dto == null) {	        
	        return "redirect:/login";
	    }
		String user_id = dto.getUser_id();	
		List<WishListDTO> wishList = mapper.getWishList(user_id);
		
		req.setAttribute("wishList", wishList);
		return "guest/guest_wish";
	}
	
	// 위시리스트 메뉴 - 위시리스트 해제
	@RequestMapping("/wish_del.do")
	public String wishDel(HttpServletRequest req, int house_num) {
		HttpSession session = req.getSession();
		UserDTO dto = (UserDTO)session.getAttribute("inUser");		
		String user_id = dto.getUser_id();
		Map<String, Object> params = new HashMap<>();
		params.put("user_id", user_id);
		params.put("house_num", house_num);
		int res = mapper.delWishList(params);
		if (res > 0) {
			req.setAttribute("msg", "위시리스트에서 해제되었습니다.");
			req.setAttribute("url", "wish_list.do");
			return "message";
		} else {
			req.setAttribute("msg", "위시리스트 해제 도중 에러 발생. 관리자에게 문의 바랍니다.");
			req.setAttribute("url", "wish_list.do");
			return "message";
		}
	}
	// 숙소상세 페이지 - 숙소 예약
	@ResponseBody
	@RequestMapping(value = "/insertReserve.ajax", method = RequestMethod.POST)
	public ResponseEntity<Map<String, String>> insertReserve(HttpServletRequest req, @RequestBody ReservDTO dto) {
	    HttpSession session = req.getSession();
	    UserDTO udto = (UserDTO) session.getAttribute("inUser");
	    if (udto == null) {
	        return ResponseEntity.status(HttpStatus.UNAUTHORIZED).build();
	    }	    
	    dto.setUser_id(udto.getUser_id());
	    Map<String, String> response = new HashMap<>();
	    HttpHeaders headers = new HttpHeaders();
	    headers.add("Content-Type", "application/json; charset=UTF-8");
	       
	    try {
	        int res = mapper.insertReserve(dto);
	        if (res > 0) {
	            response.put("status", "success");
	            response.put("message", "숙소 예약이 완료되었습니다.");
	            return ResponseEntity.ok().headers(headers).body(response);
	        } else {
	            response.put("status", "error");
	            response.put("message", "숙소 예약에 실패하였습니다. 관리자에게 문의 바랍니다.");
	            return ResponseEntity.ok().headers(headers).body(response);
	        }
	    } catch (Exception e) {
	        e.printStackTrace();
	        response.put("status", "error");
	        response.put("message", "서버 오류가 발생했습니다.");
	        return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).headers(headers).body(response);
	    }
	}
	
	// 고객문의 메뉴 - 조회
	@RequestMapping("/qna_list.do") 
	public String qnaList(HttpServletRequest req, 
			@RequestParam(value = "pageNum", required = false, defaultValue = "1") int pageNum) {
		HttpSession session = req.getSession();
		UserDTO dto = (UserDTO)session.getAttribute("inUser");		
		String user_id = dto.getUser_id();
		
		// 고객문의 게시글 수
		int adminQnaCount = mapper.getAdminQnaCount(user_id);		
		// 한 페이지에 보여질 게시글 수
		int pageSize = 10;
		// 페이지 넘버
		int startRow = (pageNum-1) * pageSize + 1; // 페이지별로 시작 넘버
		int endRow = startRow + pageSize - 1; // 페이지별로 끝 넘버		
		if (endRow > adminQnaCount) endRow = adminQnaCount;		
		// 화면에 보여질 번호
		int no = adminQnaCount-startRow + 1;				
		// 페이징번호 보여줄 [1][2][3] 최대 갯수
		int pageBlock = 3; 		
		// 총 페이징 번호 갯수
		int pageCount = adminQnaCount/pageSize + (adminQnaCount%pageSize == 0 ? 0 : 1);		
		// 페이징 시작 번호 [1], [4], [7]...
		int startPage = (pageNum-1)/pageBlock * pageBlock +1;		
		// 페이징 끝 번호 [3], [6], [9]...
		int endPage = startPage + pageBlock -1;		
		if(endPage > pageCount) endPage = pageCount;			
		
		Map<String, Object> params = new HashMap<>();
		params.put("user_id", user_id);
		params.put("startRow", startRow);
		params.put("endRow", endRow);		
		
		List<AdminQnaDTO> qnaList = mapper.getQnaList(params);		
		
		req.setAttribute("adminQnaCount", adminQnaCount);
		req.setAttribute("pageSize", pageSize);
		req.setAttribute("no", no);
		req.setAttribute("pageBlock", pageBlock);
		req.setAttribute("startPage", startPage);
		req.setAttribute("endPage", endPage);
		req.setAttribute("qnaList", qnaList);
		req.setAttribute("pageCount", pageCount);
			
		return "guest/guest_qna";
	}
	
	// 고객문의 메뉴 - 문의 등록
	@RequestMapping("/qna_insert.do") 
	public String qnaInsert(HttpServletRequest req, String adminqna_type, String adminqna_title, String adminqna_gcontent) throws IOException {
		HttpSession session = req.getSession();
		UserDTO dto = (UserDTO)session.getAttribute("inUser");		
		String user_id = dto.getUser_id();		
		
		MultipartHttpServletRequest mr = (MultipartHttpServletRequest)req;
		MultipartFile mf = mr.getFile("file");
		
		boolean hasFile = (mf != null && !mf.isEmpty());		
		
		// 파일명 중복방지 추가 - 민영
		Calendar cal = Calendar.getInstance()  ;
		SimpleDateFormat timeForamt = new SimpleDateFormat("yyMMddhhmmss");
		String serial = timeForamt.format(cal.getTime());		

		String originFileName = null;
		String saveFileName = null;
		
	    if (hasFile) {
	    	originFileName = mf.getOriginalFilename();
	    	saveFileName = serial + originFileName;
	        String path = "C:/Users/SAMSUNG/Desktop/FINTECH/project2/javajo/src/main/webapp/resources/upload_adminQna";
	        File file = new File(path, saveFileName);
	        mf.transferTo(file);
	    }
		
		String type = null;
		if(adminqna_type.equals("site")) {
			type = "사이트 이용문의";
		}else if(adminqna_type.equals("house")) {
			type = "숙소 이용문의";
		}else if(adminqna_type.equals("refund")) {
			type = "환불 문의";
		}else {
			type = "기타";
		}
		
		String status = "답변대기";
		
		AdminQnaDTO qdto = new AdminQnaDTO();
		qdto.setAdminqna_type(type);
		qdto.setAdminqna_title(adminqna_title);
		qdto.setUser_id(user_id);
		qdto.setAdminqna_gcontent(adminqna_gcontent);
		qdto.setAdminqna_status(status);
		if (hasFile) {
	        qdto.setAdminqna_image(saveFileName);
	    }
		
		int res;
		if (hasFile) {
	        res = mapper.insertAdminQnaF(qdto);
	    } else {
	        res = mapper.insertAdminQnaNF(qdto);
	    }
	
		if (res > 0) {
			req.setAttribute("msg", "고객문의 게시판에 글이 등록되었습니다.");
			req.setAttribute("url", "qna_list.do");
			return "message";
		} else {
			req.setAttribute("msg", "고객문의 게시글 등록 중 에러 발생. 관리자에게 문의 바랍니다.");
			req.setAttribute("url", "qna_list.do");
			return "message";
		}
		
	}
	
	// 고객문의 메뉴 - 문의 상세
	@RequestMapping("/qna_cont.do") 
	public String qnaCont(HttpServletRequest req, int adminqna_num) {
		List<AdminQnaDTO> qnaContList = mapper.getQnaCont(adminqna_num);
		req.setAttribute("qnaContList", qnaContList);		
		return "guest/guest_qna_cont";
	}
	
	// 고객문의 메뉴 - 문의 상세 - 삭제
	@RequestMapping("/qna_del.do")
	public String delAdminQna(HttpServletRequest req, int adminqna_num) {
		int res = mapper.delAdminQna(adminqna_num);
		if (res > 0) {
			req.setAttribute("msg", "등록하신 문의글이 삭제되었습니다.");
			req.setAttribute("url", "qna_list.do");
			return "message";
		} else {
			req.setAttribute("msg", "문의글 삭제 도중 에러 발생. 관리자에게 문의 바랍니다.");
			req.setAttribute("url", "qna_list.do");
			return "message";
		}
	}
	
	
	// 공지사항 메뉴
	@RequestMapping("/notice.do")
	public String noticeIndex(HttpServletRequest req, 
			@RequestParam(value = "pageNum", required = false, defaultValue = "1") int pageNum) {
		// 공지사항 게시글 수
		int noticeCount = mapper.getNoticeCount();		
		// 한 페이지에 보여질 게시글 수
		int pageSize = 10;
		// 페이지 넘버
		int startRow = (pageNum-1) * pageSize + 1; // 페이지별로 시작 넘버
		int endRow = startRow + pageSize - 1; // 페이지별로 끝 넘버		
		if (endRow > noticeCount) endRow = noticeCount;		
		// 화면에 보여질 번호
		int no = noticeCount-startRow + 1;				
		// 페이징번호 보여줄 [1][2][3] 최대 갯수
		int pageBlock = 3; 		
		// 총 페이징 번호 갯수
		int pageCount = noticeCount/pageSize + (noticeCount%pageSize == 0 ? 0 : 1);		
		// 페이징 시작 번호 [1], [4], [7]...
		int startPage = (pageNum-1)/pageBlock * pageBlock +1;		
		// 페이징 끝 번호 [3], [6], [9]...
		int endPage = startPage + pageBlock -1;		
		if(endPage > pageCount) endPage = pageCount;				
		
		Map<String, Object> params = new HashMap<>();
		params.put("startRow", startRow);
		params.put("endRow", endRow);
		
		List<NoticeDTO> noticeList = mapper.getNotice(params);		
		
		req.setAttribute("noticeCount", noticeCount);
		req.setAttribute("pageSize", pageSize);
		req.setAttribute("no", no);
		req.setAttribute("pageBlock", pageBlock);
		req.setAttribute("startPage", startPage);
		req.setAttribute("endPage", endPage);
		req.setAttribute("noticeList", noticeList);
		req.setAttribute("pageCount", pageCount);
		return "guest/guest_notice";
	}
	
	// 공지사항 메뉴 - 공지 상세
	@RequestMapping("/notice_cont.do")
	public String noticeContent(HttpServletRequest req, int notice_num) {
		NoticeDTO dto = mapper.getNoticeCont(notice_num);
		req.setAttribute("getNoticeCont", dto);
		return "guest/guest_notice_cont";
	}
	
	// S : 작업 영역
	// S : 숙소상세 페이지
	@RequestMapping("/house_info.do")
	public String getHouseInfo(HttpServletRequest req, @RequestParam int house_num, 
				@RequestParam(value = "pageNum", required = false, defaultValue = "1") int pageNum) {
		HttpSession session = req.getSession();
		UserDTO udto = (UserDTO)session.getAttribute("inUser");		
		String user_id = udto.getUser_id();
        
		// 숙소 정보, 리뷰 정보, 위시리스트를 한 번에 조회
        HouseDTO houseDTO = mapper.getHouseByNum(house_num);
        List<ReviewDTO> reviews = mapper.listReview(house_num);
        List<WishListDTO> wishList = mapper.getWishList(user_id);
        // 예약되어있는 날짜 뽑아오기
        // 숙소상세 페이지 - 해당 숙소의 예약된 날짜 리스트 뽑아오기
        List<ReservDTO> reservList = mapper.getReservList(house_num);         
        ArrayList reservDate = new ArrayList<>();
        DateTimeFormatter formatter = DateTimeFormatter.ofPattern("yyyy-MM-dd");
        
        for(int i=0; i<reservList.size(); i++) {
        	String checkinDateTime = reservList.get(i).getReserv_checkin(); // 2024-07-01 00:00:00
            String checkoutDateTime = reservList.get(i).getReserv_checkout(); // 2024-07-03 00:00:00                
            String checkinDate = checkinDateTime.split(" ")[0]; // 2024-07-01
            String checkoutDate = checkoutDateTime.split(" ")[0];  // 2024-07-03

            // 문자열을 LocalDate로 변환
            LocalDate checkinDateLocal = LocalDate.parse(checkinDate, formatter);
            LocalDate checkoutDateLocal = LocalDate.parse(checkoutDate, formatter);
            for (LocalDate date = checkinDateLocal; !date.isAfter(checkoutDateLocal); date = date.plusDays(1)) {
                reservDate.add(date.toString());
            }            
        }
        
        for(int j=0; j<reservDate.size(); j++) {
        	System.out.println(reservDate.get(j));
        }
        
    	// reservDate를 JSON 형식으로 변환하여 전달
        ObjectMapper objectMapper = new ObjectMapper();
        String jsonReservDate = "";
        try {
            jsonReservDate = objectMapper.writeValueAsString(reservDate);
        } catch (JsonProcessingException e) {
            e.printStackTrace();
        }
        
        
        String[] facArray = houseDTO.getHouse_fac().split(",");
        String[] themeArray = houseDTO.getHouse_theme().split(",");
        
        List<FacDTO> facList = new ArrayList<>(); 
        List<ThemeDTO> themeList = new ArrayList<>(); 
        
        for(String t : themeArray) {
        	ThemeDTO tdto = mapper.getTheme(t);
        	themeList.add(tdto);
        }
        
        for(String f : facArray) {
           FacDTO fdto = mapper.getFac(f);
           facList.add(fdto);
        }
        
        if (reviews == null) {
            reviews = new ArrayList<>();
        }
        
        // 숙박요금 계산
 		double price = 0.0;
 		
 		// Calendar 객체를 사용하여 특정 날짜 설정
        //Calendar calendar = Calendar.getInstance();
        //calendar.set(2024, Calendar.JULY, 6);

        // Calendar 객체에서 Date 객체 생성
        //Date date = calendar.getTime();
        Date date = new Date(); // 오늘 날짜로 할 때
		SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd"); // 연월일
		SimpleDateFormat monthFormat = new SimpleDateFormat("MMMM"); // 월
		SimpleDateFormat dayFormat = new SimpleDateFormat("EEEE"); // 요일
		String todayDate = dateFormat.format(date);
		String todayDay = dayFormat.format(date);
		String todayMonth = monthFormat.format(date);
		 
		if((todayMonth.equals("7월") || todayMonth.equals("8월")) && (todayDay.equals("토요일") || todayDay.equals("일요일"))) {
			price = houseDTO.getHouse_price() * 3;
		} else if (todayMonth.equals("7월") || todayMonth.equals("8월")) {
			price = houseDTO.getHouse_price() * 2;
		} else if (todayDay.equals("토요일") || todayDay.equals("일요일")) {
			price = houseDTO.getHouse_price() * 1.5;
		} else {
			price = houseDTO.getHouse_price();
		}
        
        // 호스트QNA 페이징처리
    	// 호스트QNA 총 게시글 수
 		int hostQnaCount = mapper.getHostQnaCount(house_num);	
 		// 한 페이지에 보여질 게시글 수
 		int pageSize = 5;
 		// 페이지 넘버
 		int startRow = (pageNum-1) * pageSize + 1; // 페이지별로 시작 넘버
 		int endRow = startRow + pageSize - 1; // 페이지별로 끝 넘버		
 		if (endRow > hostQnaCount) endRow = hostQnaCount;		
 		// 화면에 보여질 번호
 		int no = hostQnaCount-startRow + 1;				
 		// 페이징번호 보여줄 [1][2][3] 최대 갯수
 		int pageBlock = 3; 		
 		// 총 페이징 번호 갯수
 		int pageCount = hostQnaCount/pageSize + (hostQnaCount%pageSize == 0 ? 0 : 1);		
 		// 페이징 시작 번호 [1], [4], [7]...
 		int startPage = (pageNum-1)/pageBlock * pageBlock +1;		
 		// 페이징 끝 번호 [3], [6], [9]...
 		int endPage = startPage + pageBlock -1;		
 		if(endPage > pageCount) endPage = pageCount;	
 		
 		Map<String, Object> params = new HashMap<>();
		params.put("startRow", startRow);
		params.put("endRow", endRow);
		params.put("house_num", house_num);
        List<HostQnaDTO> qnaList = mapper.listQna(params);
        
        req.setAttribute("getHouseByNum", houseDTO);
        req.setAttribute("listReview", reviews);
        req.setAttribute("facList", facList);
        req.setAttribute("themeList", themeList);
        req.setAttribute("wishList", wishList);
        req.setAttribute("housePrice", price);
        
        // 호스트QNA 페이징
        req.setAttribute("hostQnaCount", hostQnaCount);
		req.setAttribute("pageSize", pageSize);
		req.setAttribute("no", no);
		req.setAttribute("pageBlock", pageBlock);
		req.setAttribute("startPage", startPage);
		req.setAttribute("endPage", endPage);
		req.setAttribute("listQna", qnaList);
		// 예약되어있는 날짜
		req.setAttribute("reservDate", jsonReservDate);

        return "guest/house_info";
    }
	
	// 예약 상세 페이지로 넘어갈 때 임의 데이터 만들어서 전달
	@RequestMapping("/reserve_detail.do")
	public String reserveInfo(HttpServletRequest req, @RequestParam int house_num,
			@RequestParam String house_name, @RequestParam String house_addr,
			@RequestParam String checkinDate, @RequestParam String checkoutDate,
			@RequestParam String house_checkin, @RequestParam String house_checkout,
            @RequestParam int stayPer, @RequestParam int stayPrice,
            @RequestParam int javajoVat, @RequestParam int totalPrice) {		
		
		HttpSession session = req.getSession();
		UserDTO udto = (UserDTO)session.getAttribute("inUser");
		String user_id = udto.getUser_id();		
		String checkIn = checkinDate + " " + house_checkin;
		String checkOut = checkoutDate + " " + house_checkout;	
		
		// 데이터를 HashMap에 담기
        HashMap<String, Object> reserveInfoMap = new HashMap<>();
        reserveInfoMap.put("house_num", house_num);
        reserveInfoMap.put("house_name", house_name);
        reserveInfoMap.put("house_addr", house_addr);
        reserveInfoMap.put("reserv_checkin", checkIn);
        reserveInfoMap.put("reserv_checkout", checkOut);
        reserveInfoMap.put("reserv_person", stayPer);
        reserveInfoMap.put("reserv_pay", stayPrice);
        reserveInfoMap.put("reserv_paycharge", javajoVat);
        reserveInfoMap.put("reserv_totpay", totalPrice);

        // HttpServletRequest에 HashMap 저장
        req.setAttribute("reserveInfo", reserveInfoMap);
		
		return "guest/reserve_pay";
	}
	
	@RequestMapping("/insertQna.do")
    public String insertQna(HttpServletRequest req,
                            @RequestParam("userId") String userId,
                            @RequestParam("insertNum") int houseNum,
                            @RequestParam("hostqna_title") String hostqnaTitle,
                            @RequestParam("hostqna_gcontent") String hostqnaGcontent) {
        HostQnaDTO dto = new HostQnaDTO();
        dto.setUser_id(userId);
        dto.setHouse_num(houseNum);
        dto.setHostqna_title(hostqnaTitle);
        dto.setHostqna_gcontent(hostqnaGcontent);
        dto.setHostqna_status("답변대기");

        int res = mapper.insertQna(dto);
        if (res > 0) {
            req.setAttribute("msg", "문의글이 등록되었습니다.");
        } else {
            req.setAttribute("msg", "문의글 등록에 실패하였습니다. 관리자에게 문의 바랍니다.");
        }
        req.setAttribute("url", "house_info.do?house_num=" + houseNum);
        return "message";
    }
	@RequestMapping("/del_qna.do")
	public String delQna(HttpServletRequest req, @RequestParam int hostqna_num, @RequestParam int house_num) {
	    try {
	        int res = mapper.delQna(hostqna_num);
	        if (res > 0) {
	            req.setAttribute("msg", "등록하신 문의글을 삭제하였습니다.");
	        } else {
	            req.setAttribute("msg", "등록하신 문의글 삭제를 실패하였습니다.");
	        }
	    } catch (Exception e) {
	        e.printStackTrace();
	        req.setAttribute("msg", "등록에 실패하였습니다. 관리자에게 문의해주세요.");
	    }
	    req.setAttribute("url", "house_info.do?house_num=" + house_num);
	    return "message";
	}
	@GetMapping("/review_all.do")
	public String reviewAll(HttpServletRequest req, @RequestParam int house_num, @RequestParam(defaultValue = "1") int page) {
	    HttpSession session = req.getSession();
	    UserDTO udto = (UserDTO) session.getAttribute("inUser");
	    String user_id = udto.getUser_id();

	    int rowsPerPage = 5;
	    int pagesToShow = 3;
	    int startRow = (page - 1) * rowsPerPage;
	    int endRow = page * rowsPerPage;

	    // 전체 리뷰 수를 가져와서 총 페이지 수를 계산
	    int totalReviews = mapper.countReviews(house_num);
	    int totalPages = (int) Math.ceil((double) totalReviews / rowsPerPage);

	    // 페이지 범위를 계산
	    int startPage = ((page - 1) / pagesToShow) * pagesToShow + 1;
	    int endPage = Math.min(startPage + pagesToShow - 1, totalPages);

	    List<ReviewDTO> list = mapper.reviewAll(house_num, startRow, endRow);

	    req.setAttribute("reviewAll", list);
	    req.setAttribute("currentPage", page);
	    req.setAttribute("totalPages", totalPages);
	    req.setAttribute("startPage", startPage);
	    req.setAttribute("endPage", endPage);
	    req.setAttribute("house_num", house_num);  // Add house_num for JSP use

	    return "guest/review_all";
	}
	
	@RequestMapping("/introduce_javajo.do") 
	public String introduceJavajo() {
		return "guest/javajo";
	}
}

