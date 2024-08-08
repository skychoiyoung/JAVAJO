<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!-- edit_form.jsp -->
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Index</title>
	<link rel="stylesheet" type="text/css" href="resources/css/reset.css">
	<link rel="stylesheet" type="text/css" href="resources/css/index_guest.css">
    <link rel="stylesheet" href="http://code.jquery.com/ui/1.12.1/themes/base/jquery-ui.css">
	<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    <script src="resources/js/script.js"></script>
    <style>
	    #passwordDelModal {display: none; position: fixed; z-index: 10; left: 0;top: 0; overflow: auto; background-color: rgb(0,0,0); background-color: rgba(0,0,0,0.4); padding-top: 60px; width: 100%; height: 100%;}
		#passwordDelModal .modal-content {position: fixed; top:50%; left:50%; transform: translate(-50%, -50%); width: 400px; background-color: #fefefe; border-radius: 6px; padding: 30px 20px; text-align: center;}
		#passwordDelModal .close {position: absolute; top: 6px; right: 6px; display:inline-block; width: 26px; height: 26px;}
		#passwordDelModal .close img {width: 26px; height: 26px; cursor: pointer;}
		#passwordDelModal p {margin-bottom: 20px; font-size: 24px;}
		#passwordDelModal input {width: 180px; height: 32px; line-height: 32px; padding: 0 6px; border: 1px solid #ccc; border-radius: 2px; font-size: 22px;}
		#passwordDelModal button {width: 50px; border-radius: 6px; padding: 6px 0; background: #ff385d; font-size: 22px; color: #fff;}
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
    <!-- s: content -->
    <section id="social_edit" class="content">
        <div class="edit_box">
            <p class="edit_tit">회원정보 수정</p>
            <form name="f" action="edit_form.do" method="post" onsubmit="return check()">
                <div class="edit_info">
                    <label for="id"><span>아이디 :</span>
                    	<input type="text" id="id" name="user_id" value="${inUser.user_id}" readonly>
                    </label>
                    <label class="passwd" for="password"><span>비밀번호 :</span>
                    	<input type="password" class="password" id="password" name="user_passwd" value="" maxlength="16" required>
                    </label>
                    <label class="confirm_passwd" for="confirmpassword"><span>비밀번호 확인 :</span>
                        <input type="password" class="confirmpassword" id="confirmpassword" value="" maxlength="16" required>
                    </label>
                    <span class="pw_warning"></span>
                    <label for="name"><span>이름 :</span>
                        <input type="text" id="name" name="user_name" value="${inUser.user_name}">
                    </label>
                    <c:if test="${param.sr=='srg'}">
                    <div class="hp_box">
                        <label for="hp1"><span>핸드폰 번호 :</span>
                            <select name="user_hp1">
                                <option value="010">010</option>
                                <option value="016">016</option>
                                <option value="017">017</option>
                                <option value="018">018</option>
                                <option value="019">019</option>
                            </select>
                        </label> - 
                        <label for="hp2"></label>
                        	<input class="input_tel" type="text" name="user_hp2" value="" maxlength="4" required> - 
                        <label for="hp3"></label>
                        	<input class="input_tel" type="text" name="user_hp3" value="" maxlength="4" required>
                    </div>    	
                    </c:if>
                    <c:if test="${param.sr!='srg'}">
                    <div class="hp_box">
                        <label for="hp1"><span>핸드폰 번호 :</span>
                            <select name="user_hp1">
                                <option value="010">010</option>
                                <option value="016">016</option>
                                <option value="017">017</option>
                                <option value="018">018</option>
                                <option value="019">019</option>
                            </select>
                        </label> - 
                        <label for="hp2"></label>
                        	<input class="input_tel" type="text" name="user_hp2" value="${inUser.user_hp2}" maxlength="4" required> - 
                        <label for="hp3"></label>
                        	<input class="input_tel" type="text" name="user_hp3" value="${inUser.user_hp3}" maxlength="4" required>
                    </div>
                    </c:if>
                    <div class="email_box">
                        <label for="email1"><span>현재 이메일 :</span>
                            <input type="text" id="email1" name="email1" value="${inUser.user_email1 }" maxlength="20" readonly>
                        </label>
                        @
                        <label for="email2">
                            <input type="text" name="email2" name="email2" value="${inUser.user_email2}" readonly>
                        </label>
					</div>    
					<input type="hidden" name="user_email1" value="${inUser.user_email1}">
					<input type="hidden" name="user_email2" value="${inUser.user_email2}">
                </div>
                <div class="btn_box">
                    <button class="edit_btn" type="submit" >회원수정</button>
                    <c:if test="${empty param.sr}">
                    <button class="edit_btn" type="button" onclick="location.href='guest_index.do'">수정취소</button>
                    <button class="drop_btn" type="button" onclick="showPasswordDelModal()">회원탈퇴</button>
                    </c:if>
                </div>
            </form>
        </div>
    </section>
    <!-- e: content -->
</body>
<script type="text/javascript">
	function check(){
		let password = $('#password').val();
		let confirmpassword = $('#confirmpassword').val();
		
		if (password != ""){
			if (password != confirmpassword){
				alert("비밀번호가 일치하지 않습니다.")
				return false;
			}	
		} 
		 return true;
	}
	
    $('.passwd, .confirm_passwd').on('input', function() {
        let passWord = $('.password').val();
        let confirmPassword = $('.confirmpassword').val();

        if (passWord === '' && confirmPassword === '') {
        $('.pw_warning').text('');
    } else if (passWord === confirmPassword) {
        $('.pw_warning').text('* 비밀번호가 일치합니다.');
    } else {
        $('.pw_warning').text('* 비밀번호가 일치하지 않습니다.');
    }
        
    });
    $('input[name=user_passwd]').on('input',function () {
        $(this).val($(this).val().replace(/[^a-zA-Z0-9!@#$%^&*()_+\-=\[\]{};':"\\|,.<>\/?]/g, ''));
    })
    $('input[name=user_hp2], input[name=user_hp3]').on('input',function () {
 	   $(this).val($(this).val().replace(/[^\d]/g, ''));
    })
</script>
</html>
