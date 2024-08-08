<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file="admin_top.jsp" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %> <!-- 숫자 포맷팅 할 때 필요 -->
	<style>
		#admin_top .admin_link li:nth-child(4) {color: #38B341; border-bottom: 1px solid #38B341;}
	</style>
	<!-- s: content -->
    <section id="admin_account" class="content">
        <div class="account_wrap">
            <div class="acct_tit-box">
                <p class="acct_tit">정산관리</p>
            </div>
            <div class="account_inner_wrap">
	            <div class="search_box_wrap">
	            	<div class="account_box">
	                    <select id="search" name="search">
	                        <option value="year" ${param.search == 'year' ? 'selected' : ''}>연도별</option>
	                        <option value="period" ${param.search == 'period' ? 'selected' : ''}>기간별</option>
	                        <option value="month" ${param.search == 'month' ? 'selected' : ''}>월별</option>
	                    </select>
	                </div>
	    			
	                <div id="account_year" class="search_box" data-type="year">
	                   <form name="f" action="settlement_manage_year.do" method="post">
	                   		<input type="hidden" name="search" value="${param.search}" id="search_year">     
	                        <p class="period_tit">연도별</p>
	                        <div class="year_box">
	                            <img class="minus_btn" src="resources/images/main/left_arrow.png" alt="" />
	                            <input class="year_value" type="text" name="searchYear" value="${searchYear}" readonly />
	                            <img class="plus_btn" src="resources/images/main/right_arrow.png" alt="" />
	                        </div>
	                        <button type="submit">검색</button>
	                    </form>
	                    <div class="totAccount_box">
	                    	<c:set var="formattedCharge" value="${totPaycharge != null ? totPaycharge : 0}" />
	                    	<p>총 수수료 수입 <span><fmt:formatNumber value="${formattedCharge}" pattern="#,###" /></span>원</p>
	                    </div>
	                </div>
	
	                <div id="account_period" class="search_box" data-type="period">
	                    <form name="f" action="settlement_manage_period.do" method="post">
	                        <input type="hidden" name="search" value="${param.search}" id="search_period">
	                        <p class="period_tit">기간별</p>
	                        <div class="period_box">
	                            <input class="start_day" type="date" name="startDay" value="${startDay}" required />
	                            -
	                            <input class="end_day" type="date" name="endDay" value="${endDay}" required />
	                        </div>
	                        <button type="submit">검색</button>
	                    </form>
	                    <div class="totAccount_box">
	                    	<c:set var="formattedCharge" value="${totPaycharge_p != null ? totPaycharge_p : 0}" />
	                    	<p>총 수수료 수입 <span><fmt:formatNumber value="${formattedCharge}" pattern="#,###" /></span>원</p>
	                    </div>
	                </div>
	
	                <div id="account_month" class="search_box" data-type="month">
	                    <form name="f" action="settlement_manage_month.do" method="post">
	                    	<input type="hidden" name="search" value="${param.search}" id="search_month">
	                        <p class="period_tit">월별</p>
	                        <div class="year_box">
	                        	<div>
	                        		<img class="minus_btn" src="resources/images/main/left_arrow.png" alt="" />
		                            <input class="year_value" type="text" name="searchYear_m" value="${searchYear_m}" readonly />
		                            <img class="plus_btn" src="resources/images/main/right_arrow.png" alt="" />
	                        	</div>
	                        </div>
	                        <button type="submit">검색</button>
	                    </form>
	                </div>
	            </div>
                
    
                <table class="acct_list j_table">
                    <thead>
                        <!-- 연도별 선택시 보여지는 부분 -->
                        <tr class="thead01">
                            <th class="acct_num" style="width: 6%;">No</th>
                            <th class="acct_date" style="width: 15%;">수익확정일자</th>
                            <th class="acct_pdt">숙소명</th>
                            <th class="acct_paytype" style="width: 12%;">결제유형</th>
                            <th class="acct_total" style="width: 14%;">결제금액</th>
                            <th class="acct_vat" style="width: 13%;">수수료</th>
                        </tr>
                        <!-- 기간별 선택시 보여지는 부분 -->
                        <tr class="thead02">
                            <th class="acct_num" style="width: 6%;">No</th>
                            <th class="acct_date" style="width: 15%;">수익확정일자</th>
                            <th class="acct_pdt">숙소명</th>
                            <th class="acct_paytype" style="width: 12%;">결제유형</th>
                            <th class="acct_total" style="width: 14%;">결제금액</th>
                            <th class="acct_vat" style="width: 13%;">수수료</th>
                        </tr>
                        <!-- 월별 선택시 보여지는 부분 -->
                        <tr class="thead03">
                            <th class="acct_date" style="width: 33%;">결제연월</th>
                            <th class="acct_total" style="width: 33%;">결제금액</th>
                            <th class="acct_vat" style="width: 33%;">수수료</th>
                        </tr>
                    </thead>
                    <tbody class="tbody01">
                        <!-- 연도별 선택시 보여지는 부분 -->
                        <c:if test="${empty listAccount}">
                        	<td colspan="7">데이터가 없습니다.</td>     
                        </c:if>
                        <c:if test="${not empty listAccount}">
                        <c:forEach var="dto" items="${listAccount}" varStatus="status">
                        <tr>
                            <td class="acct_num">${no-status.index}</td>
                            <td class="acct_date">${fn:substring(dto.reserv_checkout, 0, 10)}</td>
                            <td class="acct_pdt">${dto.house_name}</td>
                            <td class="acct_paytype">${dto.reserv_paytype}</td>
                            <td class="acct_total"><fmt:formatNumber value="${dto.reserv_totpay}" pattern="#,###" />원</td>
                            <td class="acct_vat"><fmt:formatNumber value="${dto.reserv_paycharge}" pattern="#,###" />원</td>
                        </tr>
                        </c:forEach>
                        </c:if>
                    </tbody>
                    <tbody class="tbody02">
                        <!-- 기간별 선택시 보여지는 부분 -->
                        <c:if test="${empty listAccount_p}">
                        	<td colspan="7">데이터가 없습니다.</td>     
                        </c:if>
                        <c:if test="${not empty listAccount_p}">
                        <c:forEach var="dto" items="${listAccount_p}" varStatus="status">
                        <tr>
                            <td class="acct_num">${no-status.index}</td>
                            <td class="acct_date">${fn:substring(dto.reserv_checkout, 0, 10)}</td>
                            <td class="acct_pdt">${dto.house_name}</td>
                            <td class="acct_paytype">${dto.reserv_paytype}</td>
                            <td class="acct_total"><fmt:formatNumber value="${dto.reserv_totpay}" pattern="#,###" />원</td>
                            <td class="acct_vat"><fmt:formatNumber value="${dto.reserv_paycharge}" pattern="#,###" />원</td>
                        </tr>
                        </c:forEach>
                        </c:if>
                    </tbody>
                    <tbody class="tbody03">
                        <!-- 월별 선택시 보여지는 부분 -->
                        <c:if test="${empty listAccount_m}">
							<td colspan="4">데이터가 없습니다.</td>                         
                        </c:if>
                        <c:if test="${not empty listAccount_m}"> 
	                        <c:forEach var="dto" items="${listAccount_m}">
	                        <tr class="tbody03">
	                            <td class="acct_date" style="width: 30%;">${dto.reserv_month}</td>
	                            <td class="acct_total" style="width: 30%;"><fmt:formatNumber value="${dto.totalReservPay}" pattern="#,###" />원</td>
	                            <td class="acct_vat" style="width: 30%;"><fmt:formatNumber value="${dto.totalReservPaycharge}" pattern="#,###" />원</td>
	                        </tr>
	                        </c:forEach>
                        </c:if>
                    </tbody>
                </table>
				<!-- 페이징 -->
				<c:if test="${search=='year'}">
					<!-- 연도별 페이징 -->
					<div class="pagination pagination_y">
					    <c:if test="${startPage > pageBlock}"> 
					        <a class="page_btn prev_btn" href="settlement_manage_year.do?pageNum=${startPage-3}&searchYear=${searchYear}"><img src="resources/images/main/arrow.png" alt="" /></a>
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
					        <a href="settlement_manage_year.do?pageNum=${i}&searchYear=${searchYear}" class="${activeClass}  page_num">${i}</a>
					    </c:forEach>
					    
					    <c:if test="${pageCount > endPage}">
					        <a class="page_btn next_btn" href="settlement_manage_year.do?pageNum=${startPage+3}&searchYear=${searchYear}"><img src="resources/images/main/arrow.png" alt="" /></a>
					    </c:if>
					</div>
	        	</c:if>
	        	<c:if test="${search=='period'}">
	        		<!-- 기간별 페이징 -->
					<div class="pagination pagination_p">
					    <c:if test="${startPage > pageBlock}"> 
					        <a class="page_btn prev_btn" href="settlement_manage_period.do?pageNum=${startPage-3}&search=${param.search}&startDay=${startDay}&endDay=${endDay}"><img src="resources/images/main/arrow.png" alt="" /></a>
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
					        <a href="settlement_manage_period.do?pageNum=${i}&search=${param.search}&startDay=${startDay}&endDay=${endDay}" class="${activeClass} page_num">${i}</a>
					    </c:forEach>
					    
					    <c:if test="${pageCount > endPage}">
					        <a class="page_btn next_btn" href="settlement_manage_period.do?pageNum=${startPage+3}&search=${param.search}&startDay=${startDay}&endDay=${endDay}"><img src="resources/images/main/arrow.png" alt="" /></a>
					    </c:if>
					</div>
				</c:if>
            </div>
        </div>
    </section>
    <!-- e: content -->
