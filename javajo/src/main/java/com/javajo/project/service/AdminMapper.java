package com.javajo.project.service;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.ibatis.session.SqlSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.javajo.project.dto.AdminQnaDTO;
import com.javajo.project.dto.NoticeDTO;
import com.javajo.project.dto.ReservDTO;

@Service
public class AdminMapper {
	@Autowired
	private SqlSession sqlSession;

	// 공지사항 페이지 -----------------------------------
	public List<NoticeDTO> listNotice(Map<String, Object> params) {
		List<NoticeDTO> list = sqlSession.selectList("listNotice", params);
		return list;
	}

	// 페이징 처리를 위한 쿼리문 변경
	public int noticeCount() {
		int count = sqlSession.selectOne("noticeCount");
		// System.out.println(count);
		return count;
	}

	// 페이징 처리를 위해 추가
	public int checkNum(String user_id) {
		return sqlSession.selectOne("checkNum", user_id);
	}

	// 추가
	public int insertNotice(NoticeDTO dto) {
		int res = sqlSession.insert("insertNotice", dto);
		return res;
	}

	public NoticeDTO getNoticeByNum(int notice_num) {
		NoticeDTO dto = sqlSession.selectOne("getNoticeByNum", notice_num);
		return dto;
	}

	// 삭제
	public int deleteNotice(int notice_num) {
		int res = sqlSession.delete("deleteNotice", notice_num);
		return res;
	}

	// 수정
	public int updateNotice(NoticeDTO dto) {
		int res = sqlSession.update("updateNotice", dto);
		return res;
	}

	// 고객문의 ----------------------------------------
	public List<AdminQnaDTO> listAdminQna(Map<String, Object> params) {
		List<AdminQnaDTO> list = sqlSession.selectList("listAdminQna", params);
		return list;
	}

	// 페이징 처리를 위한 쿼리문 변경
	public int adminQnaCount() {
		int count = sqlSession.selectOne("adminQnaCount");
		return count;
	}

	// 페이징 처리를 위해 추가
	public int checkAdmin(String user_id) {
		return sqlSession.selectOne("checkAdmin", user_id);
	}

	public AdminQnaDTO getAdminQnaByNum(int adminqna_num) {
		AdminQnaDTO dto = sqlSession.selectOne("getAdminQnaByNum", adminqna_num);
		return dto;
	}

	public int updateAdminQna(AdminQnaDTO dto) {
		int res = sqlSession.update("updateAdminQna", dto);
		return res;
	}

	public int deleteAdminAnswer(int adminqna_num) {
		int res = sqlSession.update("deleteAdminAnswer", adminqna_num);
		return res;
	}

	public int insertAdminQna(AdminQnaDTO dto) {
		int res = sqlSession.insert("insertAdminQna", dto);
		return res;
	}

	// 정산관리 -----------------------------------------------------------

		// 연도별 year

		// 기간별 period
		public List<ReservDTO> periodAccount(Map<String, Object> params) {
			List<ReservDTO> list = sqlSession.selectList("periodAccount", params);
			return list;
		}

		// 페이징 처리 기간별
		public int periodCount(Map<String, Object> params) {
			return sqlSession.selectOne("periodCount", params);
		}

		// 연도별 리스트
		public List<ReservDTO> listAccount(Map<String, Object> params) {
			List<ReservDTO> list = sqlSession.selectList("listAccount", params);

			return list;
		}
		
		// 월별 리스트
		public List<ReservDTO> monthAccount(String searchYear) {
			List<ReservDTO> list = sqlSession.selectList("monthAccount", searchYear);
			return list;
		}
		

		// 페이징 처리 년별
		public int adminAccount(Map<String, Object> params) {
			int count = sqlSession.selectOne("adminAccount", params);
			return count;
		}
		
		// 기간별) 총 수수료 합계 
		public int totPaycharge(Map<String, Object> params) {
			int totPaycharge = sqlSession.selectOne("totPaycharge", params);
			return totPaycharge;
		}
		
		// 연도별) 총 수수료 합계
		public int totPaychargeYear(Map<String,Object> params) {
			int totPaychargeYear = sqlSession.selectOne("totPaychargeYear", params);
			return totPaychargeYear;
		}
		
		// 월별) 총 수수료 합계
		public int totPaychargeMonth(String searchYear) {
			int totPaychargeMonth = sqlSession.selectOne("totPaychargeMonth", searchYear);
			return totPaychargeMonth;
		}

}