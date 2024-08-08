<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ include file="guest_top.jsp" %>
<!-- s: content -->
<section id="review_all" class="content">
    <div class="tit_box">
        <p>숙소 리뷰</p>
    </div>
    <ul class="review_list">
    	<c:if test="${empty reviewAll}">
    	<li style="padding: 20px; 0"><p style="margin: 0 auto; font-size: 26px; text-align: center;">현재 숙소에 등록된 리뷰가 없습니다.</p></li>
    	</c:if>
    	<c:forEach var="list" items="${reviewAll}">
        <li class="review_items">
        	<div class="review_img">
	        <c:choose>
	            <c:when test="${empty list.review_image}">
            		<img src="resources/images/upload_guestReview/default_review.png" alt=""/>
	            </c:when>
	            <c:when test="${not empty list.review_image}">
	            	<img src="resources/upload_guestReview/${list.review_image}" alt=""/>
	            </c:when>
	       	</c:choose>
	       	</div>
            <div class="review_txt">
                <p class="review_tit">${list.user_id}</p>
                <p class="review_date">${list.review_date}</p>
                <div class="review_grade">
                <c:forEach var="star" begin="1" end="${list.review_score}">
                	<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 32 32" aria-hidden="true" role="presentation" focusable="false" style="display: block; height: 0.5625rem; width: 0.5625rem; fill: var(--linaria-theme_palette-hof);"><path fill-rule="evenodd" d="m15.1 1.58-4.13 8.88-9.86 1.27a1 1 0 0 0-.54 1.74l7.3 6.57-1.97 9.85a1 1 0 0 0 1.48 1.06l8.62-5 8.63 5a1 1 0 0 0 1.48-1.06l-1.97-9.85 7.3-6.57a1 1 0 0 0-.55-1.73l-9.86-1.28-4.12-8.88a1 1 0 0 0-1.82 0z"></path></svg>
				</c:forEach>
                </div>
                <textarea cols="60" rows="10" maxlength="200" wrap="hard" readonly>${list.review_content}</textarea>
            </div>
        </li>
    	</c:forEach>
    </ul>
    <!-- 페이징 -->
    <div class="pagination">
	    <c:if test="${currentPage > 3}">
	        <a class="page_btn prev_btn" href="review_all.do?house_num=${house_num}&page=${currentPage - 3}">
	            <img src="resources/images/main/arrow.png" alt="" />
	        </a>
	    </c:if>
	
	    <c:forEach var="i" begin="${startPage}" end="${endPage}">
	        <a href="review_all.do?house_num=${house_num}&page=${i}" class="${i == currentPage ? 'p_active' : ''} page_num">
	            <c:out value="${i}"/>
	        </a>
	    </c:forEach>
	
	    <c:if test="${currentPage < totalPages && endPage < totalPages}">
	        <a class="page_btn next_btn" href="review_all.do?house_num=${house_num}&page=${currentPage + 3}">
	            <img src="resources/images/main/arrow.png" alt="" />
	        </a>
	    </c:if>
	</div>
</section>
<!-- e: content -->
<%@ include file="guest_bottom.jsp" %>