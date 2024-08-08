<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Index</title>
	<link rel="stylesheet" type="text/css" href="resources/css/reset.css">
	<link rel="stylesheet" type="text/css" href="resources/css/index_guest.css">
    <link rel="stylesheet" href="http://code.jquery.com/ui/1.12.1/themes/base/jquery-ui.css">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/daterangepicker/daterangepicker.css" />
	<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    <script src="https://cdn.jsdelivr.net/momentjs/latest/moment.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/daterangepicker/daterangepicker.min.js"></script>
    <script src="resources/js/script.js"></script>
    <style>
		.daterangepicker {width: auto;}
		.daterangepicker .drp-calendar {max-width: 340px;}
		.daterangepicker .drp-calendar.left .calendar-table, .daterangepicker .drp-calendar.right .calendar-table {width: 340px;}
		.daterangepicker .calendar-table thead {height: 70px;}
		.daterangepicker th.month {font-size: 26px!important; font-weight: initial;}
		.daterangepicker .calendar-table th, .daterangepicker .calendar-table td {width: 32px; height: 32px; font-size: 20px; font-weight: initial;}
		.daterangepicker td.active, .daterangepicker td.active:hover {background: #ff385dc7;}
		.daterangepicker td.available:hover {background: #ffdbe1;}
		.daterangepicker .drp-buttons .btn {font-size: 18px;}
		.daterangepicker .drp-buttons .cancelBtn {color: #ccc;}
		.daterangepicker .drp-buttons .btn:hover {color: #ff385d;}
	</style>
    <script>
	 $(document).ready(function(){
	    	$.ajax({
	    		url: "sessionUserCheck",
	    		type: "get",
	    		success: function(resp){
	    			if(!resp){
	    				alert("올바르지 않은 경로입니다. 로그인 후 이용해주세요.");
	    				window.location.href = 'login.do';
	    			}
	    		},
	    		error: function(err){
	    			console.log(err);
	    		}
	    	});
	    });
    </script>
</head>
<body class="javajo">
    <!-- s:header -->
    <section id="guest_top" class="header">
        <div class="inner_header">
            <!-- 사이트 로고 -->
            <div class="logo_box">
                <a href="guest_index.do">
                    <img src="resources/images/logo/javajo_guest_logo.jpg" alt="javajo 로고" />
                </a>
            </div>
            <!-- 비밀번호확인 modal -->
			<div id="passwordModal" class="modal">
		        <div class="modal-content">
		            <span class="close" onclick="closeModal()"><img src="resources/images/main/close.png" alt="" /></span>
		            <p>비밀번호를 입력하세요</p>
		            <input type="password" id="modalPassword" placeholder="비밀번호 입력">
		            <button onclick="checkPassword()"> 확인</button>
		        </div>
		    </div>
            <!-- s: 지역, 날짜, 인원 선택 폼 영역 -->
            <div class="search_box">
                <form name="f" action="guest_search.do" method="post">
                    <!-- s: 지역선택 박스 -->
                    <select class="area_box" name="area">
                    <option value="">지역 선택</option>
                        <option value="서울" <c:if test="${searchParams.area eq '서울'}">selected</c:if>>서울</option>
						<option value="경기" <c:if test="${searchParams.area eq '경기'}">selected</c:if>>경기</option>
						<option value="인천" <c:if test="${searchParams.area eq '인천'}">selected</c:if>>인천</option>
						<option value="대전" <c:if test="${searchParams.area eq '대전'}">selected</c:if>>대전</option>
						<option value="대구" <c:if test="${searchParams.area eq '대구'}">selected</c:if>>대구</option>
						<option value="부산" <c:if test="${searchParams.area eq '부산'}">selected</c:if>>부산</option>
						<option value="광주" <c:if test="${searchParams.area eq '광주'}">selected</c:if>>광주</option>
						<option value="충청남도" <c:if test="${searchParams.area eq '충청남도'}">selected</c:if>>충청남도</option>
						<option value="충청북도" <c:if test="${searchParams.area eq '충청북도'}">selected</c:if>>충청북도</option>
						<option value="전라남도" <c:if test="${searchParams.area eq '전라남도'}">selected</c:if>>전라남도</option>
						<option value="전라북도" <c:if test="${searchParams.area eq '전라북도'}">selected</c:if>>전라북도</option>
						<option value="경상남도" <c:if test="${searchParams.area eq '경상남도'}">selected</c:if>>경상남도</option>
						<option value="경상북도" <c:if test="${searchParams.area eq '경상북도'}">selected</c:if>>경상북도</option>
						<option value="강원" <c:if test="${searchParams.area eq '강원'}">selected</c:if>>강원</option>
						<option value="세종" <c:if test="${searchParams.area eq '세종'}">selected</c:if>>세종</option>
						<option value="제주" <c:if test="${searchParams.area eq '제주'}">selected</c:if>>제주</option>
                    </select>

                  
                    
					<!-- s: 날짜 선택 -->
                    <div class="calendar_box">
                        <!-- datapicker api -->
                        <c:if test="${empty searchParams.checkin}">
                       		<input type="text" name="datepicker1" id="datepicker1" placeholder="날짜선택" readonly/>
                        	<input type="hidden" name="checkin" value="" />
                        	<input type="hidden" name="checkout" value="" />                        
                        </c:if>
                        <c:if test="${not empty searchParams.checkin}">
                       		<input type="text" name="datepicker1" id="datepicker1" placeholder="${searchParams.checkin} - ${searchParams.checkout}" readonly/>
                        	<input type="hidden" name="checkin" value="${searchParams.checkin}" />
                       		<input type="hidden" name="checkout" value="${searchParams.checkout}" />
                        </c:if>                        
                        <span></span>
                    </div>

					
					<!-- s: 추가옵션 영역 -->
					<button class="addOptBtn" type="button" data-target="#searchOptions">추가 옵션</button>
					<div class="search_options searchOptBox" id="searchOptions" style="display: none;">
						<div class="h_type opt_box">
							<p class="opt_tit">건물 유형</p>
							<select class="build_type" id="build_type" name="build_type">
								<option value="">선택</option>
								<option value="htype01" <c:if test="${searchParams.build_type eq 'htype01'}">selected</c:if>>주택</option>
								<option value="htype02" <c:if test="${searchParams.build_type eq 'htype02'}">selected</c:if>>아파트</option>
								<option value="htype03" <c:if test="${searchParams.build_type eq 'htype03'}">selected</c:if>>오피스텔</option>
								<option value="htype04" <c:if test="${searchParams.build_type eq 'htype04'}">selected</c:if>>펜션/풀빌라</option>
							</select>
						</div>
						<div class="person_box opt_box">
	                        <p class="opt_tit">게스트 인원</p>
	                        <div id="counter1" class="count_box">
	                            <button class="count_icon minus_icon" type="button"><img src="resources/images/main/minus.png" alt="뺴기 아이콘"></button>
	                            	<label>
	                            		<input type="text" class="per_count perCount" name="per_count" value="${not empty searchParams.per_count ? searchParams.per_count : '0'}" readonly />
	                            		<span>명</span>
                            		</label>
	                            <button class="count_icon plus_icon" type="button"><img src="resources/images/main/plus.png" alt="더하기 아이콘"></button>
	                        </div>
	                    </div>
						<div class="room_qty opt_box">
							<p class="opt_tit">방</p>
							<div id="roomcount" class="count_box">
	                            <button class="count_icon minus_icon" type="button"><img src="resources/images/main/minus.png" alt="뺴기 아이콘"></button>
	                            <label>
	                            	<input class="per_count" type="text" name="room_cnt" value="${not empty searchParams.room_cnt ? searchParams.room_cnt : '0'}" readonly>개
	                           	</label>
	                            <button class="count_icon plus_icon" type="button"><img src="resources/images/main/plus.png" alt="더하기 아이콘"></button>
                        	</div>
						</div>
						<div class="bath_qty opt_box">
							<p class="opt_tit">욕실</p>
							<div id="bathcount" class="count_box">
	                            <button class="count_icon minus_icon" type="button"><img src="resources/images/main/minus.png" alt="뺴기 아이콘"></button>
	                            <label>
	                            	<input class="per_count" type="text" name="bath_cnt" value="${not empty searchParams.bath_cnt ? searchParams.bath_cnt : '0'}" readonly>개
	                           	</label>
	                            <button class="count_icon plus_icon" type="button"><img src="resources/images/main/plus.png" alt="더하기 아이콘"></button>
                        	</div>
						</div>
						<div class="bed_qty opt_box">
							<p class="opt_tit">침대</p>
							<div id="bedcount" class="count_box">
	                            <button class="count_icon minus_icon" type="button"><img src="resources/images/main/minus.png" alt="뺴기 아이콘"></button>
	                            <label>
	                            	<input class="per_count" type="text" name="bed_cnt" value="${not empty searchParams.bed_cnt ? searchParams.bed_cnt : '0'}" readonly>개
	                           	</label>
	                            <button class="count_icon plus_icon" type="button"><img src="resources/images/main/plus.png" alt="더하기 아이콘"></button>
                        	</div>
						</div>
					</div>

                    <div class="submit_box">
                        <button class="search_btn" type="submit"><img class="submit_icon" src="resources/images/main/search_w.png" alt="검색 아이콘"/></button>
                    </div>
                </form>
            </div>
            <!-- e: 지역, 날짜, 인원 선택 폼 영역 -->

            <!-- s: 회원 관리 -->
            <div class="member_box">
            	<!-- <a class="mode_btn" href="manageHouse.do">호스트모드로 전환</a> -->
                <div class="member_icons togglebtn" data-target="#memberinfo">
                    <img class="mem_icon mem_icon1" src="resources/images/main/user.png" alt="회원 아이콘"/>
                    <c:set var="userId" value="${inUser.user_id}" />
					<c:set var="shortUserId" value="${fn:length(userId) > 20 ? fn:substring(userId, 0, 20) : userId}" />	
                    <p><span>${shortUserId} </span>님 환영합니다.</p>
                    <img class="mem_icon mem_icon2" src="resources/images/main/menubar.png" alt="메뉴바 아이콘"/>
                </div>
                <ul id="memberinfo" class="member_detail searchOptBox">
                    <li><a href="javascript:showPasswordModal();">회원정보수정</a></li>
                    <li><a href="reserve_list.do">예약내역</a></li>
                    <li><a href="wish_list.do">위시리스트</a></li>
                    <li><a href="qna_list.do">고객문의</a></li>
                    <li><a href="manageHouse.do">호스트모드로 전환</a></li>
                    <li><a href="logout.do">로그아웃</a></li>
                </ul>
            </div>
        </div>
    </section>
    <!-- e: header -->
   	<script type="text/javascript">
	   	function countEvent(addBtn, minusBtn, maxCount) {
	   	    // 더하기 버튼 클릭 이벤트
	   	    $(document).on('click', addBtn, function() {
	   	        let counter = $(this).closest('.count_box');
	   	        let $perCount = counter.find(".per_count");
	   	        let value = parseInt($perCount.val());
	   	        let $span = counter.find("span");
	
	   	        if (value < maxCount) {
	   	            value += 1;
	   	            $perCount.val(value);
	
	   	            if (value == maxCount) {
	   	            	$span.text("+");
	   	            }
	   	        }
	   	    });
	   	    // 빼기 버튼 클릭 이벤트
	   	    $(document).on('click', minusBtn, function() {
	   	        let counter = $(this).closest('.count_box');
	   	        let $perCount = counter.find(".per_count");
	   	        let value = parseInt($perCount.val());
	   	        let $span = counter.find("span");
	
	   	        if (value > 0) {
	   	            value -= 1;
	   	            $perCount.val(value);
	
	   	            if (value < maxCount) {
	   	                $span.text("명");
	   	            }
	   	        }
	   	    });
	   	}
	   	countEvent('#counter1 .plus_icon', '#counter1 .minus_icon', 16);

	   	function showPasswordModal() {
	        var modal = document.getElementById("passwordModal");
	        modal.style.display = "block";
	        document.getElementById("memberinfo").style.display = "none";
	        var passwordInput = document.getElementById("modalPassword");
	        passwordInput.focus();
	        
	        // 엔터키 이벤트 리스너 추가
	        passwordInput.addEventListener("keydown", function(event) {
	            if (event.key === "Enter") {
	            	checkPassword();
	            }
	        });
	    }
	    function checkPassword() {
	        var inputPw = document.getElementById("modalPassword").value;
			if (inputPw == ""){
				alert("비밀번호를 입력해 주세요.")
	            document.getElementById("modalPassword").focus();
				return;
			}
	        $.ajax({
	        	url : "passwdCheck.do",
	        	type : "post",
	        	data : {"inputPw" : inputPw},
	        	success : function(res){
	        		if (res == 'OK'){
	        			alert("확인되었습니다.")
	        			window.location.href = 'edit_form.do';
	        		} else{
	        			alert("비밀번호가 일치하지 않습니다.");
	                    document.getElementById("modalPassword").value = "";
	                    document.getElementById("modalPassword").focus();
	        		}
	        	},
	        	error : function(err){
	        		console.log(err);
	        		alert("비밀번호 확인 중 오류가 발생했습니다. 다시 시도해 주세요.");
	        	}
	        })
	    }
	    // 모달 닫기 함수
	    function closeModal() {
	        var modal = document.getElementById("passwordModal");
	        modal.style.display = "none";
	    }
	    // 외부 클릭 시 모달 닫기
	    window.onclick = function(event) {
	        var modal = document.getElementById("passwordModal");
	        if (event.target == modal) {
	            modal.style.display = "none";
	        }
	    }
	    let checkInVal = $("input[name='checkin']").val();
	    let checkOutVal = $("input[name='checkout']").val();
   	</script>