<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ include file="admin_top.jsp" %>
	<style>
		#admin_top .admin_link li:nth-child(1) {color: #38B341; border-bottom: 1px solid #38B341;}
	</style>
    <section id="admin_user" class="content">
        <div class="notice_wrap">
   			<div class="noti_tit-box">
   				<p class="noti_tit">회원조회</p>
   			</div>     
        <form action="find_user.do" method="get" id="searchUser">
        	<div class="noti_search">
        	<select name="search">
                <option value="user_id" ${param.search == 'user_id' ? 'selected' : ''}>아이디</option>
                <option value="user_loginType" ${param.search == 'user_loginType' ? 'selected' : ''}>유형</option>
            </select>
                <input type="text" name="searchString" value="${param.searchString}">
                <label for="userEnable">
                	탈퇴회원 포함 <input id="userEnable" type="checkbox" name="userEnable" value="checked" ${param.userEnable == 'checked' ? 'checked' : ''}>
                </label>
		        <input type="submit" value="검색">
        	</div>
        </form>
       
        <table class="noti_list j_table">
        	<thead>
            <tr>
                <th class="noti_date" style="width: 18%;">가입일시</th>
                <th class="noti_id" style="width : 12%;">아이디</th>
                <th class="noti_name" style="width : 12%;">회원명</th>
                <th class="noti_tel">핸드폰번호</th>
                <th class="noti_email">이메일주소</th>
                <th class="noti_type">유형</th>
                <th class="noti_enable">탈퇴여부</th>
            </tr>
            </thead>
            
            <tbody> 
            <c:if test="${empty listUser && empty findUser}">
            	<td colspan="7">등록된 회원이 없습니다.</td>
            </c:if>
            <c:if test="${empty findUser}">
	            <c:forEach var="dto" items="${listUser}">
	            	<tr>
	            		<td class="noti_date">${dto.user_joindate}</td>
		                <td class="noti_id">${dto.user_id}</td>
		                <td class="noti_name">${dto.user_name}</td>
		                <td class="noti_tel">${dto.user_hp1} - ${dto.user_hp2} - ${dto.user_hp3}</td>
		                <td class="noti_email">${dto.user_email1} @ ${dto.user_email2}</td>
	            		<td class="noti_type">${dto.user_loginType}</td>
	            		<c:choose>
						    <c:when test="${dto.user_enable eq 'Y'}">
						        <td class="noti_enable">-</td>
						    </c:when>
						    <c:when test="${dto.user_enable eq 'N'}">
						        <td class="noti_enable"><img src="resources/images/main/drop_member.png" alt=""></td>
						    </c:when>
						</c:choose>
	            	</tr>
	            </c:forEach>
            </c:if>
            <c:if test="${not empty findUser}">
	            <c:forEach var="fdto" items="${findUser}">
	            	<tr>
	            		<td class="noti_date">${fdto.user_joindate}</td>
		                <td class="noti_id">${fdto.user_id}</td>
		                <td class="noti_name">${fdto.user_name}</td>
		                <td class="noti_tel">${fdto.user_hp1} - ${fdto.user_hp2} - ${fdto.user_hp3}</td>
		                <td class="noti_email">${fdto.user_email1} @ ${fdto.user_email2}</td>
	            		<td class="noti_type">${fdto.user_loginType}</td>
	            		<c:choose>
						    <c:when test="${fdto.user_enable eq 'Y'}">
						        <td class="noti_enable">-</td>
						    </c:when>
						    <c:when test="${fdto.user_enable eq 'N'}">
						        <td class="noti_enable"><img src="resources/images/main/drop_member.png" alt=""></td>
						    </c:when>
						</c:choose>
	            	</tr>
	            </c:forEach>
            </c:if>
            </tbody>
        </table>
        <c:if test="${empty findUser}">
        <div class="pagination">
		    <c:if test="${startPage > pageBlock}"> 
		        <a class="page_btn prev_btn" href="list_user.do?pageNum=${startPage-3}&search=${param.search}&searchString=${param.searchString}&userEnable=${param.userEnable}">
		        	<img src="resources/images/main/arrow.png" alt="" />
		        </a>
		    </c:if>
		    
		    <c:forEach var="i" begin="${startPage}" end="${endPage}">
		        <c:set var="activeClass" value=""/>
		        <c:choose>
		            <c:when test="${empty param.pageNum and i == 1}">
		                <c:set var="activeClass" value="p_active"/>
		            </c:when>
		            <c:when test="${param.pageNum == i}">
		                <c:set var="activeClass" value="p_active"/>
		            </c:when>
		        </c:choose>
		        <a href="list_user.do?pageNum=${i}&search=${param.search}&searchString=${param.searchString}&userEnable=${param.userEnable}" class="${activeClass} page_num">${i}</a>
		    </c:forEach>
		    
		    <c:if test="${pageCount > endPage}">
		        <a class="page_btn next_btn" href="list_user.do?pageNum=${startPage+3}&search=${param.search}&searchString=${param.searchString}&userEnable=${param.userEnable}"><img src="resources/images/main/arrow.png" alt="" /></a>
		    </c:if>
		</div>
		</c:if>
		<c:if test="${!empty findUser}">
        <div class="pagination">
		    <c:if test="${startPage > pageBlock}"> 
		        <a class="page_btn prev_btn" href="find_user.do?pageNum=${startPage-3}&search=${param.search}&searchString=${param.searchString}&userEnable=${param.userEnable}">
		        	<img src="resources/images/main/arrow.png" alt="" />
		        </a>
		    </c:if>
		    
		    <c:forEach var="i" begin="${startPage}" end="${endPage}">
		        <c:set var="activeClass" value=""/>
		        <c:choose>
		            <c:when test="${empty param.pageNum and i == 1}">
		                <c:set var="activeClass" value="p_active"/>
		            </c:when>
		            <c:when test="${param.pageNum == i}">
		                <c:set var="activeClass" value="p_active"/>
		            </c:when>
		        </c:choose>
		        <a href="find_user.do?pageNum=${i}&search=${param.search}&searchString=${param.searchString}&userEnable=${param.userEnable}" class="${activeClass} page_num">${i}</a>
		    </c:forEach>
		    
		    <c:if test="${pageCount > endPage}">
		        <a class="page_btn next_btn" href="find_user.do?pageNum=${startPage+3}&search=${param.search}&searchString=${param.searchString}&userEnable=${param.userEnable}"><img src="resources/images/main/arrow.png" alt="" /></a>
		    </c:if>
		</div>
		</c:if>
    </section>    
<%@ include file="admin_bottom.jsp" %>