<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ include file="house_top.jsp" %>     
	<section id="house_manage" class="content">
		<div class="manage_box">
			<div class="tit_box">
				<p>숙소관리</p>
				<button class = "add_house" type="button" onclick="window.location='insertHouse.do'">숙소 등록</button>															
			</div>
			<ul class="house_list">
				<c:if test="${empty listHouse}">
				<li class="house_tit">등록된 숙소가 없습니다. 숙소를 등록해 주세요!</li>
				</c:if>
				<c:forEach var="dto" items="${listHouse}">
				<li class="house_items">
					<a href="house_Hinfo.do?house_num=${dto.house_num}">
						<div class="house_img">
							<img src="resources/upload_house_images/${dto.house_image1}">				
						</div>						
					<div class="tit_box">
						<p class="house_tit">${dto.house_name}</p>
					</div>
					</a>
				</li>
				</c:forEach>
			</ul>
		 </div>
	 </section>
<%@ include file="house_bottom.jsp" %> 