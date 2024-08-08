package com.javajo.project;

import java.io.File;
import java.io.IOException;
import java.text.SimpleDateFormat;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.YearMonth;
import java.time.format.DateTimeFormatter;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.Calendar;
import java.util.HashMap;
import java.util.List;
import java.util.Locale;
import java.util.Map;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.dao.DataIntegrityViolationException;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.multipart.MultipartHttpServletRequest;

import com.javajo.project.dto.AdminQnaDTO;
import com.javajo.project.dto.FacDTO;
import com.javajo.project.dto.HostQnaDTO;
import com.javajo.project.dto.HouseDTO;
import com.javajo.project.dto.ReservDTO;
import com.javajo.project.dto.ReviewDTO;
import com.javajo.project.dto.ThemeDTO;
import com.javajo.project.dto.TypeDTO;
import com.javajo.project.dto.UserDTO;
import com.javajo.project.dto.WishListDTO;
import com.javajo.project.service.GuestMapper;
import com.javajo.project.service.HostMapper;


@Controller  // 에노테이션-길잡이라는 뜻 지금부터 나온 얘는 뭐야 라고 알려주는거
public class HostController {
	
	@Autowired // service로 등록했던 애들 가져다 사용할 수 있음
	HostMapper hostMapper;
	@Autowired
	GuestMapper mapper;
	
	List<MultipartFile> images;
	
	@RequestMapping("/manageHouse.do")
	public String listHouse(HttpServletRequest req) {
		HttpSession session = req.getSession();
		UserDTO dto = (UserDTO)session.getAttribute("inUser");
		String user_id = dto.getUser_id();
		List<HouseDTO> list = hostMapper.listHouse(user_id);
		req.setAttribute("user_id", user_id);
		req.setAttribute("listHouse", list);
		
		String path = "C:/Users/SAMSUNG/Desktop/FINTECH/project2/javajo/src/main/webapp/resources/upload_house_images";
		req.setAttribute("path", path);
		return "host/house_manage";
	}
			
	@RequestMapping(value ="/insertHouse.do", method=RequestMethod.GET) // 속성값 적을거면 value 꼭 적어줘야됌!
	public String insertHouse(HttpServletRequest req) {
		
		List<TypeDTO> list1 = hostMapper.listHouseType();	
		req.setAttribute("listHouseType", list1);
		List<ThemeDTO> list2 = hostMapper.listHouseTheme();	
		req.setAttribute("listHouseTheme", list2);
		List<FacDTO> list3 = hostMapper.listHouseFac();	
		req.setAttribute("listHouseFac", list3);
		List<HouseDTO> list4 = hostMapper.checkHousename();	
		req.setAttribute("checkHousename", list4);
		return "host/house_insert";
	}
	
	// 숙소 이미지 저장 
	@PostMapping("/imageUpload.do")
	   public void imageUpload(HttpServletRequest req, @RequestParam("files") List<MultipartFile> receiveImages) { 
	         
			images = receiveImages;
	   }
			
