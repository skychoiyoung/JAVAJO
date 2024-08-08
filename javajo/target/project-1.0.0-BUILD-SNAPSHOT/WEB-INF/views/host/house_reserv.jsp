<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %> 
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ include file="house_top.jsp" %>

	<section id="host_reserve" class="content">
		<div class="reserve_tit-box">
			<p class="reserve_tit">예약내역</p>
		</div>	
			<div class="reserve_search"> 	
			<form name="f" action="reservHouse.do?mode=status" method="post">												
				<c:if test="${empty param.mode}">
					<span>숙소명</span>
						<select name="house_num" class = "housename">
							<option value="all">전체						
							<c:forEach var ="namedto" items="${listHouse}">
								<option value="${namedto.house_num}">${namedto.house_name}							
							</c:forEach>
						</select>
					
				 	<span>예약상태</span>
						<select id="idt_name" name="reserv_status" class = "status">							
							<option value="all">전체</option>
							<option value="wait">결제완료</option>
							<option value="use">이용중</option>
							<option value="finish">이용완료</option>				
							<option value="cancel">예약취소</option>					
						</select>
					
					<button class="reserve_btn" type="submit">검색</button>
				</c:if>	
				
				<c:if test="${not empty param.mode}">
					<span>숙소명</span>
					<select name="house_num" class = "housename">
							<option value="all" ${sort1 == 'all' ? 'selected' : ''}>전체</option> 
						<c:forEach var ="namedto" items="${listHouse}">
							<option value="${namedto.house_num}" 
							${sort1 == namedto.house_name ? 'selected' : ''}>${namedto.house_name}						
							</option>
						</c:forEach> 
					</select>
									 		
					<span>예약상태</span>
					<select name="reserv_status" class = "status">
						<option value="all" ${sort2 == 'all' ? 'selected' : ''}>전체</option> 
						<option value="wait" ${sort2 == 'wait' ? 'selected' : ''}>결제완료</option>
						<option value="use" ${sort2 == 'use' ? 'selected' : ''}>이용중</option>
						<option value="finish" ${sort2 == 'finish' ? 'selected' : ''}>이용완료</option>			
						<option value="cancel" ${sort2 == 'cancel' ? 'selected' : ''}>예약취소</option>					
					</select>
					<button class="reserve_btn" type="submit">검색</button>	
				</c:if>	 					
										
				<table class="reserve_list j_table">
					<thead>
						<tr>
							<th class="reserv_index" style="width: 4%;">No</th>
							<th class="reserv_num" style="width: 7%;">예약번호</th>
							<th class="reserv_date" style="width: 10%;">예약일</th>							
							<th class="reserve_pdt">숙소명</th>
							<th class="reserve_in" style="width: 14%;">체크인</th>
							<th class="reserve_out" style="width: 14%;">체크아웃</th>
							<th class="reserve_guest" style="width: 11%;">예약자 아이디</th>	
							<th class="reserve_per" style="width: 7%;">예약인원</th>
							<th class="reserve_price" style="width: 10%;">이용금액</th>
							<th class="reserve_state" style="width: 8%;">예약상태</th>
						</tr>
					</thead>
					
					<c:if test="${empty param.mode}">
						<c:if test="${empty reservList}">
							<tbody>
								<tr>
									<td colspan="10" class="reserve_pdt">조회하신 예약내역이 없습니다. </td>
								</tr>
							</tbody>
						</c:if >
						
						<!--검색 버튼클릭, 전체-전체 검색 시 -->
						<c:if test="${not empty reservList}">
							<tbody>
								<c:forEach var="dto" items="${reservList}" varStatus="status">
								<tr>
									<td class="reserv_index">${no-status.index}</td>
									<td class="reserv_num">${dto.reserv_num}</td>
									<td class="reserv_date">${fn:substring(dto.reserv_date, 0, 10)}</td>
									<td class="reserve_pdt">${dto.house_name}</td>
									<td class="reserve_in">${dto.reserv_checkin}</td>
									<td class="reserve_out">${dto.reserv_checkout}</td>
									<td class="reserve_guest">${dto.user_id}</td>
									<td class="reserve_per">${dto.reserv_person}명</td>
									<td class="reserve_price"><fmt:formatNumber value="${dto.reserv_pay}" pattern="###,###"/>원</td>
									<td class="reserve_state">${dto.reserv_status}</td>
								</tr>
								</c:forEach>
							</tbody><br>
						</c:if>
					</c:if>
						
					<c:if test="${not empty param.mode}">
						<c:if test="${empty reservList}">
								<tbody>
									<tr>
										<td colspan="10" class="reserve_pdt">조회하신 예약내역이 없습니다.</td>
									</tr>
								</tbody>
						</c:if >
						
						<c:if test="${not empty reservList}">				
							<c:forEach var="dto" items="${reservList}" varStatus="status">
								<tbody>
									<tr>
										<td class="reserv_num">${no-status.index}</td>
										<td class="reserv_num">${dto.reserv_num}</td>
										<td class="reserv_date">${fn:substring(dto.reserv_date, 0, 10)}</td>
										<td class="reserve_pdt">${dto.house_name}</td>
										<td class="reserve_in">${dto.reserv_checkin}</td>
										<td class="reserve_out">${dto.reserv_checkout}</td>
										<td class="reserve_guest">${dto.user_id}</td>
										<td class="reserve_per">${dto.reserv_person}명</td>
										<td class="reserve_price"><fmt:formatNumber value="${dto.reserv_pay}" pattern="###,###"/>원</td>
										<td class="reserve_state">${dto.reserv_status}</td>
									</tr>
								</tbody>
							</c:forEach>					
						</c:if>						
					</c:if>					
				</table>
				
				<c:if test="${empty param.mode}">
					<c:if test="${empty reservList}">
					</c:if>
					<c:if test="${not empty reservList}">
						<!-- 페이징 -->
						<div class="pagination">
						    <c:if test="${startPage > pageBlock}"> 
						        <a class="page_btn prev_btn" href="reservHouse.do?pageNum=${startPage-3}"><img src="resources/images/main/arrow.png" alt="" /></a>
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
						        <a href="reservHouse.do?pageNum=${i}" class="${activeClass} page_num">${i}</a>
						    </c:forEach>
						    
						    <c:if test="${pageCount > endPage}">
						        <a class="page_btn next_btn" href="reservHouse.do?pageNum=${startPage+3}"><img src="resources/images/main/arrow.png" alt="" /></a>
						    </c:if>
						</div>
					</c:if>
				</c:if>	
					
				<c:if test="${not empty param.mode}">
					<c:if test="${empty reservList}">	
					</c:if>
					<c:if test="${not empty reservList}">
						<!-- 페이징 -->
						<div class="pagination">
						    <c:if test="${startPage > pageBlock}"> 
						        <a class="page_btn prev_btn" href="reservHouse.do?mode=status&pageNum=${startPage-3}&house_num=${house_num}&reserv_status=${sort2}"><img src="resources/images/main/arrow.png" alt="" /></a>
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
						        <a href="reservHouse.do?mode=status&pageNum=${i}&house_num=${house_num}&reserv_status=${sort2}" class="${activeClass} page_num">${i}</a>
						    </c:forEach>
						    
						    <c:if test="${pageCount > endPage}">
						        <a class="page_btn next_btn" href="reservHouse.do?mode=status&pageNum=${startPage+3}&house_num=${house_num}&reserv_status=${sort2}"><img src="resources/images/main/arrow.png" alt="" /></a>
						    </c:if>
						</div>
					</c:if>
				</c:if>
		</form>			 
	 </div>
	</section>
<%@ include file="house_bottom.jsp" %>
	 