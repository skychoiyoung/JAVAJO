<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %> <!-- 숫자 포맷팅 할 때 필요 -->
<%@ include file="guest_top.jsp" %>
    <!-- s: content -->
    <section id="guest_pdt_info" class="content">
        <div class="pdt_wrap">
            <div class="pdt_info">
                <p class="pdt_tit">${getHouseByNum.house_name}</p>
                <div class="pdt_imgs">
                	<img class="pdt_img1" src="resources/upload_house_images/${getHouseByNum.house_image1}" alt="">
                	<img class="pdt_img2" src="resources/upload_house_images/${getHouseByNum.house_image2}" alt="">
                	<img class="pdt_img3" src="resources/upload_house_images/${getHouseByNum.house_image3}" alt="">
                	<img class="pdt_img4" src="resources/upload_house_images/${getHouseByNum.house_image4}" alt="">
                	<img class="pdt_img5" src="resources/upload_house_images/${getHouseByNum.house_image5}" alt=""> 
                </div>

                <div class="pdt_info-wrap">
                    <div class="pdt_detail">
                        <div class="pdt_form">
                        	<div class="pdt_type">
                        		<img class="" src="resources/images/category/${getHouseByNum.house_type_image}" alt="">
                        		<p>${getHouseByNum.htype_des}</p>
                        	</div>
                        	<ul class="pdt_summary">
	                        	<li><img src="resources/images/main/maxper.png" alt=""><span>${getHouseByNum.house_maxperson}명</span></li>
	                            <li><img src="resources/images/main/room.png" alt=""><span>${getHouseByNum.house_room}개</span></li>
	                            <li><img src="resources/images/main/bed.png" alt=""><span>${getHouseByNum.house_bed}개</span></li>
	                            <li><img src="resources/images/main/bath.png" alt=""><span>${getHouseByNum.house_bath}개</span></li>
                        	</ul>
						    <input type="button" id="wishBtn" name="wishBtn" class="pdt_like wishBtn" onclick="wishClick(event, this)">
                        	<c:forEach var="wdto" items="${wishList}">                		                      		
                        		<c:if test="${wdto.house_num == getHouseByNum.house_num}">
		                            <input type="button" id="wishBtn" name="wishBtn" class="pdt_like wishBtn addwish" onclick="wishClick(event, this)">
								</c:if>
                    		</c:forEach>
						    <input type="hidden" name="houseNum" value="${getHouseByNum.house_num}">
						    <input type="hidden" name="userName" value="${inUser.user_id}">
                        </div>
                        <div class="pdt_theme-box">
                        	<p>숙소 테마</p>
	                        <ul class="pdt_theme">
	                        <c:forEach var="theme" items="${themeList}">
						    <li>
					            <img class="theme_img" src="resources/images/theme/${theme.htheme_image}" alt=""/>
						        <span class="theme_name">${theme.htheme_des}</span>
						    </li>
	                        </c:forEach>
	                        </ul>
                        </div>
                        <div class="pdt_host">
                            <div class="host_img"><img src="resources/images/main/host.png" /></div>
                            <div class="host_txt">
                                <p>호스트: ${getHouseByNum.user_id} 님</p>
                                <input type="hidden" name="hostId" value="${getHouseByNum.user_id}" />
                            </div>
                        </div>
                        <ul class="inout_box">
                        	<li><img src="resources/images/main/clock.png" alt=""/>체크인 가능시간: <span>${getHouseByNum.house_checkin}</span> 이후</li>
                        	<li><img src="resources/images/main/clock.png" alt=""/>체크아웃 시간: <span>${getHouseByNum.house_checkout}</span> 이전</li>
                        </ul>
                        <textarea class="pdt_desc" cols="60" maxlength="200" wrap="hard" readonly style="resize: none;">${getHouseByNum.house_content}</textarea>
                    </div>
                    <div class="pdt_reserve">
                        <form name="resfrom" action="reserve_detail.do?house_num=${getHouseByNum.house_num}" method="post">
                        	<input type="hidden" name="hostId" value="${getHouseByNum.user_id}" />
                        	<input type="hidden" name="house_name" value="${getHouseByNum.house_name}" />
                        	<input type="hidden" name="house_addr" value="${getHouseByNum.house_addr}" />
                        	<input type="hidden" name="house_checkin" value="${getHouseByNum.house_checkin}" />
                        	<input type="hidden" name="house_checkout" value="${getHouseByNum.house_checkout}" />
                        	<input type="hidden" id="stayPriceInput" name="stayPrice" value="${stayPrice}"/>
                        	<input type="hidden" id="javajoVatInput" name="javajoVat" value="${javajoVat}"/>
                        	<input type="hidden" id="totalPriceInput" name="totalPrice" value="${totalPrice}"/>
                            <p class="pdt_day-price">
	                            <span><fmt:formatNumber value="${housePrice}" pattern="###,###"/></span>원 / 1박
                            </p>
                            <div class="calendar_box">
                                <!-- datapicker api -->
                                <input type="text" name="datepicker2" id="datepicker2" class="" placeholder="날짜 선택" values="" readonly/>
                                <input type="hidden" name="checkinDate" value="" required />
                                <input type="hidden" name="checkoutDate" value="" required />
                                <input type="hidden" name="housePrice" value="${getHouseByNum.house_price}" required />
                            </div>
                            <div id="counter2" class="count_box">
                                <button class="count_icon minus_icon" type="button"><img src="resources/images/main/minus.png" alt="뺴기 아이콘"></button>
                               	<input type="text" class="per_count" name="stayPer" value="1" readOnly />
                               	<input type="hidden" name="house_maxperson" value="${getHouseByNum.house_maxperson}" readOnly />
                                <button class="count_icon plus_icon" type="button"><img src="resources/images/main/plus.png" alt="더하기 아이콘"></button>
                            </div>
                            <button class="reserve_btn" type="button" onclick="reservCheck()">예약하기</button>
                            
                            <div class="price_box">
                                <div>
                                    <span class="pdt_name">
                                    	<em id="avgPricefm">${avgPricefm}</em>원 *
                                    	<label>
	                                    	<input type="text" name="daycount02" value="0" readonly style="width: 22px; text-align: center; border: none; outline:none;" />박
                                    	</label>
                                    </span>
                                    <input type="hidden" id="stayCount" name="daycount02" value="" required />
                                    <span class="pdt_price"><em id="stayPricefm">${stayPricefm}</em>원 </span>
                                </div>
                                <div >
                                    <span class="pdt_name">JAVAJO 서비스 수수료</span>
                                    <span class="pdt_price"><em id="javajoVatfm">${javajoVatfm}</em>원</span>
                                </div>
                                <div class="total_price">
                                    <span>총 합계</span>
                                    <span><em id="totalPricefm">${totalPricefm}</em>원</span>
                                </div>
                            </div>
                        </form>
                    </div>
                </div>

                <div class="pdt_fac">
                    <p class="fac_tit">편의시설</p>
                    <ul class="fac_list">
                    	<c:forEach var="fac" items="${facList}">
					    <li class="fac_item">
					        <img src="resources/images/amenities/${fac.hfac_image}" alt="" />
					        <p>${fac.hfac_des}</p>
					    </li>
                    	</c:forEach>
                    </ul>
                </div>
                
                <div class="pdt_loc">
                    <p class="loc_tit">숙소 위치</p>
			        <div class="map_box">
			        	<p class="map_addr">${getHouseByNum.house_addr}</p>
			        	<div id="map" class="pdt_map"></div>
			        </div>
                </div>

                <div class="pdt_review">
                    <div class="review_tit-box">
                        <p class="review_tit">리뷰</p>
                        <a class="review_btn" href="review_all.do?house_num=${getHouseByNum.house_num}">리뷰 더보기</a>
                    </div>
                    <ul class="review_list">
                    	<c:forEach var="review" items="${listReview}">
                    	<li class="review_item">
                            <div class="review_img">
                            <c:choose>
				                <c:when test="${review.review_image == null}">
				                    <img src="resources/upload_guestReview/default_review.png" alt="" />
				                </c:when>
				                <c:when test="${not empty review.review_image}">
				                    <img src="resources/upload_guestReview/${review.review_image}" alt="" />
				                </c:when>
			            	</c:choose>
                            </div>
                            <div class="review_txt">
                                <p class="review_id">작성자: ${review.user_id}</p>
                                <p class="review_date">${review.review_date}</p>
                                <div class="review_grade">
                               	<c:forEach var="star" begin="1" end="${review.review_score}">
                                   <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 32 32" aria-hidden="true" role="presentation" focusable="false" style="display: block; height: 0.5625rem; width: 0.5625rem; fill: var(--linaria-theme_palette-hof);"><path fill-rule="evenodd" d="m15.1 1.58-4.13 8.88-9.86 1.27a1 1 0 0 0-.54 1.74l7.3 6.57-1.97 9.85a1 1 0 0 0 1.48 1.06l8.62-5 8.63 5a1 1 0 0 0 1.48-1.06l-1.97-9.85 7.3-6.57a1 1 0 0 0-.55-1.73l-9.86-1.28-4.12-8.88a1 1 0 0 0-1.82 0z"></path></svg>
								</c:forEach>
                                </div>
                                <p class="review_cont">${review.review_content}</p>
                            </div>
                        </li>
                        </c:forEach>
                    </ul>
                </div>
                <div class="pdt_qna">
                    <div class="qna_tit-box">
                        <p class="qna_tit">숙소 문의</p>
                        <a class="qna_btn" href="javascript:;">문의 등록</a>
                    </div>
                    <table class="qna_list j_table">
                        <thead>
                            <tr>
                                <th class="qna_num" style="width: 5%;">No</th>
                                <th class="qna_tit">문의 제목</th>
                                <th class="qna_writer" style="width: 10%;">작성자</th>
                                <th class="qna_date" style="width: 13%;">등록일</th>
                                <th class="qna_status" style="width: 10%;">답변상태</th>
                            </tr>
                        </thead>
                        <tbody>
                        	<c:if test="${empty listQna}">
                        	<tr>
                            	<td colspan="5">등록된 숙소의 문의글이 없습니다.</td>
                            </tr>
                        	</c:if>
                        	<c:if test="${!empty listQna}">
	                        	<c:forEach var="qna" items="${listQna}" varStatus="status">
		                        	<tr class="qna_lists">
					                    <td class="qna_num">${no - status.index}</td>
					                    <td class="qna_tit"><a href="javascript:void(0);" onclick="viewCheckId(${qna.hostqna_num}, '${qna.user_id}')">${qna.hostqna_title}</a></td>
					                    <td class="qna_writer">${qna.user_id}</td>
					                    <td class="qna_date">${fn:substring(qna.hostqna_date, 0, 10)}</td>
					                    	<td class="qna_status">${qna.hostqna_status}</td>
					                </tr>
	                           	<tr>
		                        	<td id="answer_${qna.hostqna_num}" colspan="5" style="display:none;">
		                        	<form name="f" action="del_qna.do" method="post">
									    <input type="hidden" name="hostqna_num" value="${qna.hostqna_num}" />
									    <input type="hidden" name="house_num" value="${getHouseByNum.house_num}" />
									    <div class="qna_toggle-box">
									        <div class="question_box">
									            <label>문의제목
									                <input type="text" value="${qna.hostqna_title}" readonly required />
									            </label>
									            <label>문의내용</label>
									            <textarea cols="50" rows="10" readonly>${qna.hostqna_gcontent}</textarea>
									        </div>
									        <div class="answer_box">
									            <c:if test="${empty qna.hostqna_hcontent}">
									                <p>문의주신 글에 대한 답변이 아직 등록되지 않았습니다.</p>
									            </c:if>
									            <c:if test="${not empty qna.hostqna_hcontent}">
									                <label>답변내용</label>
									                <textarea name="hostqna_hcontent" cols="50" wrap="hard" readonly>${qna.hostqna_hcontent}</textarea>
									            </c:if>
									        </div>
									        <div class="button_box">
									            <button class="del_btn" type="submit">삭제하기</button>
									        </div>
									    </div>
									</form>
		                        	</td>
	                        	</tr>                  	
                           		</c:forEach>                           		
            				<br>
                           	</c:if>                           	
                        </tbody>
                    </table>
                    <!-- 페이징 -->
		        	<div class="pagination">
					    <c:if test="${startPage > pageBlock}"> 
					        <a class="page_btn prev_btn" href="house_info.do?pageNum=${startPage-3}&house_num=${getHouseByNum.house_num}"><img src="resources/images/main/arrow.png" alt="" /></a>
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
					        <a href="house_info.do?pageNum=${i}&house_num=${getHouseByNum.house_num}" class="${activeClass} page_num">${i}</a>
					    </c:forEach>
					    
					    <c:if test="${pageCount > endPage}">
					        <a class="page_btn next_btn" href="house_info.do?pageNum=${startPage+3}&house_num=${getHouseByNum.house_num}"><img src="resources/images/main/arrow.png" alt="" /></a>
					    </c:if>
					</div>
                </div>
            </div>
        </div>
        <div class="qna_box">
		    <form id="insertQnaForm" name="f" action="insertQna.do" method="post">
		        <input type="hidden" name="userId" value="${inUser.user_id}" />
		        <input type="hidden" name="insertNum" value="${getHouseByNum.house_num}" />
		        <input type="hidden" name="insertStatus" value="${insertQna.hostqna_status}" />
		        <div class="qnd_pdt">
		            <input type="text" value="숙소명 - ${getHouseByNum.house_name}" readonly>
		            <input type="text" value="숙소 주소 - ${getHouseByNum.house_addr}" readonly>
		        </div>
		        <div class="qnd_cont">
		            <label for="hostqna_title">제목 <input type="text" name="hostqna_title" id="hostqna_title" value="" maxlength="20" required></label>
		            <label for="hostqna_gcontent">문의 내용</label>
		            <textarea id="hostqna_gcontent" name="hostqna_gcontent" cols="50" rows="10" maxlength="200" wrap="hard" required></textarea>
		        </div>
		        <div class="qna_btn-box">
		            <button class="qnaInsertBtn" type="submit">등록</button>
		            <button class="close_btn" type="reset">취소</button>
		        </div>
		    </form>
		</div>
        <div class="dimm"></div>
    </section>
    <!-- e: content -->