	@RequestMapping(value ="/insertHouse.do", method=RequestMethod.POST)
	   public String insertHouseOk(HttpServletRequest req, @ModelAttribute HouseDTO dto, @RequestParam("house_theme")
	          String[] house_theme, @RequestParam("house_fac") String[] house_fac, @RequestParam Map<String, String> params) throws IllegalStateException, IOException { 
		
	        String[] storedFilenames = new String[5];
	        for (int i = 0; i < images.size(); i++) {
	        	MultipartFile mf = images.get(i);
	            if (!mf.isEmpty()) {	            	
	            	// 파일명 중복방지 추가
	         		Calendar cal = Calendar.getInstance()  ;
	         		SimpleDateFormat timeForamt = new SimpleDateFormat("yyMMddhhmmss");
	         		String serial = timeForamt.format(cal.getTime());	         		
	         		
            		String originalFilename = mf.getOriginalFilename();
	                String storedFilename = serial+ "_" + originalFilename;
	                String path = "C:/Users/SAMSUNG/Desktop/FINTECH/project2/javajo/src/main/webapp/resources/upload_house_images";
	                File file = new File(path, storedFilename);
	                mf.transferTo(file);
	                storedFilenames[i] = storedFilename;	                
	            }
	        }
	        String house_addr = params.get("addr1")+ " " + params.get("addr2");	        
	        // 테마 리스트를 배열 -> 한줄의 string으로 변환
	        String resultTheme = String.join(",", house_theme);
	    	// 편의 리스트를 배열 -> 한줄의 string으로 변환
	        String resultFac = String.join(",", house_fac);
	        	        	        
	        String house_checkin1 = params.get("house_checkin1");
	        String house_checkin2 = params.get("house_checkin2");
	        String house_checkout1 = params.get("house_checkout1");
	        String house_checkout2 = params.get("house_checkout2");
	        
	        if(Integer.parseInt(house_checkin1) < 10) {
	        	house_checkin1 = "0" + house_checkin1;
	        }
	        if(Integer.parseInt(house_checkin2) < 10) {
	        	house_checkin2 = "0" + house_checkin2;
	        }
	        if(Integer.parseInt(house_checkout1) < 10) {
	        	house_checkout1 = "0" + house_checkout1;
	        }
	        if(Integer.parseInt(house_checkout2) < 10) {
	        	house_checkout2 = "0" + house_checkout2;
	        }
	        String house_checkin = house_checkin1 + ":" + house_checkin2;
	        String house_checkout = house_checkout1 + ":" + house_checkout2;
	        
	        HttpSession session = req.getSession();
			UserDTO IDdto = (UserDTO)session.getAttribute("inUser");
			String user_id = IDdto.getUser_id();			
	      dto.setUser_id(user_id); 
	      dto.setHouse_addr(house_addr);  
	      dto.setHouse_image1(storedFilenames[0]);
	      dto.setHouse_image2(storedFilenames[1]);
	      dto.setHouse_image3(storedFilenames[2]);
	      dto.setHouse_image4(storedFilenames[3]);
	      dto.setHouse_image5(storedFilenames[4]);
	      dto.setHouse_fac(resultFac);
	      dto.setHouse_theme(resultTheme); 
	      dto.setHouse_checkin(house_checkin); 
	      dto.setHouse_checkout(house_checkout);
	      
	      int res = hostMapper.insertHouse(dto);
	      List<HouseDTO> list = hostMapper.listHouse(user_id);	
	      req.setAttribute("listHouse", list);
	      List<HouseDTO> list2 = hostMapper.checkHousename();	
	      req.setAttribute("checkHouse", list2);
	      req.setAttribute("msg", "숙소등록이 완료되었습니다.");
	      req.setAttribute("url", "manageHouse.do");
	      return "message";
	   }
	
	@RequestMapping(value = "/deleteHouse.do", method = RequestMethod.GET)
	@ResponseBody
	public Map<String, Object> deleteHouse(HttpServletRequest req,  @RequestParam("house_num") int house_num) {
		HttpSession session = req.getSession();
		UserDTO dto = (UserDTO)session.getAttribute("inUser");
		String user_id = dto.getUser_id();				
		req.setAttribute("user_id", user_id);
		Map<String, Object> resultMap = new HashMap<>();
		 try {
		        int res = hostMapper.deleteHouse(house_num);
		        if (res > 0) {
		        	// 이미지 파일 삭제
		            resultMap.put("success", true);
		        } else {
		            resultMap.put("success", false);
		        }
		    } catch (DataIntegrityViolationException e) {
		        // 데이터 무결성 예외 처리
		        resultMap.put("success", false);
		    } catch (Exception e) {
		        // 그 외 예외 처리
		        resultMap.put("success", false);
		    }		    
		    return resultMap;
	}
	
