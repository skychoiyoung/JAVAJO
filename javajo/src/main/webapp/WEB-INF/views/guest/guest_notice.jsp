<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ include file="guest_top.jsp" %>
    <!-- s: content -->
    <section id="notice_list" class="content">
        <div class="notice_wrap">
        	<div class="noti_tit-box">
                <p class="noti_tit">공지사항</p>
            </div>
            <table class="noti_list j_table">
                <thead>
                    <tr>
                        <th class="noti_num">No</th>
                        <th class="noti_tit">제목</th>
                        <th class="noti_writer">작성자</th>
                        <th class="noti_date">등록일</th>
                    </tr>
                </thead>
                <tbody>
                	<c:if test="${empty noticeList}">
                		<tr>
                			<td colspan="4">등록된 공지사항이 없습니다.</td>
                		</tr>
                	</c:if>
                	<c:forEach var="dto" items="${noticeList}" varStatus="status">
	                    <tr>
	                        <td class="noti_num">${no - status.index}</td>
	                        <td class="noti_tit"><a href="notice_cont.do?notice_num=${dto.notice_num}">${dto.notice_title}</a></td>
	                        <td class="noti_writer">${dto.user_id}</td>                        
	                        <!--  <td class="qna_date">${dto.notice_date}"</td> -->
	                        <td class="noti_date">
		                        <c:set var="parsedDate" value="${dto.notice_date}" />	                       
							    <fmt:parseDate var="date" value="${parsedDate}" pattern="yyyy-MM-dd HH:mm:ss" />
							    <fmt:formatDate value="${date}" pattern="yyyy-MM-dd" />						    
							</td>
	                    </tr>
                    </c:forEach>
                </tbody>
                
            </table>
        </div>
      	<!-- 페이징 -->
        <div class="pagination">
		    <c:if test="${startPage > pageBlock}"> 
		        <a class="page_btn prev_btn" href="notice.do?pageNum=${startPage-3}"><img src="resources/images/main/arrow.png" alt="" /></a>
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
		        <a href="notice.do?pageNum=${i}" class="${activeClass} page_num">${i}</a>
		    </c:forEach>
		    
		    <c:if test="${pageCount > endPage}">
		        <a class="page_btn next_btn" href="notice.do?pageNum=${startPage+3}"><img src="resources/images/main/arrow.png" alt="" /></a>
		    </c:if>
		</div>
    </section>
    <!-- e: content -->
<%@ include file="guest_bottom.jsp" %>