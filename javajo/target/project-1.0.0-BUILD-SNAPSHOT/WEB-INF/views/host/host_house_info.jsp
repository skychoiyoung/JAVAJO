
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<!-- 숫자 포맷팅 할 때 필요 -->
<%@ include file="house_top.jsp"%>
<!-- s: content -->
<section id="host_pdt_info" class="content">
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
					<form name="resfrom" action="updateHouse.do" method="get">
						<input type="hidden" name="house_num"
							value="${getHouseByNum.house_num}">
						<div class="calendar_box">
								<!-- datapicker api -->
							<div id="datepicker3" class="datepicker-inline"></div>
						</div>
						<div class="btn_box">
							<button class="edit_btn" type="submit">숙소 수정</button>
							<button class="del_btn" type="button" onclick="deleteCheck(${getHouseByNum.house_num});">숙소 삭제</button>
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
									<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 32 32"
										aria-hidden="true" role="presentation" focusable="false"
										style="display: block; height: 0.5625rem; width: 0.5625rem; fill: var(- -linaria-theme_palette-hof);">
										<path fill-rule="evenodd"
											d="m15.1 1.58-4.13 8.88-9.86 1.27a1 1 0 0 0-.54 1.74l7.3 6.57-1.97 9.85a1 1 0 0 0 1.48 1.06l8.62-5 8.63 5a1 1 0 0 0 1.48-1.06l-1.97-9.85 7.3-6.57a1 1 0 0 0-.55-1.73l-9.86-1.28-4.12-8.88a1 1 0 0 0-1.82 0z"></path></svg>
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
							<td colspan="5" style="text-align: center;">등록된 숙소의 문의글이 없습니다.</td>
						</tr>
						</c:if>
						<!-- qna 질문 리스트!  -->
						<c:if test="${!empty listQna}">
							<c:forEach var="qna" items="${listQna}" varStatus="status">
								<tr class="qna_lists">
									<td class="qna_num">${no-status.index}</td>
									<td class="qna_tit"><a href="javascript:void(0);" onclick="viewCheckId(${qna.hostqna_num}, '${qna.user_id}','${qna.hostqna_gcontent}', '${qna.hostqna_hcontent}')">${qna.hostqna_title}</a></td>
									<td class="qna_writer">${qna.user_id}</td>
									<td class="qna_date">${fn:substring(qna.hostqna_date,0,10)}</td>
									<td class="qna_status">${qna.hostqna_status}</td>
								</tr>
								<tr>
									<!-- qna 질문 리스트 > 해당 질문 내용!  -->
									<td id="answer_${qna.hostqna_num}" colspan="5" style="display: none;">
										<form name="f" action="hostQna_answer.do" method="post">
											<input type="hidden" name="hostqna_num" value="${qna.hostqna_num}" />
											<input type="hidden" name="house_num" value="${getHouseByNum.house_num}" />
											<input class="test" type="hidden" name="hostqna_gcontent" value="${qna.hostqna_gcontent}" />
											<div class="qna_toggle-box">
												<div class="question_box">
													<label>문의제목 <input type="text"
														value="${qna.hostqna_title}" readonly required />
													</label> <label>문의내용</label>
													<textarea cols="50" rows="10" readonly>${qna.hostqna_gcontent}</textarea>
												</div>
												<div class="answer_box">
													<c:if test="${empty qna.hostqna_hcontent}">
														<p>문의주신 글에 대한 답변이 아직 등록되지 않았습니다.</p>
													</c:if>
													<c:if test="${not empty qna.hostqna_hcontent}">
														<label>답변내용</label>
														<textarea name="hostqna_hcontent" id="hostqna_hcontent" cols="50" wrap="hard" readonly>${qna.hostqna_hcontent}</textarea>
													</c:if>
												</div>
												<div class="button_box">
													<c:if test="${empty qna.hostqna_hcontent}">
														<a class="qna_btn" href="javascript:;" onclick="insertAnswer()">답변등록</a>
													</c:if>
													<c:if test="${not empty qna.hostqna_hcontent}">
														<a class="del_btn" href="javascript:;" onclick="deleteAnswer()">답변삭제</a>
													</c:if>
												</div>
											</div>
										</form>
									</td>
								</tr>
							</c:forEach>
						</c:if>
					</tbody>
				</table>
				<div class="qna_box">
					<!-- qna 리스트에서 답변 써주기 -->
					<form id="insertQnaForm" name="f" action="hostQna_answer.do" method="post">
						<input type="hidden" name="house_num" value="${getHouseByNum.house_num}" />
						<input type="hidden" id="GuestId" name="user_id" value="" />
						<input type="hidden" id="GuestContent" name="hostqna_gcontent" value="" />
						<div class="qnd_pdt">
							<input type="text" value="숙소명 - ${getHouseByNum.house_name}" readonly>
							<input type="text" id="qnaGuestId" value="" readonly>
						</div>
						<div class="qnd_cont">
							<label for="hostqna_hcontent">답변 내용</label>
							<textarea id="hostqna_hcontent" name="hostqna_hcontent" cols="50" rows="10" maxlength="200" wrap="hard" required></textarea>
						</div>
						<div class="qna_btn-box">
							<button class="qnaInsertBtn" type="submit">등록</button>
							<button class="close_btn" type="reset">취소</button>
						</div>
					</form>
				</div>
				<div class="dimm"></div>
					<!-- 페이징 -->
					<div class="pagination">
					    <c:if test="${startPage > pageBlock}"> 
					        <a class="page_btn prev_btn" href="house_Hinfo.do?pageNum=${startPage-3}&house_num=${getHouseByNum.house_num}#paging"><img src="resources/images/main/arrow.png" alt="" /></a>
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
					        <a href="house_Hinfo.do?pageNum=${i}&house_num=${getHouseByNum.house_num}#paging" class="${activeClass} page_num">${i}</a>
					    </c:forEach>
					    
					    <c:if test="${pageCount > endPage}">
					        <a class="page_btn next_btn" href="house_Hinfo.do?pageNum=${startPage+3}&house_num=${getHouseByNum.house_num}#paging"><img src="resources/images/main/arrow.png" alt="" /></a>
					    </c:if>
					</div>
				</div>
			</div>
		</div>
	<!--hidden폼, 삭제눌렀을때 값 보내기 위한 폼 -->
	<form id="deleteForm" action="hostQna_answer.do?mode=del" method="POST"
		style="display: none;">
		<input type="hidden" name="house_num"
			value="${getHouseByNum.house_num}" /> <input type="hidden"
			id="user_id" name="user_id" value=""> <input type="hidden"
			id="hostqna_gcontent" name="hostqna_gcontent" value=""> <input
			type="hidden" id="hostqna_hcontent" name="hostqna_hcontent" value="">
	</form>
