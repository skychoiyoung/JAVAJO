<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!-- login_form.jsp -->
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Index</title>
	<link rel="stylesheet" type="text/css" href="resources/css/reset.css">
	<link rel="stylesheet" type="text/css" href="resources/css/index_guest.css">
     <script src="https://code.jquery.com/jquery-3.7.1.min.js"></script>
    <script src="resources/js/script.js"></script>
    <script type="text/javascript" src="https://static.nid.naver.com/js/naveridlogin_js_sdk_2.0.0.js" charset="utf-8"></script>
    <script src="https://developers.kakao.com/sdk/js/kakao.js"></script>
</head>
<body class="javajo javajo_index">
    <!-- s: content -->
    <section id="login_form" class="content">
        <div class="login_box">
            <p class="login_tit">로그인</p>
            <p class="login_desc">자바조에 오신것을 환영합니다.</p>
            <form name="f" action="login.do" method="post">
            	<div class="login_info_wrap">
	                <div class="login_info">
		                <label>
		                    <c:if test ="${empty cookie['saveId']}">
		                    	<input class="login_id" name="user_id" type="text" value="" maxlength="12" placeholder="UserId" required>
		                    </c:if>
		                    <c:if test ="${not empty cookie['saveId']}">
		                    	<input class="login_id" name="user_id" type="text" value="${cookie['saveId'].value}" maxlength="12" placeholder="UserId" required>
		                    </c:if>
		                </label>
		                <label>
		                    <input type="password" name="user_passwd" value="" maxlength="16" placeholder="PassWord" required>
		                </label>
	                </div>
	                <p class="id_check">아이디 기억하기
	                	<c:if test="${empty cookie['saveId']}">
		                	<input type="checkbox" name="saveId">
		                </c:if>
		                <c:if test="${not empty cookie['saveId']}">
		                	<input type="checkbox" name="saveId" checked>
		                </c:if>
	                </p>
            	</div>
                <div class="find_info">
                    <a href="javascript:findInfo('id')">아이디 찾기</a>
                    <a href="javascript:findInfo('pw')">비밀번호 찾기</a>
                	<a href="join_form.do">회원가입</a>
                </div>
                <button class="login_btn" type="submit">로그인</button>
            </form>
            <!-- 네이버, 카카오 로그인 -->
            <div class="other_login">
            	<p>SNS 로그인</p>
	  			<div class="sns_login">
	  				<a class="gg_btn log_btn" href="${googleUrl}"><img src="https://test.codemshop.com/wp-content/plugins/mshop-mcommerce-premium-s2/lib/mshop-members-s2/assets/images/social/logo/Google.png" style="background: #fff;" /></a>
		  			<a class="nv_bnt log_btn" href="${naverUrl}" ><img style="width: 100%; height: 100%;" src="https://test.codemshop.com/wp-content/plugins/mshop-mcommerce-premium-s2/lib/mshop-members-s2/assets/images/social/icon_1/Naver.png"/></a>
	     			<a class="kk_btn log_btn" href="${kakaoUrl}"><img style="width: 100%; height: 100%;" src="https://test.codemshop.com/wp-content/plugins/mshop-mcommerce-premium-s2/lib/mshop-members-s2/assets/images/social/icon_1/Kakao.png"/></a>
	       		</div>
            </div>
     	</div>
    </section>
    <!-- e: content -->
</body>
<script>
    function findInfo(mode){
		let wWidth = 550;
		let wHeight = 400;
		let wLeft = (screen.width - wWidth) / 2;
		let wTop = (screen.height - wHeight) / 2;
    	window.open("find_info.do?mode=" + mode, "search", "width=" + wWidth + ", height=" + wHeight + ", left=" + wLeft + ", top=" + wTop + ", resizable=no");
	}
    $('input[name=user_id]').on('input',function () {
        $(this).val($(this).val().replace(/[^a-z0-9]/g, '')); // 대문자 입력 불가
    })
    // 영어 + 숫자 입력
    $('input[name=passwd]').on('input',function () {
        $(this).val($(this).val().replace(/[^a-zA-Z0-9!@#$%^&*()_+\-=\[\]{};':"\\|,.<>\/?]/g, ''));
    })
    // 영어(대/소) + 숫자 + 특수문자 입력
</script>
</html>