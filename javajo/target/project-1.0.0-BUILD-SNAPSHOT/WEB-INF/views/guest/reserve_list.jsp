<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ include file="guest_top.jsp" %>
<!-- s: content -->
    <section id="reserve_all" class="content">
        <div class="tit_box">
            <p>예약 내역</p>
        </div>
        <ul class="reserve_list">
        	<c:if test="${empty reserveList}">
        		<li><p style="margin: 0 auto; font-size: 26px; text-align: center;">현재 예약하신 숙소가 존재하지 않습니다.</p></li>
        	</c:if>
        	<c:forEach var="reserv" items="${reserveList}">
            <li class="reserve_items">
            	<a href="house_info.do?house_num=${reserv.house_num}"><img src="resources/upload_house_images/${reserv.thumbnail}" alt=""/></a>
                <div class="reserve_txt">
                    <p class="reserve_num"><span>예약번호</span>${reserv.reserv_num}</p>
                    <p class="reserve_tit"><span>숙소명</span>${reserv.house_name}</p>
                    <p class="reserve_host"><span>호스트명</span>${reserv.host_id}</p>
                    <p class="reserve_date"><span>예약일자</span>${reserv.reserv_checkin} - ${reserv.reserv_checkout}</p>
                    <p class="reserve_per"><span>예약인원</span>${reserv.reserv_person}명</p>
                    <p class="reserve_payday"><span>결제일시</span>${reserv.reserv_paydate}</p>
                    <p class="reserve_patsort"><span>결제구분</span>${reserv.reserv_paytype}</p>
                    <p class="reserve_price"><span>결제금액</span><fmt:formatNumber value="${reserv.reserv_totpay}" pattern="#,###" />원</p>
                </div>
                <div class="reserve_btn">
            	<input type="hidden" id="reserve_userId" name="user_id" value="${inUser.user_id}" />
            	<input type="hidden" id="reserveNum" name="reserv_num" value="${reserv.reserv_num}" />
            	<input type="hidden" id="reserve_houseNum" name="house_num" value="${reserv.house_num}" />
            	<input type="hidden" id="reserve_CheckIn" name="reserv_checkin" value="${reserv.reserv_checkin}" />
            	<input type="hidden" id="reserve_CheckOut" name="reserv_checkout" value="${reserv.reserv_checkout}" />
                <c:choose>
		            <c:when test="${reserv.reserv_status eq '결제완료'}">
		                <button class="reserve_del" type="button" data-house-num="${reserv.house_num}" data-reserv-num="${reserv.reserv_num}">예약취소</button>
		            </c:when>
		            <c:when test="${reserv.reserv_status eq '예약취소'}">
		                <button class="del_complete" type="button" style="cursor:default;" disable>취소완료</button>
		            </c:when>
		            <c:when test="${reserv.reserv_status eq '이용중'}">
		            	<!-- <button class="use_now" type="button" style="background-color: #9E9E9E; cursor:default;">이용중</button> -->
		            </c:when>
				    <c:when test="${reserv.reserv_status eq '이용완료' && reserv.review_status eq '미작성'}">
				        <button class="review_write" type="button" data-house-num="${reserv.house_num}" data-reserv-num="${reserv.reserv_num}" data-house-name="${reserv.house_name}">리뷰작성</button>
				    </c:when>
				    <c:when test="${reserv.reserv_status eq '이용완료' && reserv.review_status eq '작성완료'}">
				        <a class="review_all" href="review_all.do?house_num=${reserv.house_num}">리뷰확인</a>
				    </c:when>
		        </c:choose>
                </div>
            </li>
        	</c:forEach>
        </ul>

        <div class="insert_box" style="display: none;">
            <p class="insert_tit">숙소리뷰</p>
            <form name="ReviewForm" method="post" enctype="multipart/form-data">
			    <input type="hidden" id="revUser" name="userName" value="${inUser.user_id}">
            	<input type="hidden" id="revHNum" name="house_num" value="${reserv.house_num}" />
                <input type="hidden" id="revHName" name="house_num" value="${reserv.house_name}" />
                <div class="insert_wrap">
                    <div class="upload_box">
                        <div class="img_box">
                        	<img id="preview_image" src="" alt="" style="display: none;" />
                        </div>
                        <div class="file_box">
                            <input class="file_name" placeholder="첨부파일" readonly>
                            <label for="file">사진찾기</label>
                            <input type="file" id="file" name="review_image" value="" />
                        </div>
                    </div>
                    <div class="review_box">
                        <p><span>숙소</span><span class="review_house"></span></p>
                        <p>숙소 점수</p>
                        <div class="star-rating">
                            <span class="star" data-value="1">&#9733;</span>
                            <span class="star" data-value="2">&#9733;</span>
                            <span class="star" data-value="3">&#9733;</span>
                            <span class="star" data-value="4">&#9733;</span>
                            <span class="star" data-value="5">&#9733;</span>
                            <input type="hidden" name="review_score" id="rating" value="" />
                        </div>
                        <p>후기남기기</p>
                        <textarea id="revCont" name="review_content" cols="50" maxlength="200" wrap="hard" placeholder="후기를 작성해주세요 (200자 제한)" required ></textarea>
                    </div>
                </div>
                <div class="button_box">
                    <button id="insertRevBtn" class="submit_btn" type="button">등록</button>
                    <button class="reset_btn" type="reset">취소</button>
                </div>
            </form>
        </div>
        <!-- 페이징 -->
        <div class="pagination">
		    <c:if test="${startPage > pageBlock}"> 
		        <a class="page_btn prev_btn" href="reserve_list.do?pageNum=${startPage-3}"><img src="resources/images/main/arrow.png" alt="" /></a>
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
		        <a href="reserve_list.do?pageNum=${i}" class="${activeClass} page_num">${i}</a>
		    </c:forEach>
		    
		    <c:if test="${pageCount > endPage}">
		        <a class="page_btn next_btn" href="reserve_list.do?pageNum=${startPage+3}"><img src="resources/images/main/arrow.png" alt="" /></a>
		    </c:if>
		</div>
        <div class="dimm"></div>
    </section>
    <!-- e: content -->