<%@ include file="guest_bottom.jsp" %>
<script type="text/javascript" src="//dapi.kakao.com/v2/maps/sdk.js?appkey=11d37bb5fbf22b2f7d6e589a9b1d88ac&libraries=services,clusterer,drawing"></script>
<script type="text/javascript">
let userId = $("input[name='userName']").val(); // 로그인 유저 아이디
let hostId = $("input[name='hostId']").val(); // 페이지 등록 유저
let houseNum = $('input[name="houseNum"]').val(); // 페이지넘버

// 예약 날짜 선택 유무 확인
function reservCheck() {
	if($("input[name='datepicker2']").val() == "" || $("input[name='datepicker2']").val() == null) {
		alert("예약하실 날짜를 선택해주세요.");
		return
	}else {
		return document.resfrom.submit();
	}
}

// 예약 달력 api
let today = moment().startOf('day');
let reservDate = ${reservDate}; // 예약된 날짜 배열로 받아오기

let dateRangePicker2 = $('input[name="datepicker2"]').daterangepicker({
   opens: 'left',
   locale: {
       format: 'YYYY-MM-DD',
       applyLabel: '적용',
       cancelLabel: '취소',
       daysOfWeek: ['일', '월', '화', '수', '목', '금', '토'],
       monthNames: ['1월', '2월', '3월', '4월', '5월', '6월', '7월', '8월', '9월', '10월', '11월', '12월'],
   },
   applyButtonClasses: 'my-apply-btn',
   cancelButtonClasses: 'my-cancel-btn',
   autoUpdateInput: false,
   minDate: today,
   minSpan: { days: 1 },
   isInvalidDate: function(date) {
       let startDate = dateRangePicker2.data('daterangepicker').startDate;
       let endDate = dateRangePicker2.data('daterangepicker').endDate;
       
       $(".drp-selected").remove();
       // 체크인 날짜 선택 후 첫번째 날짜를 선택한 경우
       if (!startDate && !endDate) {
           // 예약된 날짜 배열에서 첫번째로 예약된 날짜를 찾음
           let firstReservedDate = reservDate[0];
           if (date.isAfter(firstReservedDate, 'day')) {
               return true; // 체크인 날짜 이후의 날짜는 비활성화
           }
       } else if (startDate && !endDate) {
           // 체크인 날짜 이후에 선택된 경우
           let lastSelectedDate = startDate.clone().add(1, 'day'); // 체크인 날짜 다음날부터 체크아웃 날짜 전까지 비교
           let closestReservedDate = null;
           // 예약된 날짜 중에서 체크인 날짜 이후이면서 가장 먼저 예약된 날짜를 찾음
           for (let reserved of reservDate) {
               if (moment(reserved).isAfter(lastSelectedDate, 'day')) {
                   closestReservedDate = reserved;
                   break;
               }
           }
           if (closestReservedDate && date.isAfter(closestReservedDate, 'day')) {
               return true; // 가장 먼저 예약된 날짜 이후의 날짜는 비활성화
           }
       }
       // 예약된 날짜가 포함되어 있으면 비활성화
       if (reservDate.includes(date.format('YYYY-MM-DD'))) {
           return true;
       }
       return false;
   },
}, function(start, end, label) {
    $('input[name="datepicker2"]').val(start.format('YYYY-MM-DD') + ' - ' + end.format('YYYY-MM-DD'));
    $('input[name="checkinDate"]').val(start.format('YYYY-MM-DD'));
    $('input[name="checkoutDate"]').val(end.format('YYYY-MM-DD'));
    let nights = end.diff(start, 'days'); // 숙박일 수
    $('input[name="daycount02"]').val(nights);
    let housePrice = $('input[name="housePrice"]').val(); // 1박 가격 
    let checkInDay = $('input[name="checkinDate"]').val(); // 체크인 일 
    let checkOutDay = $('input[name="checkoutDate"]').val(); // 체크아웃 일
    
    var data = {
        stayCount: nights, // 숙박일 수
        checkinDate: checkInDay, // 체크인
        checkoutDate: checkOutDay, // 체크아웃
        housePrice: housePrice // 1박 가격
    };
    // 숙박 가격 계산  ajax
    $.ajax({
        url: "${pageContext.request.contextPath}/housePriceCal.ajax",
        type: "POST",
        data: JSON.stringify(data),
        contentType: "application/json",
        dataType: "json",
        success: function(response) {
            console.log("ajax response:", response);
            
            // house_info에 표시할 값
            var avgPricefm = response.avgPricefm;
            var stayPricefm = response.stayPricefm;
            var javajoVatfm = response.javajoVatfm;
            var totalPricefm = response.totalPricefm;
            $('#avgPricefm').text(avgPricefm);
            $('#stayPricefm').text(stayPricefm);
            $('#javajoVatfm').text(javajoVatfm);
            $('#totalPricefm').text(totalPricefm);
            
            // 예약하기 클릭시 reserve_detail.do로 보낼 값
            var stayPrice = response.stayPrice;
            var javajoVat = response.javajoVat;
            var totalPrice = response.totalPrice;          
            $('#stayPriceInput').val(stayPrice);
            $('#javajoVatInput').val(javajoVat);
            $('#totalPriceInput').val(totalPrice);     
        },
        error: function(xhr, status, error) {
            console.error('Error:', error);
        }
    });
});

