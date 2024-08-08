package com.javajo.project.service;

import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.Date;
import java.util.HashMap;
import java.util.Hashtable;
import java.util.List;
import java.util.Map;

import org.apache.ibatis.annotations.Param;
import org.apache.ibatis.session.SqlSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.javajo.project.dto.AdminQnaDTO;
import com.javajo.project.dto.FacDTO;
import com.javajo.project.dto.HostQnaDTO;
import com.javajo.project.dto.HouseDTO;
import com.javajo.project.dto.NoticeDTO;
import com.javajo.project.dto.ReservDTO;
import com.javajo.project.dto.ReviewDTO;
import com.javajo.project.dto.ThemeDTO;
import com.javajo.project.dto.WishListDTO;


@Service
public class GuestMapper {
	
	@Autowired
	private SqlSession sqlSession;
	
	// 메인 - 테마 리스트
	public List<ThemeDTO> listTheme(){ 
		List<ThemeDTO> list = sqlSession.selectList("listTheme");
		return list;
	}	
	
	// 메인 - 전체 숙소리스트
	public List<HouseDTO> listHouse(String sort) { 
		List<HouseDTO> list = sqlSession.selectList("listHouse", sort);
		calHousePrice(list);
		return list;		
	}
	
	// 메인 - 테마별 숙소리스트
	public List<HouseDTO> listHousebyTheme(@Param("theme") String theme, String sort){
		Map<String, String> params = new Hashtable<>();
		params.put("theme", theme);
		params.put("sort", sort);
		List<HouseDTO> list = sqlSession.selectList("listHousebyTheme", params);
		calHousePrice(list);
		return list;		
	}
	
	// 메인 - 검색 시 예약가능한 숙소리스트(조건별)
	// 숙소 유형 선택 안한 경우
	public List<HouseDTO> getAvailableHouse1(Map<String, Object> params){
		List<HouseDTO> list = sqlSession.selectList("getAvailableHouse1", params);
		calHousePrice(list);
		return list;
	}
	public List<HouseDTO> getAvailableHouse2(Map<String, Object> params){
		List<HouseDTO> list = sqlSession.selectList("getAvailableHouse2", params);
		calHousePrice(list);
		return list;
	}
	public List<HouseDTO> getAvailableHouse3(Map<String, Object> params){
		List<HouseDTO> list = sqlSession.selectList("getAvailableHouse3", params);
		calHousePrice(list);
		return list;
	}
	public List<HouseDTO> getAvailableHouse4(Map<String, Object> params){
		List<HouseDTO> list = sqlSession.selectList("getAvailableHouse4", params);
		calHousePrice(list);
		return list;
	}
	// 숙소 유형 선택 한 경우
	public List<HouseDTO> getAvailableHouse5(Map<String, Object> params){
		List<HouseDTO> list = sqlSession.selectList("getAvailableHouse5", params);
		calHousePrice(list);
		return list;
	}
	public List<HouseDTO> getAvailableHouse6(Map<String, Object> params){		
		List<HouseDTO> list = sqlSession.selectList("getAvailableHouse6", params);
		calHousePrice(list);
		return list;
	}
	public List<HouseDTO> getAvailableHouse7(Map<String, Object> params){
		List<HouseDTO> list = sqlSession.selectList("getAvailableHouse7", params);
		calHousePrice(list);
		return list;
	}
	public List<HouseDTO> getAvailableHouse8(Map<String, Object> params){
		List<HouseDTO> list = sqlSession.selectList("getAvailableHouse8", params);
		calHousePrice(list);
		return list;
	}
	
	
	// 메인 - 숙박요금 계산 메서드
	private void calHousePrice(List<HouseDTO> list) {
		// 숙박요금 계산
 		double price = 0.0;
 		int priceInt = 0;
 		
 		// Calendar 객체를 사용하여 특정 날짜 설정
        //Calendar calendar = Calendar.getInstance();
        //calendar.set(2024, Calendar.JANUARY, 6);

        // Calendar 객체에서 Date 객체 생성
        // Date date = calendar.getTime();
        Date date = new Date(); // 오늘 날짜로 할 때
		SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd"); // 연월일
		SimpleDateFormat monthFormat = new SimpleDateFormat("MMMM"); // 월
		SimpleDateFormat dayFormat = new SimpleDateFormat("EEEE"); // 요일
		String todayDate = dateFormat.format(date);
		String todayDay = dayFormat.format(date);
		String todayMonth = monthFormat.format(date);

		for(int i=0; i<list.size(); i++) {
			HouseDTO houseDTO = list.get(i);
			if((todayMonth.equals("7월") || todayMonth.equals("8월")) && (todayDay.equals("토요일") || todayDay.equals("일요일"))) {
				price = houseDTO.getHouse_price() * 3;
				priceInt = (int)price;
				list.get(i).setHouse_price(priceInt);
			} else if (todayMonth.equals("7월") || todayMonth.equals("8월")) {
				price = houseDTO.getHouse_price() * 2;
				priceInt = (int)price;
				list.get(i).setHouse_price(priceInt);
			} else if (todayDay.equals("토요일") || todayDay.equals("일요일")) {
				price = houseDTO.getHouse_price() * 1.5;
				priceInt = (int)price;
				list.get(i).setHouse_price(priceInt);
			} else {
				price = houseDTO.getHouse_price();
				priceInt = (int)price;
				list.get(i).setHouse_price(priceInt);
			}			
		}
	}
	
