<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %> 
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %> 
 
<c:set var="choiceYear1" value=""/><c:set var="choiceYear2" value=""/>
<c:set var="choiceMonth1" value=""/><c:set var="choiceMonth2" value=""/>
<%@ include file="house_top.jsp" %> 
  	<section id="host_paymanage" class="content">	
		<div class="paymanage_tit-box">	
			 <p class="paymanage_tit">정산관리</p>
		 </div>
	  	 <div class="paymanage_search">		 		 
			<form name="f" action="moneyManage.do?mode=money" method="post">
				<input type="hidden" name="choiceDay1" value="${choiceDay1}"/>
				<input type="hidden" name="choiceDay2" value="${choiceDay2}"/>
				
				<div class="search_wrap">
					<div class="search_box">
						<c:if test="${empty param.mode}">		
						<label for="pay_day">결제연월
							<select name="year_choice1" id="yearSelect1" onchange="updateMonthOptions(1)">
							    <option value="all">연도 선택</option>
							    <c:forEach var="year" items="${years}">
							        <option value="${year}">${year}년</option>					        	
							    </c:forEach>
							</select>		
							<select name="month_choice1" id="monthSelect1">
							    <option value="all">월 선택</option>    
							    <c:forEach begin="1" end="12" var="month">
							        <option value="${month}">${month}월</option>					        	
							    </c:forEach>
							</select>
							~
							<select name="year_choice2" id="yearSelect2" onchange="updateMonthOptions(2)">
							    <option value="all">연도 선택</option>
							    <c:forEach var="year" items="${years}">
							        <option value="${year}">${year}년</option>
							    </c:forEach> 
							</select>					
							<select name="month_choice2" id="monthSelect2">
							    <option value="all">월 선택</option>
							    <c:forEach begin="1" end="12" var="month">
							        <option value="${month}">${month}월</option>
							    </c:forEach> 
							</select>
						</label>
						</c:if>
						
						<c:if test="${not empty param.mode}">		
						<label for="pay_day">결제연월
							<select name="year_choice1" id="yearSelect1" onchange="updateMonthOptions(1)">
							    <option value="all">연도 선택</option>
							    <c:forEach var="year" items="${years}">
							        <option value="${year}" ${sort1 == year ? 'selected' : ''}>
		        						${year}년</option>				        	
							    </c:forEach>
							</select>		
							<select name="month_choice1" id="monthSelect1">
							    <option value="all">월 선택</option>    
							    <c:forEach begin="1" end="12" var="month">
							        <option value="${month}" ${sort2 == month ? 'selected' : ''}>
							        	${month}월</option>
							    </c:forEach>
							</select>
							~
							<select name="year_choice2" id="yearSelect2" onchange="updateMonthOptions(2)">
							    <option value="all">연도 선택</option>
							    <c:forEach var="year" items="${years}">
							        <option value="${year}" ${sort3 == year ? 'selected' : ''}>
							       		 ${year}년</option>
							    </c:forEach> 
							</select>
							
							<select name="month_choice2" id="monthSelect2">
							    <option value="all">월 선택</option>
							    <c:forEach begin="1" end="12" var="month">
							        <option value="${month}" ${sort4 == month ? 'selected' : ''}>
							       		 ${month}월</option>
							    </c:forEach> 
							</select>
						</label>
						</c:if>
						<button class="paymanage_btn" type="button" onclick="checkDay()">검색</button>
					</div>
					<p class = "totprice">총 수입 <fmt:formatNumber value="${totalPrice}" pattern="###,###"/>원</p>	
				</div>
				<table class="paymanage_list j_table">
					<thead>
		 				<tr>
							<th class="paymanage_date" style="width: 20%;">결제일시</th>
							<th class="paymanage_pdt">숙소명</th>
							<th class="paymanage_in" style="width: 15%;">체크인</th>
							<th class="paymanage_out" style="width: 15%;">체크아웃</th>
							<th class="paymanage_guest" style="width: 10%;">결제유형</th>
							<th class="paymanage_price">결제금액</th>					
						</tr>
					</thead>
					
				<c:if test="${empty param.mode}">
					<tbody>
						<c:if test="${empty paylistHouse}">
							<tr>
								<td colspan="6">선택하신 기간에 결제내역이 없습니다. </td>
							</tr>
						</c:if>	
						<c:if test="${not empty paylistHouse}">			
						<c:forEach var="dto" items="${paylistHouse}">
							<tr>
								<td class="paymanage_date">${dto.reserv_date}</td>
								<td class="paymanage_pdt">${dto.house_name}</td>
								<td class="paymanage_in">${dto.reserv_checkin}</td>
								<td class="paymanage_out">${dto.reserv_checkout}</td>
								<td class="paymanage_guest">${dto.reserv_paytype}</td>
								<td class="paymanage_price"><fmt:formatNumber value="${dto.reserv_pay}" pattern="###,###"/>원</td>															
							</tr>
						</c:forEach>
						</c:if>
					</tbody>
				</c:if>
				
				<c:if test="${not empty param.mode}">
					<tbody>
						<c:if test="${empty paylistHouse}">
							<tr>
								<td colspan="6" height = "10">선택하신 기간에 결제내역이 없습니다. </td>
							</tr>
						</c:if>	
						<c:if test="${not empty paylistHouse}">			
						<c:forEach var="dto" items="${paylistHouse}">
							<tr>
								<td class="paymanage_date">${dto.reserv_date}</td>
								<td class="paymanage_pdt">${dto.house_name}</td>
								<td class="paymanage_in">${dto.reserv_checkin}</td>
								<td class="paymanage_out">${dto.reserv_checkout}</td>
								<td class="paymanage_guest">${dto.reserv_paytype}</td>
								<td class="paymanage_price"><fmt:formatNumber value="${dto.reserv_pay}" pattern="###,###"/>원</td>															
							</tr>
						</c:forEach>
						</c:if>
					</tbody>
				</c:if>
	 			</table>
	        	<!-- 페이징 -->
	        	<div class="pagination">
				    <c:if test="${startPage > pageBlock}"> 
				        <a class="page_btn prev_btn" href="moneyManage.do?pageNum=${startPage-3}"><img src="resources/images/main/arrow.png" alt="" /></a>
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
				        <a href="moneyManage.do?pageNum=${i}" class="${activeClass} page_num">${i}</a>
				    </c:forEach>
				    
				    <c:if test="${pageCount > endPage}">
				        <a class="page_btn next_btn" href="moneyManage.do?pageNum=${startPage+3}"><img src="resources/images/main/arrow.png" alt="" /></a>
				    </c:if>
				</div>
			</form>
		</div>	
	 </section>