// 체크인 날짜 초기화
dateRangePicker2.on('apply.daterangepicker', function(ev, picker) {
    $(this).val(picker.startDate.format('YYYY-MM-DD') + ' - ' + picker.endDate.format('YYYY-MM-DD'));
});

//카운트기능 함수
function countEvt(addBtn, minusBtn, maxCount) {
	    $(document).on('click', addBtn, function() {
	        var counter = $(this).closest('.count_box');
	        var value = parseInt(counter.find(".per_count").attr("value"));
	        if (value < maxCount) {
	            counter.find(".per_count").attr("value", value + 1);
	        }
	    });
	    $(document).on('click', minusBtn, function() {
	        var counter = $(this).closest('.count_box');
	        var value = parseInt(counter.find(".per_count").attr("value"));
	        if (value > 1) {
	            counter.find(".per_count").attr("value", value - 1);
	        }
	    });
	}
let maxPerHouse = $("#guest_pdt_info input[name='house_maxperson']").val();
countEvt('#counter2 .plus_icon','#counter2 .minus_icon', maxPerHouse);

//위시버튼 클릭 이벤트
function wishClick(event, button) {	
    var houseNum = ${getHouseByNum.house_num}
	var userId = "${inUser.user_name}";
	
    if (!$(button).hasClass('addwish')) {
    	addToWishlist(houseNum, userId, button);
    }
    else {
    	removeFromWishlist(houseNum, userId, button);
    }
}