	@RequestMapping("/openPopup.do")
	public String openPopup(HttpServletRequest req, @RequestParam("house_num") int house_num) {
		// 이미지 파일 이름 나타나게 하기
		HouseDTO imagedto = hostMapper.imageList(house_num);
		// 이미지 파일들 경로 리스트로 받기
	    List<String> imageUrls = new ArrayList<>();
	    // 리스트에 넣어주기
	    imageUrls.add("\""+"resources/upload_house_images/"
				+ imagedto.getHouse_image1()+"\"");
	    imageUrls.add("\""+"resources/upload_house_images/"
				+ imagedto.getHouse_image2()+"\"");
	    imageUrls.add("\""+"resources/upload_house_images/" 
				+ imagedto.getHouse_image3()+"\"");
	    imageUrls.add("\""+"resources/upload_house_images/"
				+ imagedto.getHouse_image4()+"\"");
	    imageUrls.add("\""+"resources/upload_house_images/"
				+ imagedto.getHouse_image5()+"\"");
	    
	    req.setAttribute("imageUrls", imageUrls);
	    return "host/fileUpload_update"; 
	} 
		
	@RequestMapping(value = "/updateHouse.do", method=RequestMethod.GET)
	public String updateHouse(HttpServletRequest req, @RequestParam("house_num") int house_num) {
		
		// 이미지 파일 보내서 파일 이름 나타나게 하기
		HouseDTO imagedto = hostMapper.imageList(house_num);
		List<String> imageList = new ArrayList<>();
		imageList.add(imagedto.getHouse_image1());  
		imageList.add(imagedto.getHouse_image2());
		imageList.add(imagedto.getHouse_image3()); 
		imageList.add(imagedto.getHouse_image4()); 
		imageList.add(imagedto.getHouse_image5()); 
		req.setAttribute("images", imageList);
		
		// 테마, 편의리스트 보내주기
		List<ThemeDTO> list2 = hostMapper.listHouseTheme();	
		req.setAttribute("listHouseTheme", list2);
		List<FacDTO> list3 = hostMapper.listHouseFac();	
		req.setAttribute("listHouseFac", list3);
		
		// 해당 숙소 저장되어 있는 테마, 편의시설 가져오기
		String house_theme = hostMapper.checkedTheme(house_num);
		List<String> themeCodes = Arrays.asList(house_theme.split(","));
		List<String> themeNames = hostMapper.getThemeNames(themeCodes);
		req.setAttribute("selectedTheme", themeNames);
		
		String house_fac = hostMapper.checkedFac(house_num);
		List<String> facCodes = Arrays.asList(house_fac.split(","));
		List<String> themeFac = hostMapper.getFacNames(facCodes);
		req.setAttribute("selectedFac", themeFac);
		
		// 체크인, 체크아웃 불러오기
		HouseDTO checkinOut = hostMapper.getCheckinOut(house_num);
		String checkin = checkinOut.getHouse_checkin();
		String checkout = checkinOut.getHouse_checkout();
		String[] checkinParts = checkin.split(":");
		String[] checkoutParts = checkout.split(":");

		req.setAttribute("sort1", checkinParts[0]);
		req.setAttribute("sort2", checkinParts[1]);
		req.setAttribute("sort3", checkoutParts[0]);
		req.setAttribute("sort4", checkoutParts[1]);
		
		HouseDTO dto = hostMapper.infoHouse(house_num);
		String htype = dto.getHouse_type();
		String house_type = hostMapper.houseType(htype);
		req.setAttribute("house_type", house_type);	
		req.setAttribute("infoHouse", dto);
		return "host/house_update";
	}
	
