<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Index</title>
	<link rel="stylesheet" type="text/css" href="resources/css/reset.css">
    <link rel="stylesheet" type="text/css" href="resources/css/index_admin.css">
    <link rel="stylesheet" href="http://code.jquery.com/ui/1.12.1/themes/base/jquery-ui.css">
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    <script src="https://code.jquery.com/ui/1.12.1/jquery-ui.js"></script>
</head>
<body class="javajo">
    <!-- s:header -->
    <section id="admin_top" class="header">
        <div class="inner_admin_top">
            <!-- 사이트 로고 -->
            <div class="logo_box">
                <a href="list_notice.do"><img src="resources/images/logo/javajo_admin_logo.jpg" alt="javajo 로고" /></a>
            </div>

            <ul class="admin_link">
                <li><a href="list_user.do">회원조회</a></li>
                <li><a href="list_notice.do">공지사항</a></li>
                <li><a href="customer_qna.do">고객문의</a></li>
                <li><a href="settlement_manage.do">정산관리</a></li>
            </ul>

            <div class="admin_logout">
            	<div class="user_box">
            		<img src="resources/images/main/crown.png" alt="" />
	                <p><span>${inUser.user_id}</span> 님</p>
            	</div>
                <button type="button" onclick="window.location='logout.do'">로그아웃</button>
            </div>
        </div>
    </section>
    <!-- e: header -->
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