<%@ include file="admin_bottom.jsp" %>
<script type="text/javascript">
	console.log($("input[name='searchYear']").val())

    // select - option    
    let selectBtn = $("#admin_account .account_box select");
    selectBtn.on('change', function() {
        let selectedType = $(this).find('option:selected').val();
        // 해당하는 검색박스가 나옴
        $(".search_box").each(function() {
            if ($(this).data('type') === selectedType) {
                $(this).show();
            } else {
                $(this).hide();
            }
        });
        // 선택된 타입에 맞는 테이블 컬럼이 나옴
        if (selectedType === 'year') {
            $(".thead01, .tbody01, .pagination_y").show();
            $(".thead02, .tbody02, .thead03, .tbody03").hide();
        } else if (selectedType === 'period') {
        	$(".thead01, .tbody01, .thead03, .tbody03, .pagination_y").hide();
            $(".thead02, .tbody02, .pagination_p").show();
        } else if (selectedType === 'month') {
        	$(".thead01, .tbody01, .thead02, .tbody02 ,.pagination_y, .pagination_p").hide();
            $(".thead03, .tbody03").show();
        }
	     // 선택된 search 값을 각 form의 hidden input에 설정
	        $('#search_year').val(selectedType);
	        $('#search_period').val(selectedType);
	        $('#search_month').val(selectedType);
	     // 총 수수료 수입 업데이트
	        updateTotalRevenue(selectedType);
    });
    selectBtn.trigger('change');

    // 총 수수료 수입 업데이트하는 메소드 
    function updateTotalRevenue(type){
    	let totalRevenue = 0;
    	if(type === 'year'){
    		totalRevenue = "${totPaychargeYear != null ? totPaychargeYear : 0}";
    	}else if(type === 'period'){
    		totalRevenue = "${totPaycharge != null ? totPaycharge : 0}";
    	}else if(type === 'month'){
    		totalRevenue = "${totPaychargeMonth != null ? totPaychargeMonth : 0}";
    	} 
    	$('#totalRevenue').text(totalRevenue);
    }
    
    // select - option이 연도별, 월별일 경우
    let yearInput = $('.year_value');
    // 추가
    let monthInput = $('.month_value');
    let minusBtn = $('.minus_btn');
    let plusBtn = $('.plus_btn');
    let minusBtn2 = $('.minus_btn2');
    let plusBtn2 = $('.plus_btn2');

    let searchYear = "${param.searchYear}";
    let searchMonth = "${param.searchMonth}";

    let thisMonth = new Date().getMonth() + 1;
    let thisYear = new Date().getFullYear();
	if (searchYear !== "") {
	    yearInput.val(searchYear);
	} else {
	    yearInput.val(thisYear);
	}
	
	if (searchMonth !== "") {
	    monthInput.val(searchMonth);
	} else {
	    monthInput.val(thisMonth);
	}

    // 올해 이상으로는 증가 불가  - year
    plusBtn.click(function() {
        let currentYear = parseInt(yearInput.val());
        if (currentYear < thisYear) {
        yearInput.val(currentYear + 1);
        }
    });
    // 감소 이벤트 - year
    minusBtn.click(function() {
        let currentYear = parseInt(yearInput.val());
        yearInput.val(currentYear - 1);
    });
    
    // 증가 이벤트 - month
    plusBtn2.click(function() {
        let currentMonth = parseInt(monthInput.val());
        if (currentMonth < 12) {
        monthInput.val(currentMonth + 1);
        } else{
        	monthInput.val(1);
        }
    });
    // 감소 이벤트 - month
    minusBtn2.click(function() {
	    let currentMonth = parseInt(monthInput.val());
	    if (currentMonth > 1) {
	        monthInput.val(currentMonth - 1);
	    } else {
	        // 월 값이 0 이하일 경우 처리할 로직 추가
	        // 예: 최소 월 값은 1월로 설정
	        monthInput.val(12);
	    }
	});

    // select - option이 기간별인 경우
    $('.start_day').on('change', function() {
        // 끝나는 날짜는 시작날짜보다 먼저일 수 없음
        let date01Value = new Date($(this).val());
        let minDate = new Date(date01Value);
        minDate.setDate(minDate.getDate() + 1);
        
        $('.end_day').attr('min', minDate.toISOString().split('T')[0]);
        
        let date02Value = new Date($('.end_day').val());
        if (date02Value < minDate) {
            $('.end_day').val(minDate.toISOString().split('T')[0]);
        };
    });
     
</script>