	@RequestMapping(value = "/updateHouse.do", method=RequestMethod.POST)
	public String updateOkHouse(HttpServletRequest req, @ModelAttribute HouseDTO dto, @RequestParam("house_theme")
    String[] house_theme, @RequestParam("house_fac") String[] house_fac, @RequestParam Map<String, String> params) throws IllegalStateException, IOException {
		
			String[] storedFilenames = new String[5];
	        for (int i=0; i<images.size(); i++ ) {
	        	 MultipartFile mf = images.get(i);          
	            if (!mf.isEmpty()) {
	            	// 파일명 중복방지 추가
	         		Calendar cal = Calendar.getInstance()  ;
	         		SimpleDateFormat timeForamt = new SimpleDateFormat("yyMMddhhmmss");
	         		String serial = timeForamt.format(cal.getTime());	  
	         		
	        		String originalFilename = mf.getOriginalFilename();
	                String storedFilename = serial+ "_" + originalFilename;
	                String path = "C:/Users/SAMSUNG/Desktop/FINTECH/project2/javajo/src/main/webapp/resources/upload_house_images";
	                File file = new File(path, storedFilename);
	                mf.transferTo(file);
	                storedFilenames[i] = storedFilename;	                
	            }
	        }
        // 테마 리스트를 배열 -> 한줄의 string으로 변환
        String resultTheme = String.join(",", house_theme);
    	// 편의 리스트를 배열 -> 한줄의 string으로 변환
        String resultFac = String.join(",", house_fac);
        
        HttpSession session = req.getSession();
		UserDTO IDdto = (UserDTO)session.getAttribute("inUser");
		String user_id = IDdto.getUser_id();
		
		String house_checkin1 = params.get("house_checkin1");
        String house_checkin2 = params.get("house_checkin2");
        String house_checkout1 = params.get("house_checkout1");
        String house_checkout2 = params.get("house_checkout2");
        
        if(Integer.parseInt(house_checkin1) < 10) {
        	house_checkin1 = "0" + house_checkin1;
        }
        if(Integer.parseInt(house_checkin2) < 10) {
        	house_checkin2 = "0" + house_checkin2;
        }
        if(Integer.parseInt(house_checkout1) < 10) {
        	house_checkout1 = "0" + house_checkout1;
        }
        if(Integer.parseInt(house_checkout2) < 10) {
        	house_checkout2 = "0" + house_checkout2;
        }
        String house_checkin = house_checkin1 + ":" + house_checkin2;
        String house_checkout = house_checkout1 + ":" + house_checkout2;
        String house_num = params.get("house_num");
		
        dto.setHouse_num(Integer.parseInt(house_num));  
		dto.setUser_id(user_id);                
        dto.setHouse_image1(storedFilenames[0]);
        dto.setHouse_image2(storedFilenames[1]);
        dto.setHouse_image3(storedFilenames[2]);
        dto.setHouse_image4(storedFilenames[3]);
        dto.setHouse_image5(storedFilenames[4]);
        dto.setHouse_fac(resultFac);
     	dto.setHouse_theme(resultTheme);
     	dto.setHouse_checkin(house_checkin); 
     	dto.setHouse_checkout(house_checkout);   	
      
		int res = hostMapper.updateHouse(dto); 
		List<HouseDTO> list2 = hostMapper.checkHousename();		
		req.setAttribute("checkHouse", list2);
		List<HouseDTO> list = hostMapper.listHouse(user_id);	
		req.setAttribute("listHouse", list);
		req.setAttribute("msg", "숙소 수정이 완료되었습니다.");
		req.setAttribute("url", "manageHouse.do");
		return "message";
	}
			
	// 달력에 예약날짜 표시
	@GetMapping("/get-dates")
	@ResponseBody
	public DatesData getDates(@RequestParam("house_num") int house_num) {
	    List<ReservDTO> reservDTOList = hostMapper.getDates(house_num);
	    List<String> reservedDates = new ArrayList<>();
	    DateTimeFormatter formatter = DateTimeFormatter.ofPattern("yyyy-MM-dd");
	     
	    for (ReservDTO reservDTO : reservDTOList) {
	        // 체크인 날짜에서 시간 부분 제거 후 파싱
	        String checkinDate = reservDTO.getReserv_checkin().substring(0, 10);
	        LocalDate startDate = LocalDate.parse(checkinDate, formatter);

	        // 체크아웃 날짜에서 시간 부분 제거 후 파싱
	        String checkoutDate = reservDTO.getReserv_checkout().substring(0, 10);
	        LocalDate endDate = LocalDate.parse(checkoutDate, formatter);
	        
	        System.out.println("checkinDate :"+checkinDate);
	        System.out.println("checkoutDate :"+checkoutDate);
	        System.out.println("startDate :"+startDate);
	        System.out.println("endDate :"+endDate);

	        
	        
	        // startDate부터 endDate까지의 날짜를 리스트에 추가
	        while (!startDate.isAfter(endDate)) {
	            reservedDates.add(startDate.format(formatter));
	            startDate = startDate.plusDays(1);
	        }
	    }

	    // JSON 응답 데이터로 반환
	    return new DatesData(reservedDates);
	}