//위시리스트 추가
function addToWishlist(houseNum, userId, button) {
	var data = {
			user_id : userId,
			house_num : houseNum
	}
	//위시리스트 추가 ajax
    $.ajax({
    	url: "${pageContext.request.contextPath}/addWish.ajax",
        type: "POST",
        data: JSON.stringify(data),
        contentType: "application/json",
        dataType: "text",
        success: function(res) {
        	$(button).addClass('addwish');
            alert("위시리스트에 추가되었습니다.");
        },
        error: function(err) {
            console.log(err);
        }
    });
};

// 위시리스트 삭제
function removeFromWishlist(houseNum, userId, button) {
	var data = {
			user_id : userId,
			house_num : houseNum
	}
	//위시리스트 삭제 ajax
    $.ajax({
    	url: "${pageContext.request.contextPath}/delWish.ajax",
        type: "DELETE",
        data: JSON.stringify(data),
        contentType: "application/json",
        dataType: "text",
        success: function(res) {
        	$(button).removeClass('addwish');
        	alert("위시리스트에서 삭제되었습니다.");
        },
        error: function(err) {
            console.log(err);
        }
    });
};

// 카카오맵  api
var mapContainer = document.getElementById('map'), // 지도를 표시할 div 
    mapOption = {
        center: new kakao.maps.LatLng(33.450701, 126.570667), // 지도의 중심좌표
        level: 3 // 지도의 확대 레벨
    };  