	// 메인 - 게스트선호 리스트
	public List<HouseDTO> guestPreferList(){
		List<HouseDTO> list = sqlSession.selectList("guestPrefer");
		return list;
	}
	
	// 숙소 상세 페이지 정보
	public HouseDTO getHouse(int house_num) {
		return sqlSession.selectOne("getHouse", house_num);
	}
	
	
	// 위시리스트 메뉴
	public List<WishListDTO> getWishList(String user_id){
		List<WishListDTO> list = sqlSession.selectList("getWish", user_id);
		return list;
	}
	
	// 위시리스트 메뉴 - 삭제
	public int delWishList(Map<String, Object> params) {		
		return sqlSession.delete("delWish", params);
	}
	
	// 고객문의
	public List<AdminQnaDTO> getQnaList(Map<String, Object> params){
		List<AdminQnaDTO> list = sqlSession.selectList("getQnaList", params);
		return list;
	}
	
	// 고객문의 게시글 수
	public int getAdminQnaCount(String user_id) {
		int res = sqlSession.selectOne("getAdminQnaCount", user_id);
		return res;
	}
	
	// 고객문의 상세
	public List<AdminQnaDTO> getQnaCont(int adminqna_num){
		List<AdminQnaDTO> list = sqlSession.selectList("getQnaCont", adminqna_num);
		return list;
	}
	
	// 고객문의 삭제
	public int delAdminQna(int adminqna_num) {
		int res = sqlSession.delete("delAdminQna", adminqna_num);
		return res;
	}
	
	// 고객문의 등록(파일 유)
	public int insertAdminQnaF(AdminQnaDTO dto) {
		int res = sqlSession.insert("insertAdminQnaF", dto);
		return res;			
	}
	
	// 고객문의 등록(파일 무)
	public int insertAdminQnaNF(AdminQnaDTO dto) {
		int res = sqlSession.insert("insertAdminQnaNF", dto);
		return res;
	}
	
	
	// 공지사항 확인 페이지
	public List<NoticeDTO> getNotice(Map<String, Object> params) {
		List<NoticeDTO> list = sqlSession.selectList("getNotice", params); 
		return list;
	}
	
	// 공지사항 게시글 수
	public int getNoticeCount() {
		int res = sqlSession.selectOne("getNoticeCount");
		return res;
	}	
	
	// 공지사항 상세 조회
	public NoticeDTO getNoticeCont(int notice_num) {
		return sqlSession.selectOne("getNoticeCont", notice_num);
	}
	