	// DatesData 클래스는 예약 불가능한 날짜 데이터를 JSON으로 변환하기 위한 모델 클래스
	public static class DatesData {
	    private List<String> impossibleDate;

	    public DatesData(List<String> impossibleDate) {
	        this.impossibleDate = impossibleDate;
	    }

	    public List<String> getImpossibleDate() {
	        return impossibleDate;
	    }

	    public void setImpossibleDate(List<String> impossibleDate) {
	        this.impossibleDate = impossibleDate;
	    }
	}
	

	@RequestMapping("/house_Hinfo.do")
	public String HouseInfo(HttpServletRequest req, @RequestParam int house_num,
			@RequestParam(value = "pageNum", required = false, defaultValue = "1") int pageNum) {
		
		HttpSession session = req.getSession();
		UserDTO udto = (UserDTO)session.getAttribute("inUser");		
		String user_id = udto.getUser_id();
        // 숙소 정보, 리뷰 정보, QnA 정보를 한 번에 조회
        HouseDTO houseDTO = mapper.getHouseByNum(house_num);
        List<ReviewDTO> reviews = mapper.listReview(house_num);    
     	List<WishListDTO> wishList = mapper.getWishList(user_id);
        
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
        HouseDTO dto = hostMapper.infoHouse(house_num);
		req.setAttribute("infoHouse", dto);
        req.setAttribute("getHouseByNum", houseDTO);
        req.setAttribute("listReview", reviews);
        req.setAttribute("facList", facList);
        req.setAttribute("themeList", themeList);
        req.setAttribute("wishList", wishList);
        
        // 호스트QNA 페이징
        req.setAttribute("hostQnaCount", hostQnaCount);
		req.setAttribute("pageSize", pageSize);
		req.setAttribute("no", no);
		req.setAttribute("pageBlock", pageBlock);
		req.setAttribute("startPage", startPage);
		req.setAttribute("endPage", endPage);
		req.setAttribute("listQna", qnaList);
		req.setAttribute("pageCount", pageCount);
        return "host/host_house_info";
    }
	
	@RequestMapping("/hostQna_answer.do")
    public String hostQnaAnswer(HttpServletRequest req, @RequestParam("user_id") String user_id,
    													@RequestParam("house_num") int house_num,                           
    													@RequestParam("hostqna_hcontent") String hostqna_hcontent,
    													@RequestParam("hostqna_gcontent") String hostqna_gcontent, 
    													String mode) {	
		// hostqna_num 값 db에서 꺼내기
		Map<String, Object> params1 = new HashMap<>();    
		params1.put("user_id", user_id);
		params1.put("hostqna_gcontent", hostqna_gcontent);
		params1.put("house_num", house_num);
		int hostqna_num = hostMapper.findQna(params1);
		
		// 답변 삭제하기 버튼 눌렀을때
		if(mode != null) { 
    		int res = hostMapper.answerDelete(hostqna_num);
            if (res > 0) {
                req.setAttribute("msg", "답변이 삭제되었습니다.");
            }else {
                req.setAttribute("msg", "답변 삭제에 실패하였습니다. 관리자에게 문의 바랍니다.");
            }
            req.setAttribute("url", "house_Hinfo.do?house_num=" + house_num);
            return "message";
    		
    	}else {								
			// db에 답글 내용 업데이트 시켜주기
			Map<String, Object> params2 = new HashMap<>();    
	        params2.put("hostqna_hcontent", hostqna_hcontent);
	        params2.put("hostqna_num", hostqna_num);       
	        int res = hostMapper.hostQnaAnswer(params2);
	        if (res > 0) {
	            req.setAttribute("msg", "답변이 등록되었습니다.");
	        }else {
	            req.setAttribute("msg", "답변 등록에 실패하였습니다. 관리자에게 문의 바랍니다.");
	        }
	        req.setAttribute("url", "house_Hinfo.do?house_num=" + house_num);
	        return "message";
    	}
    }	
	
