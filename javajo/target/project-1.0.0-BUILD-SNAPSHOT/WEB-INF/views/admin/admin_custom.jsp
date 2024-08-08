<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file="admin_top.jsp" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
	<style>
		#admin_top .admin_link li:nth-child(3) {color: #38B341; border-bottom: 1px solid #38B341;}
	</style>
    <!-- s: content -->
    <section id="admin_custom" class="content">
        <div class="notice_wrap">
            <div class="noti_tit-box">
                <p class="noti_tit">고객문의</p>
            </div>
            <table class="noti_list j_table">
                <thead>
                    <tr>
                        <th class="noti_num" style="width: 7%;">No</th>
                        <th class="noti_type" style="width: 18%;">문의유형</th>
                        <th class="noti_tit">제목</th>
                        <th class="noti_writer" style="width: 10%;">문의자</th>
                        <th class="noti_date" style="width: 18%;">등록일</th>
                        <th class="noti_status">상태</th>
                    </tr>
                </thead>
                <tbody>
                <c:if test="${empty listAdminQna}">
                		<td colspan="5">등록된 게시글이 없습니다.</td>
                	</c:if>  
				<c:if test="${not empty listAdminQna}">
                	<c:forEach var="dto" items="${listAdminQna}" varStatus="status">
                    <tr>
                        <td class="noti_num">${no-status.index}</td>
                        <td class="noti_type" style="width: 18%;">${dto.adminqna_type}</td>
                        <td class="noti_tit"><a href="custom_noti.do?adminqna_num=${dto.adminqna_num}">${dto.adminqna_title}</a></td>
                        <td class="noti_writer">${dto.user_id}</td>
                        <td class="noti_date">${fn:substring(dto.adminqna_date, 0, 10)}</td>
                        <td class="noti_status">${dto.adminqna_status}</td>
                    </tr>
                    </c:forEach>
                </c:if>
                </tbody>
             </table>
             <!-- 페이징 -->
			<div class="pagination">
			    <c:if test="${startPage > pageBlock}"> 
			        <a class="page_btn prev_btn" href="customer_qna.do?pageNum=${startPage-3}"><img src="resources/images/main/arrow.png" alt="" /></a>
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
			        <a href="customer_qna.do?pageNum=${i}" class="${activeClass} page_num">${i}</a>
			    </c:forEach>
			    
			    <c:if test="${pageCount > endPage}">
			        <a class="page_btn next_btn" href="customer_qna.do?pageNum=${startPage+3}"><img src="resources/images/main/arrow.png" alt="" /></a>
			    </c:if>
			</div>
        </div>
    </section>
    <!-- e: content -->

<%@ include file="admin_bottom.jsp" %>