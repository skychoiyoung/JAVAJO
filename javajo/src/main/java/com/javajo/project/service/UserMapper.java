package com.javajo.project.service;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.session.SqlSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.javajo.project.dto.UserDTO;

@Service
public class UserMapper {

	@Autowired
	private SqlSession sqlSession;

	public int insertUser(UserDTO dto) {
		return sqlSession.insert("insertUser", dto);
	}

	public int checkId(String id) {
		return sqlSession.selectOne("checkId", id);
	}

	public UserDTO findUserBySid(String sid) {
		return sqlSession.selectOne("findUserBySid", sid);
	}

	public UserDTO findUserById(String id) {
		return sqlSession.selectOne("findUserById", id);
	}

	public UserDTO findUserByEmail(Map<String, String> params) {
		return sqlSession.selectOne("findUserByEmail", params);
	}

	public UserDTO findUserBySocial(Map<String, String> params) {
		return sqlSession.selectOne("findUserBySocial", params);
	}

	// 남아있는 내역있는지 확인(등록된 숙소에 남은 예약(예약완료,이용중))
	public int checkRemainsHouse(String user_id) {
		return sqlSession.selectOne("checkRemainsHouse", user_id);
	}

	// 남아있는 내역있는지 확인(이용완료 안된 숙소)
	public int checkRemainsGuest(String user_id) {
		return sqlSession.selectOne("checkRemainsGuest", user_id);
	}

	public int updateUser(UserDTO dto) {
		return sqlSession.update("updateUser", dto);
	}

	public int enableUser(Map<String, String> params) {
		return sqlSession.update("enableUser", params);
	}

	public int enableChangeY(Map<String, String> params) {
		return sqlSession.update("enableChangeY", params);
	}

	public int deleteUser(String user_id) {
		return sqlSession.delete("deleteUser", user_id);
	}

	public int getUserCount() {
		return sqlSession.selectOne("getUserCount");
	}

	public int socailJoinCheck(Map<String, String> params) {
		return sqlSession.update("socailJoinCheck", params);
	}

	// 페이징 처리를 위한 쿼리문 변경
	public List<UserDTO> listAllUser(Map<String, Object> params) {
		List<UserDTO> list = sqlSession.selectList("listAllUser", params);
		return list;
	}

	public List<UserDTO> findUserType(Map<String, Object> params) {
		List<UserDTO> list = sqlSession.selectList("findUserType", params);
		return list;
	}

	public int getSearchCount(Map<String, Object> params) {
		int count = sqlSession.selectOne("getSearchCount", params);
		return count;
	}

}