var map = new kakao.maps.Map(mapContainer, mapOption);
var geocoder = new kakao.maps.services.Geocoder();
var zoomControl = new kakao.maps.ZoomControl();
map.addControl(zoomControl, kakao.maps.ControlPosition.RIGHT);
geocoder.addressSearch('${getHouseByNum.house_addr}', function(result, status) {
     if (status === kakao.maps.services.Status.OK) {
        var coords = new kakao.maps.LatLng(result[0].y, result[0].x);
        var marker = new kakao.maps.Marker({
            map: map,
            position: coords
        });
        marker.setMap(map);
        map.setCenter(coords);
        map.setDraggable(false);
        map.setZoomable(false);
    } 
});

// 숙소 문의 팝업 show
$('.qna_btn').on('click', function() {
	$('.qna_box').show();
	$('.dimm').show();
});

// 숙소문의 팝업  hide
$('.qna_box .close_btn').on('click', function() {
	$('.qna_box').hide();
	$('.dimm').hide();
});

//문의등록 클릭 이벤트
$('.qnaInsertBtn').on('click', function(){
	// 문의 제목, 내용 공백 확인 alert
	if ($("#hostqna_title").val().trim() === "") {
	    alert("문의 제목을 입력해주세요.");
	    return;
	} else if ($("#hostqna_gcontent").val().trim() === "") {
	    alert("문의 내용을 입력해주세요.");
	    return;
	}
});

// 문의글 보기 (게스트: 본인이 등록한 글만 / 호스트: 모든 글 열람가능)
function viewCheckId(qnaNum, qnaUserId) {
    if (userId === qnaUserId || userId === hostId) {
        $("#answer_" + qnaNum).toggle();
        if ($("#answer_" + qnaNum).is(":visible")) {
            $('html, body').animate({
                scrollTop: $("#answer_" + qnaNum).offset().top
            }, 500);
        }
    } else {
        alert("이 문의글에 대한 접근 권한이 없습니다.");
    }
}
</script>