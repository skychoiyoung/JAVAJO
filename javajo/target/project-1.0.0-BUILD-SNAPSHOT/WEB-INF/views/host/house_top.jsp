<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Index</title>
	<link rel="stylesheet" type="text/css" href="resources/css/reset.css">
	<link rel="stylesheet" type="text/css" href="resources/css/index_host.css">
    <script src="https://cdn.jsdelivr.net/momentjs/latest/moment.min.js"></script>
    <link rel="stylesheet"href="https://code.jquery.com/ui/1.12.1/themes/base/jquery-ui.css">
	<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
	<script src="https://code.jquery.com/ui/1.12.1/jquery-ui.min.js"></script>
    <script type="text/javascript">
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
    <section id="host_top" class="header">
        <div class="inner_header">
            <!-- 사이트 로고 -->
            <div class="logo_box">
                <a href="manageHouse.do">
                    <img src="resources/images/logo/javajo_host_logo.jpg" alt="javajo 로고" />
                </a>
            </div>
            <!-- s: 회원 관리 -->
            <div class="member_box">
                <div class="member_icons togglebtn" data-target="#memberinfo">
                    <img class="mem_icon mem_icon1" src="resources/images/main/user.png" alt="회원 아이콘"/>
                    <p><span>${inUser.user_id} </span>님 환영합니다.</p>
                    <img class="mem_icon mem_icon2" src="resources/images/main/menubar.png" alt="메뉴바 아이콘"/>
                </div>
                <ul id="memberinfo" class="member_detail searchOptBox">
                    <li><a href="manageHouse.do">숙소관리</a></li>
                    <li><a href="reservHouse.do">예약내역</a></li>
                    <li><a href="moneyManage.do">정산관리</a></li>
                    <li><a href="guest_index.do">게스트모드로 전환</a></li>
                    <li><a href="logout.do">로그아웃</a></li>
                </ul>
            </div>
        </div>
    </section>
    <!-- e: header -->
    <script>
  	//토글기능 함수
    function toggleEvt(toggleBtn) {
  	    $(toggleBtn).on('click', function(event) {
  	        let target = $(this).data('target');
  	        $(target).toggle();
  	        event.stopPropagation();
  	    });
  	    $(document).click(function(event) {
  	        var $target = $(event.target);
  	        if (!$target.closest('.searchOptBox').length && !$target.closest(toggleBtn).length) {
  	            $('.searchOptBox').hide();
  	        }
  	    });
  	}
    toggleEvt('.togglebtn');
    </script>