</section>
<!-- e: content -->
<%@ include file="house_bottom.jsp"%>
<script type="text/javascript" src="//dapi.kakao.com/v2/maps/sdk.js?appkey=11d37bb5fbf22b2f7d6e589a9b1d88ac&libraries=services,clusterer,drawing"></script>
<script type="text/javascript">
let userId = $("input[name='userName']").val(); // 로그인 유저 아이디
let hostId = $("input[name='hostId']").val(); // 페이지 등록 유저
let houseNum = $('input[name="houseNum"]').val(); // 페이지넘버

var house_num = ${getHouseByNum.house_num};

$(function() {
    // AJAX 요청을 통해 예약 가능한 날짜와 불가능한 날짜를 가져옴
    $.ajax({
        url: 'get-dates?house_num=' + house_num,
        method: 'GET',
        success: function(data) {
            var unavailableDates = data.impossibleDate;
			console.log("unavailableDates", unavailableDates);
            function highlightDates(date) {
                var dateString = $.datepicker.formatDate('yy-mm-dd', date);

                if (unavailableDates.includes(dateString)) {
                    return [false, "unavailable", "예약 불가능"];
                } else {
                    return [true, "", ""];
                }
            }

            $("#datepicker3").datepicker({
                inline: true,
                dateFormat: "yy-mm-dd",
                dayNamesMin: ["일", "월", "화", "수", "목", "금", "토"],
                monthNames: ["1월", "2월", "3월", "4월", "5월", "6월", "7월", "8월", "9월", "10월", "11월", "12월"],
                minDate: new Date(),
                beforeShowDay: highlightDates
            });
        },
        error: function(err) {
            console.error('데이터를 가져오는 데 실패했습니다:', err);
        }
    });
});

//카카오맵  api
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

//숙소 문의 팝업 show
$('.qna_btn').on('click', function() {
	$('.qna_box').show();
	$('.dimm').show();
});
// 숙소문의 팝업  hide
$('.qna_box .close_btn').on('click', function() {
	$('.qna_box').hide();
	$('.dimm').hide();
});
//답변등록 클릭 이벤트
$('.qnaInsertBtn').on('click', function(){
	// 답변 내용 공백 확인 alert
	if ($("#hostqna_hcontent").val().trim() === "") {
	    alert("답변을 입력해주세요.");
	    return;
	}
});

// 문의글 보기 (게스트: 본인이 등록한 글만 / 호스트: 모든 글 열람가능)
	let  qnaGuestId = ''; // 임시로 작성자 id 담아둘 변수 선언
	let  qnaGcontent = ''; // 임시로 작성자 문의내용 담아둘 변수 선언
	let  qnaHcontent = '';
function viewCheckId(qnaNum, qnaUserId, qnaGContent, qnaHContent) {	
	qnaGuestId = qnaUserId;
	qnaGcontent = qnaGContent;
	qnaHcontent = qnaHContent;
	
    $("#answer_" + qnaNum).toggle();
}

	// 답변 삭제하기 눌렀을떄
function deleteAnswer(){
	var Confirmed = confirm("답변을 삭제하시겠습니까?");
    if (Confirmed) {
        document.getElementById('user_id').value = qnaGuestId;
        document.getElementById('hostqna_gcontent').value = qnaGcontent;
        document.getElementById('hostqna_hcontent').value = qnaHcontent;
        document.getElementById('deleteForm').submit();
    }
}
	
// 답변하기 눌렀을때!
function insertAnswer() {
    // 팝업창에 작성자 ID 설정
    document.getElementById('qnaGuestId').value = "작성자:  " + qnaGuestId;
    document.getElementById('GuestId').value = qnaGuestId;
    document.getElementById('GuestContent').value = qnaGcontent;
}

function deleteCheck(house_num) {
	var userConfirmed = confirm("숙소를 삭제하시겠습니까?");
	if (userConfirmed) {
	$.ajax({
        url: "deleteHouse.do",
        type: "GET",
        data: {
            house_num: house_num
        },
        success: function(response) {
            if (response.success) {
                alert("숙소가 삭제되었습니다.");
                window.location = "manageHouse.do";
            } else {			
                alert("해당 숙소는 예약되어 있어 취소가 불가합니다.");
            }	
        },
        error: function() {
            alert("서버 오류가 발생했습니다.");
        }
   	 });
	}
}

window.onload = function() {
    if (window.location.hash) {
        var element = document.getElementById(window.location.hash.substring(1));
        if (element) {
            element.scrollIntoView();
        }
    }
}
</script>