	@RequestMapping("/reservHouse.do")
	public String listReservHouse(HttpServletRequest req, @RequestParam Map<String, String> params, String mode, 
	    @RequestParam(value = "pageNum", required = false, defaultValue = "1") int pageNum) { 

	    HttpSession session = req.getSession();
	    UserDTO IDdto = (UserDTO)session.getAttribute("inUser");
	    String user_id = IDdto.getUser_id();
	    params.put("user_id", user_id);    
	    List<HouseDTO> list2= hostMapper.listHouse(user_id);                
	    req.setAttribute("listHouse", list2);    
	    req.setAttribute("user_id", user_id);
	    
	    // 페이지 들어올때마다 예약상태 업데이트
	    int res1 = hostMapper.beforeCheckin();            
	    int res2 = hostMapper.nowCheckin();    
	    int res3 = hostMapper.afterCheckout();
	    
	    if (mode != null) {
	        String house_num_str = params.get("house_num");
	        if(!house_num_str.equals("all")) {
	            int house_num = Integer.parseInt(house_num_str);
	            String house_name = hostMapper.sort1(house_num);                
	            req.setAttribute("sort1", house_name);
	            req.setAttribute("house_num", house_num);
	            params.put("house_name", house_name);
	        } else {
	            req.setAttribute("sort1", "all");
	            req.setAttribute("house_num", "all");
	            params.put("house_name", "all");
	        }            
	        String reserv_status = params.get("reserv_status");            
	        req.setAttribute("sort2", reserv_status);
	        
	        switch (reserv_status) {
	            case "use": reserv_status = "이용중";                
	                break; 
	            case "wait":  reserv_status = "결제완료";                
	                break;    
	            case "finish": reserv_status = "이용완료";                
	                break;
	            case "cancel": reserv_status = "예약취소";                
	                break;
	            default:                
	                break;
	        }
	        params.put("reserv_status", reserv_status);    
	        
	        Map<String, Object> params2;
	        String house_name = (String)req.getAttribute("sort1");
	        
	        if("all".equals(house_name) && "all".equals(reserv_status)) {
	            int reservCount = hostMapper.getHostReservCount1(user_id); 
	            params2 = page(req, user_id, pageNum, reservCount);
	            List<ReservDTO> list = hostMapper.reservAll(params2);
	            req.setAttribute("reservList", list);
	            
	        } else if("all".equals(house_name) && !"all".equals(reserv_status)) {
	            int reservCount = hostMapper.getHostReservCount2(params);
	            params2 = page(req, user_id, pageNum, reservCount);
	            params2.put("reserv_status", reserv_status);
	            List<ReservDTO> list = hostMapper.hAllsChoice(params2);                
	            req.setAttribute("reservList", list);
	            
	        } else if(!"all".equals(house_name) && "all".equals(reserv_status)) {
	            int reservCount = hostMapper.getHostReservCount3(params);                    
	            params2 = page(req, user_id, pageNum, reservCount);
	            params2.put("house_name", house_name);
	            List<ReservDTO> list = hostMapper.hChoicesAll(params2);                
	            req.setAttribute("reservList", list);
	            
	        } else if(!"all".equals(house_name) && !"all".equals(reserv_status)) {
	            int reservCount = hostMapper.getHostReservCount4(params);                    
	            params2 = page(req, user_id, pageNum, reservCount);
	            params2.put("house_name", house_name);
	            params2.put("reserv_status", reserv_status);
	            List<ReservDTO> list = hostMapper.hChoicesChoice(params2);                
	            req.setAttribute("reservList", list);
	        }    
	                    
	    } else {
	        Map<String, Object> params2;
	        int reservCount = hostMapper.getHostReservCount1(user_id); 
	        params2 = page(req, user_id, pageNum, reservCount);
	        List<ReservDTO> list = hostMapper.reservAll(params2);    
	        req.setAttribute("reservList", list);
	    }
	    
	    return "host/house_reserv";
	}
	