<%@ include file="guest_bottom.jsp" %>
<script type="text/javascript">
let resNum = $('.review_write').data('reserv-num');
	// input 파일 커스텀
	$('#file').on('change', function() {
	    var fileName = $(this).val().split('\\').pop();
	    $('.file_name').val(fileName);
	});
	// 리뷰작성 버튼 클릭 이벤트
	$('.review_write').on('click', function() {
	    let $button = $(this); // 클릭된 버튼 변수에 저장
	    let houseNum = $button.data('house-num');
	    let houseName = $button.data('house-name');
	    let reservNum = $button.data('reserv-num');

	    $('input[name="house_num"]').val(houseNum);
	    $('.review_box .review_house').text(houseName);

	    $('.insert_box').show();
	    $('.dimm').show();

	    // 이미지 미리보기 기능
	    $('#file').on('change', function() {
	        var file = this.files[0];
	        var reader = new FileReader();

	        reader.onload = function(e) {
	            $('#preview_image').attr('src', e.target.result).show();
	        };

	        if (file) {
	            reader.readAsDataURL(file);
	        }
	    });

	    // 리뷰등록 버튼 클릭 이벤트
	    $("#insertRevBtn").off('click').on('click', function() {
	        ReviewCheck($button);
	    });
	});

	// 리뷰등록 후 버튼 교체
	function ReviewCheck($button) {
	    let revUser = $("#revUser").val();
	    let revHNum = $("#revHNum").val();
	    let imgFile = $("#file")[0].files[0];
	    let revScore = $("input[name='review_score']").val().trim();
	    let revCont = $("textarea[name='review_content']").val().trim();

	    if (revScore == '') {
	        alert("숙소 점수를 입력해주세요.");
	        return;
	    } else if (revCont == '') {
	        alert("후기를 작성해주세요. (200자 제한)");
	        return;
	    }
	    insertReview($button, revUser, revHNum, imgFile, revScore, revCont);
	}

	// 리뷰등록 Ajax 요청 후 버튼 교체
	function insertReview($button, revUser, revHNum, imgFile, revScore, revCont) {
	    let formData = new FormData();
	    formData.append('user_id', revUser);
	    formData.append('house_num', revHNum);
	    formData.append('review_image', imgFile);
	    formData.append('review_score', revScore);
	    formData.append('review_content', revCont);
	    formData.append('review_status', '작성완료');
	    formData.append('reserv_num', $('.review_write').data('reserv-num'));

	 // Ajax 요청
     $.ajax({
         url: "${pageContext.request.contextPath}/insertReview.ajax",
         type: "POST",
         data: formData,
         processData: false,
         contentType: false,
         success: function(res) {
             alert(res);
             // 성공적으로 등록되면 리뷰 확인 버튼으로 교체
             var reviewAllBtn = $("<a>").addClass('review_all').attr('href', 'review_all.do?house_num=' + revHNum).text('리뷰확인');
             $button.replaceWith(reviewAllBtn);
             $('.insert_box').hide();
             $('.dimm').hide();
             $('#preview_image').attr('src', '').hide();
             $('#file').val('');
             $('.file_name').val('');
             $('.star').removeClass('selected');
             $('#rating').val('');
             $('#revCont').val("");
         },
         error: function(err) {
             console.log(err);
         }
     });
	}
 	// 별점 주기
    let selectedRating = 0;
	
    $('.star').on('click', function() {
        selectedRating = $(this).data('value');
        $('#rating').val(selectedRating);
        updateStars();
    });
    $('.star').on('mouseover', function() {
        var rating = $(this).data('value');
        $('.star').each(function() {
            if ($(this).data('value') <= rating) {
                $(this).addClass('hovered');
            } else {
                $(this).removeClass('hovered');
            }
        });
    });
    $('.star').on('mouseout', function() {
        $('.star').removeClass('hovered');
        updateStars();
    });
    function updateStars() {
        $('.star').each(function() {
            if ($(this).data('value') <= selectedRating) {
                $(this).addClass('selected');
            } else {
                $(this).removeClass('selected');
            }
        });
    }
    // 리뷰등록 닫기
    $('#reserve_all .reset_btn').on('click', function() {
        $('.insert_box').hide();
        $('.dimm').hide();
    	$('#preview_image').attr('src', '').hide();
        $('#file').val('');
        $('.star').removeClass('selected');
        $('#rating').val('');
    });
   	// 예약취소 버튼 클릭시 이벤트
    $(".reserve_del").on('click', function() {
        var resHNum = $(this).data('house-num');
        var resNum = $(this).data('reserv-num');
        var resUser = $("input[name='user_id']").val();
        var $button = $(this); // 클릭된 버튼을 변수에 저장

        var confirmMessage = "정말로 예약을 취소하시겠습니까?";
        if (confirm(confirmMessage)) {
        	// 예약 상태 업데이트
	        function updateReserveStatus(resUser, resNum, resHNum, $button) {
	            var data = {
	                user_id: resUser,
	                reserv_num: resNum,
	                house_num: resHNum,
	                reserv_status: '예약취소' // 예약 상태 업데이트
	            };
	            // ajax 요청
	            $.ajax({
	                url: "${pageContext.request.contextPath}/updateReserveStatus.ajax",
	                type: "POST",
	                data: JSON.stringify(data),
	                contentType: "application/json",
	                dataType: "text",
	                success: function(res) {
	                    alert(res);
	                    // 취소완료 버튼으로 교체
	                    var cancelBtn = $("<button>").addClass('del_complete').attr('type', 'button').text('취소완료').css({
	                        'cursor': 'default'
	                    });
	                    $button.replaceWith(cancelBtn); // 기존 버튼을 cancelBtn으로 교체
	                },
	                error: function(err) {
	                    console.log(err);
	                }
	            });
	        }
	        updateReserveStatus(resUser, resNum, resHNum, $button);
        }
	});
</script>