	// S : 작업 영역
	// 예약내역 페이지
	public List<ReservDTO> reserveAll(Map<String, Object> params) {		
		return sqlSession.selectList("reserveAll", params);
	}
	// 예악내역 수
	public int countReserv(String user_id) {
		return sqlSession.selectOne("countReserv", user_id);
	}
	// 예약내역 페이지 - 예약내역 페이지 들어올 때마다 체크인/체크아웃 시간 확인하여 상태 업데이트
	public int checkinCheck(String user_id){	
		int res = sqlSession.update("checkinCheck", user_id); 		
		return res;	
	}	
	public int checkinUpdate(String user_id){		
		int res = sqlSession.update("checkinUpdate", user_id); 		
		return res;	
	}	
	public int checkoutCheck(String user_id){	
		int res = sqlSession.update("checkoutCheck", user_id); 		
		return res;	
	}
	// 예약내역 페이지 - 리뷰작성 상태 업데이트
	public int updateReviewStatus(ReviewDTO dto) {
		return sqlSession.update("updateReviewStatus", dto);
	}
	// 예약내역 페이지 - 예약취소
	public int updateReserveStatus(ReservDTO dto) {
		return sqlSession.update("updateReserveStatus", dto);
	}
	// 예약내역 페이지 - 리뷰등록 (이미지파일 첨부 O)
	public int insertImgReview(ReviewDTO dto) {
		return sqlSession.insert("insertImgReview", dto);
	}
	// 예약내역 페이지 - 리뷰등록 (이미지파일 첨부 X)
	public int insertReview(ReviewDTO dto) {
		return sqlSession.insert("insertReview", dto);
	}
	// 숙소상세 페이지 - 숙소 정보 조회
	public HouseDTO getHouseByNum(int house_num) {
		return sqlSession.selectOne("getHouseByNum", house_num);
	}
	public FacDTO getFac(String f) {
		return sqlSession.selectOne("getFac", f);
   }
	public ThemeDTO getTheme(String t) {
		return sqlSession.selectOne("getTheme", t);
	}
	// 숙소상세 페이지 - 해당 숙소의 예약된 날짜 리스트 뽑아오기
	public List<ReservDTO> getReservList(int house_num){
		return sqlSession.selectList("reservList", house_num);
	}
	// 숙소상세 페이지 - 위시리스트 추가
	public int addToWishlist(WishListDTO dto) {
       return sqlSession.insert("addToWishlist", dto);
   }
   // 숙소상세 페이지 - 위시리스트 삭제
   public void removeFromWishlist(WishListDTO dto) {
       sqlSession.delete("removeFromWishlist", dto);
   }
   // 숙소상세 페이지 - 예약하기
   public int insertReserve(ReservDTO dto) {
	   return sqlSession.insert("insertReserve", dto);
   }
	// 숙소상세 페이지 - 리뷰 리스트
	public List<ReviewDTO> listReview(int house_num) {
	    return sqlSession.selectList("listReview", house_num);
	}
	// 전체리뷰 페이지
	public int countReviews(int house_num) {
	    return sqlSession.selectOne("countReviews", house_num);
	}
	// 전체리뷰 페이징화
	public List<ReviewDTO> reviewAll(@Param("house_num") int house_num, @Param("startRow") int startRow, @Param("endRow") int endRow) {
	    Map<String, Object> params = new HashMap<>();
	    params.put("house_num", house_num);
	    params.put("startRow", startRow);
	    params.put("endRow", endRow);
	    return sqlSession.selectList("reviewAll", params);
	}
	// 숙소상세 페이지 - 호스트QNA 등록
	public int insertQna(HostQnaDTO dto) {
		return sqlSession.insert("insertQna", dto);
	}
	// 숙소상세 페이지 - 호스트QNA 목록
	public List<HostQnaDTO> listQna(Map<String, Object> params) {
		List<HostQnaDTO> list = sqlSession.selectList("listQna", params);
		return list;
	}
	// 숙소상세 페이지 - 호스트QNA 삭제
	public int delQna(int hostqna_num) {
		return sqlSession.delete("delQna", hostqna_num);
	}
	// 숙소상세 페이지 - 호스트QNA 게시글 수
		public int getHostQnaCount(int house_num) {
			int res = sqlSession.selectOne("getHostQnaCount", house_num);
			return res;
		}
}
