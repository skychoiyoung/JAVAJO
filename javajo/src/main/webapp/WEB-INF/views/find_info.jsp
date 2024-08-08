<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!-- find_info.jsp -->
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>아이디/비밀번호 찾기</title>
	<link rel="stylesheet" type="text/css" href="resources/css/reset.css">
	<link rel="stylesheet" type="text/css" href="resources/css/index_guest.css">
    <script src="https://code.jquery.com/jquery-3.7.1.min.js"></script>
    <script src="resources/js/script.js"></script>
    
    <script type="text/javascript">
    </script>
</head>
<body>
    <!-- s: find_info -->
    <section id="find_info">
        <div class="find_box">
        	<c:choose>
	            <c:when test="${mode == 'id'}">
	                <p class="find_tit">아이디찾기</p>
	            </c:when>
	            <c:when test="${mode == 'pw'}">
	                <p class="find_tit">비밀번호찾기</p>
	            </c:when>
       		</c:choose>
            <form name="f" action="find_info.do" method="post">
                <div class="find_info">
                	<c:if test="${mode == 'pw'}">
	                    <label for="id"><span>아이디</span>
	                        <input type="text" id="id" name="user_id" maxlength="10" required>
	                    </label>
	                </c:if>
                    <label for="name"><span>이름</span>
                        <input type="text" id="name" name="user_name" maxlength="7" required>
                    </label>
                    <div class="hp_box">
                    	<span>핸드폰 번호</span>
                        <label for="hp1">
                            <select name="user_hp1">
                                <option value="010">010</option>
                                <option value="016">016</option>
                                <option value="017">017</option>
                                <option value="018">018</option>
                                <option value="019">019</option>
                            </select>
                        </label> - 
                        <label for="hp2"></label>
                        <input type="text" id="hp2" name="user_hp2" maxlength="4" required style="text-align: center;"> - 
                        <label for="hp3"></label>
                        <input type="text" id="hp3" name="user_hp3" maxlength="4" required style="text-align: center;">
                    </div>
                    <div class="email_box">
                        <label for="email1"><span>이메일</span>
                            <input type="text" id="email1" name="user_email1" value="" maxlength="17" required>
                        </label>
                        @
                        <label for="email2">
                            <select name="user_email2">
                                <option value="naver.com">naver.com</option>
                                <option value="nate.com">nate.com</option>
                                <option value="gmail.com">gmail.com</option>
                            </select>
                        </label>
                    </div>
                </div>
                <button class="find_btn" type="submit">
                	<c:choose>
	                    <c:when test="${mode == 'id'}">
	                        <span>아이디찾기</span>
	                    </c:when>
	                    <c:when test="${mode == 'pw'}">
	                        <span>비밀번호찾기</span>
	                    </c:when>
	                </c:choose>
                </button>
            </form>
        </div>
    </section>
    <!-- e: find_info -->
</body>
<script type="text/javascript">
    $('input[name=user_id], input[name=user_email1]').on('input',function () {
        // $(this).val($(this).val().replace(/[^a-zA-Z0-9]/g, '')); // 대문자 입력 가능
        $(this).val($(this).val().replace(/[^a-z0-9]/g, '')); // 대문자 입력 불가
    })
    // 영어 + 숫자 입력

    $('input[name=user_hp2], input[name=user_hp3]').on('input',function () {
        $(this).val($(this).val().replace(/[^\d]/g, ''));
    })
    // 숫자만 입력
</script>
</html>