<%@ include file="house_bottom.jsp" %>

	<script type="text/javascript">
		function checkDay() {	// 날짜 선택 체크검사		
		
		var year1 = document.getElementById("yearSelect1").value;
	    var month1 = document.getElementById("monthSelect1").value;
	    var year2 = document.getElementById("yearSelect2").value;
	    var month2 = document.getElementById("monthSelect2").value;	
	    var startDate = new Date(year1, month1 - 1, 1);
	    var endDate = new Date(year2, month2 - 1, 1);
	    
		if (year1 == "all") {
			alert("연도를 선택해주세요.");
			return false;
			}
		if (month1 == "all") {
			alert("월을 선택해주세요.");
			return false;
		}
		if (year2 == "all") {
			alert("연도를 선택해주세요.");
			return false;
		}		
		if (month2 == "all") {
			alert("월을 선택해주세요.");
			return false;
		}
		
		if (endDate < startDate) {
	        alert("선택하신 기간은 조회가 불가합니다. 결제연월을 다시 확인해주세요!");
	        return false;
	    }
		
			document.f.submit();
		}
	</script>
	<script type="text/javascript">			            
			    function update(selectNumber) { // select한 년, 월 값을 변수에 저장하기
			    	var yearSelect = document.getElementById("yearSelect" + selectNumber);
			        var monthSelect = document.getElementById("monthSelect" + selectNumber);
			
			        if (selectNumber === 1) {
			            var firstyear = yearSelect.value; 
			            var firstmonth = monthSelect.value; 
			          	var year1 = firstyear.replace("년", "");
			           	var month1 = firstmonth.replace("월", "");
			           	var choiceDay1 = year1 + "-" + month1
			            
			        }else if (selectNumber === 2) {
			        	 var secondyear = yearSelect.value; 
			             var secondmonth = monthSelect.value; 
			             var year2 = secondyear.replace("년", "");
			           	 var month2 = secondmonth.replace("월", ""); 
			           	 var choiceDay2 = year2 + "-" + month2
			        }
			        document.f.submit()
			    }
	</script>