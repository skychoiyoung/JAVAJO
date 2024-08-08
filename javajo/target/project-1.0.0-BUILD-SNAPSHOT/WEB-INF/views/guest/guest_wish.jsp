<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ include file="guest_top.jsp" %>
    <!-- s: content -->
    <section id="wish_all" class="content">
        <div class="wish_wrap">
            <div class="tit_box">
            	<p>위시리스트</p>
        	</div> 
        	<c:if test="${empty wishList}">
        		<p style="margin: 50px auto; font-size: 26px; text-align: center;">위시리스트에 등록된 숙소가 존재하지 않습니다.</p>
        	</c:if>
        	<c:if test="${!empty wishList}">
        		<ul class="wish_list">
        		<c:forEach var="dto" items="${wishList}">
       				<li class="wish_items">
		                <a href="house_info.do?house_num=${dto.house_num}"><img src="resources/upload_house_images/${dto.house_image1}" alt="숙소사진"/></a>
		                <div class="wish_txt">
		                    <p class="wish_tit"><span>숙소</span>${dto.house_name}</p>
		                    <p class="wish_addr"><span>주소</span>${dto.house_addr}</p>
		                    <p class="wish_price"><span>금액</span><fmt:formatNumber value="${dto.house_price}" pattern="###,###"/>원/박</p>
		                    <a href="wish_del.do?house_num=${dto.house_num}"><img src="resources/images/main/like.png" alt=""/></a>
		                </div>
		            </li>
	        	</c:forEach>
	        	</ul>
	        </c:if>
	    </div>
    </section>
    <!-- e: content -->
<%@ include file="guest_bottom.jsp" %>