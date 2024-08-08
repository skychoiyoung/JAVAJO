package com.javajo.project.service;

import java.util.*;
import org.apache.ibatis.session.SqlSession;
import org.apache.ibatis.session.SqlSessionFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.javajo.project.dto.AdminQnaDTO;
import com.javajo.project.dto.FacDTO;
import com.javajo.project.dto.HouseDTO;
import com.javajo.project.dto.ReservDTO;
import com.javajo.project.dto.ThemeDTO;
import com.javajo.project.dto.TypeDTO;;

@Service   
public class HostMapper {
	private static SqlSessionFactory sqlSessionFactory;
	
	@Autowired
	private SqlSession sqlSession;		
	
	public int insertHouse(HouseDTO dto) {
					
		int res = sqlSession.insert("insertHouse", dto); 		
		return res;		
	}
			
	public int deleteHouse(int house_num) {
							
		int res = sqlSession.delete("deleteHouse", house_num); 
		return res;									
	}
	
	
	public HouseDTO infoHouse(int house_num) {
		
		HouseDTO dto = sqlSession.selectOne("infoHouse", house_num);
		return dto;
	}
	
	public HouseDTO imageList(int house_num) {
		
		HouseDTO dto = sqlSession.selectOne("imageList", house_num);
		return dto;
	}
	
	public String sort1(int house_num) {
		
		String sort1 = sqlSession.selectOne("sort1", house_num);
		return sort1;
	}
		
	public List<HouseDTO> checkHousename() {
		
		List<HouseDTO> list = sqlSession.selectList("checkHousename");
		return list;
	}
	
	public int updateHouse(HouseDTO dto) {
		
		int res = sqlSession.update("updateHouse", dto); 		
		return res;	
	}
	
	public String houseType(String htype) {
		
		String houseType = sqlSession.selectOne("houseType", htype);
		return houseType;
	}
	
	public List<TypeDTO> listHouseType() {
		
		List<TypeDTO> list = sqlSession.selectList("listHouseType");
		return list;
	}
	
	public List<ThemeDTO> listHouseTheme() {
		
		List<ThemeDTO> list = sqlSession.selectList("listHouseTheme");		
		return list;
	}

	public List<FacDTO> listHouseFac() {
	
		List<FacDTO> list = sqlSession.selectList("listHouseFac");
		return list;
	}
	
	public List<ReservDTO> paylistHouse1(String user_id) {
		
		List<ReservDTO> list = sqlSession.selectList("paylistHouse1", user_id);
		return list;	
	}
	
	public List<ReservDTO> paylistHouse2(Map<String, String> params) {
						
		List<ReservDTO> list = sqlSession.selectList("paylistHouse2", params);
		return list;	
	}
							
	public List<HouseDTO> listHouse(String user_id){
		
		List<HouseDTO> list = sqlSession.selectList("listHouseById", user_id); 
		return list;	
	}
	
	public List<HouseDTO> viewHouse(){
		
		List<HouseDTO> list = sqlSession.selectOne("viewHouse"); 
		return list;	
	}
	
	public int findQna(Map<String, Object> params1){
		
		int res = sqlSession.selectOne("findQnaNum", params1);
		return res;	
	}
	
	public int hostQnaAnswer(Map<String, Object> params2){
		
		int res = sqlSession.update("hostQnaAnswer", params2); 
		return res;	
	}
	
	public int answerDelete(int hostqna_num){
		
		int res = sqlSession.update("hostQnaAnswerDelete", hostqna_num); 
		return res;	
	}
	
	public int getHostReservCount1(String user_id){
		
		int res = sqlSession.selectOne("getHostReservCount1", user_id);
		return res;	
	}
	
	public int getHostReservCount2(Map<String, String> params){
			
		int res = sqlSession.selectOne("getHostReservCount2", params);
		return res;	
	}
	
	public int getHostReservCount3(Map<String, String> params){
		
		int res = sqlSession.selectOne("getHostReservCount3", params);
		return res;	
	}
	
	public int getHostReservCount4(Map<String, String> params){
		
		int res = sqlSession.selectOne("getHostReservCount4", params);
		return res;	
	}
	
	public int getHostPaymanageCount1(String user_id){
		
		int res = sqlSession.selectOne("getHostPaymanageCount1", user_id);
		return res;	
	}
	
	public int getHostPaymanageCount2(Map<String, String> params){
		
		int res = sqlSession.selectOne("getHostPaymanageCount2", params);
		return res;	
	}
	
	// 호스트(숙소 상태 업데이트)
	public int beforeCheckin(){
		
		int res = sqlSession.update("beforeCheckin"); 		
		return res;	
	}
	
	public int nowCheckin(){
			
		int res = sqlSession.update("nowCheckin"); 		
		return res;	
	}
	
	public int afterCheckout(){
		
		int res = sqlSession.update("afterCheckout"); 		
		return res;	
	}
		
	// 호스트(숙소 예약내역보기)
	public List<ReservDTO> reservAll(Map<String, Object> params){
		
		List<ReservDTO> list = sqlSession.selectList("reservAll", params); 		
		return list;	
	}
	
	public List<ReservDTO> hAllsChoice(Map<String, Object> params){
		
		List<ReservDTO> list = sqlSession.selectList("hAllsChoice", params); 		
		return list;	
	}
	
	public List<ReservDTO> hChoicesAll(Map<String, Object> params){
		
		List<ReservDTO> list = sqlSession.selectList("hChoicesAll", params); 		
		return list;	
	}

	public List<ReservDTO> hChoicesChoice(Map<String, Object> params){
	
		List<ReservDTO> list = sqlSession.selectList("hChoicesChoice", params); 		
		return list;	
	}
	
		
	// 페이징처리해서 보여줄 정산 리스트
	public List<ReservDTO> paymentList1(Map<String, Object> params2){
			
		List<ReservDTO> list = sqlSession.selectList("paymentList1", params2);		
		return list;
	}
	
	public List<ReservDTO> paymentList2(Map<String, Object> params2){
		
		List<ReservDTO> list = sqlSession.selectList("paymentList2", params2);		
		return list;
	}
	
	public List<ReservDTO> totPrice1(String user_id){
		
		List<ReservDTO> list = sqlSession.selectList("totPrice1", user_id);		
		return list;
	}
	
	public List<ReservDTO> totPrice2(Map<String, String> params){
		
		List<ReservDTO> list = sqlSession.selectList("totPrice2", params);		
		return list;
	}
	
	public String checkedTheme(int house_num){
		
		String checkedTheme = sqlSession.selectOne("checkedTheme", house_num);
		return checkedTheme;	
	}
	
	public List<String> getThemeNames(List<String> themeCodes){
		
		List<String> themeList = sqlSession.selectList("getThemeNames", themeCodes);
		return themeList;
	}
	
	public HouseDTO getCheckinOut(int house_num){
		
		HouseDTO getCheckinOut = sqlSession.selectOne("getCheckinOut", house_num);
		return getCheckinOut;	
	}
	
	
	public String checkedFac(int house_num){
		
		String checkedTheme = sqlSession.selectOne("checkedFac", house_num);
		return checkedTheme;	
	}
	
	public List<String> getFacNames(List<String> facCodes){
		
		List<String> facList = sqlSession.selectList("getFacNames", facCodes);
		return facList;
	}
	
	public List<ReservDTO> getDates(int house_num){
		
		List<ReservDTO> getDates = sqlSession.selectList("getDates", house_num);
		return getDates;
	}
}