	@RequestMapping("/moneyManage.do")
	public String paylistHouse(HttpServletRequest req, @RequestParam Map<String, String> params, String mode,
			@RequestParam(value = "pageNum", required = false, defaultValue = "1") int pageNum) {  // 원래는 갈떄마다 request값 저장해줬음
			
			//select창 연도 내림차순으로
			List<Integer> years = new ArrayList<>();
	        for (int year = 2024; year >= 2022; year--) {
	            years.add(year);
	        }
	        req.setAttribute("years", years);
	        
	        HttpSession session = req.getSession();
			UserDTO IDdto = (UserDTO)session.getAttribute("inUser");
			String user_id = IDdto.getUser_id();
			params.put("user_id", user_id);			
		
		if (mode != null) { // 검색 버튼 눌렀을때 실행			
			String sort1 = params.get("year_choice1");
			String sort2 = params.get("month_choice1");
			String sort3 = params.get("year_choice2");
			String sort4 = params.get("month_choice2");
			
			req.setAttribute("sort1", sort1);
			req.setAttribute("sort2", sort2);
			req.setAttribute("sort3", sort3);
			req.setAttribute("sort4", sort4);
			
			// 1~9월 앞에 0 붙여주기
			String year1 = params.get("year_choice1");
			String month1 = params.get("month_choice1");
			if(Integer.parseInt(month1)< 10) {
				month1 = "0" + month1;
			}
			String year2 = params.get("year_choice2");			
			String month2 = params.get("month_choice2");
			if(Integer.parseInt(month2)< 10) {
				month2 = "0" + month2;
			}			
			String firstDay = year1 + "-" + month1+"-01";
			String lastDay = lastDay(Integer.parseInt(year2), Integer.parseInt(month2));	       
			
			Map<String, Object> params2;
																	
			params.put("firstDay", firstDay);
			params.put("lastDay", lastDay);
			int reservCount = hostMapper.getHostPaymanageCount2(params); 
			params2 = page(req, user_id, pageNum, reservCount);
			params2.put("firstDay", firstDay);
			params2.put("lastDay", lastDay);
			
			List<ReservDTO> list = hostMapper.paymentList2(params2);
			req.setAttribute("paylistHouse", list);
			// 총 수입 계산
			List<ReservDTO> resDTO = hostMapper.totPrice2(params);
			int totprice = 0;
			for(ReservDTO dto : resDTO) {
				totprice += dto.getReserv_pay();
			}
			req.setAttribute("totalPrice", totprice);
		}else {
			Map<String, Object> params2;
			int reservCount = hostMapper.getHostPaymanageCount1(user_id); 			
			params2 = page(req, user_id, pageNum, reservCount);
			List<ReservDTO> list = hostMapper.paymentList1(params2);	
			req.setAttribute("paylistHouse", list);
			// 총 수입 계산
			List<ReservDTO> resDTO = hostMapper.totPrice1(user_id);
			int totprice = 0;
			for(ReservDTO dto : resDTO) {
				totprice += dto.getReserv_pay();
			}
			req.setAttribute("totalPrice", totprice);									
		}
				
		return "host/house_paymanage";
	}
	
	@RequestMapping(value = "/fileUpload.do", method = RequestMethod.GET)
	public String fileUpload() {
		
		return "host/fileUpload_insert";
	}
	
	// 해당 월에 마지막 날 계산
	public static String lastDay(int year, int month) {
		
        YearMonth yearMonthObject = YearMonth.of(year, month);
        int daysInMonth = yearMonthObject.lengthOfMonth();
        return String.format("%d-%02d-%02d", year, month, daysInMonth);
    }
	
	// 페이지 처리
	public Map<String, Object> page(HttpServletRequest req, String user_id, int pageNum, 
			int adminQnaCount) {
					
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
		
		Map<String, Object> params2 = new HashMap<>();
		params2.put("user_id", user_id);			
		params2.put("startRow", startRow);
		params2.put("endRow", endRow);
	
		req.setAttribute("pageSize", pageSize);
		req.setAttribute("no", no);
		req.setAttribute("pageBlock", pageBlock);
		req.setAttribute("startPage", startPage);
		req.setAttribute("endPage", endPage);	
		req.setAttribute("pageCount", pageCount);
		return params2;
    }
}
