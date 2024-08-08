<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!-- edit_form.jsp -->
<%@ include file="guest_top.jsp" %>
    <style>
	    #passwordDelModal {display: none; position: fixed; z-index: 10; left: 0;top: 0; overflow: auto; background-color: rgb(0,0,0); background-color: rgba(0,0,0,0.4); padding-top: 60px; width: 100%; height: 100%;}
		#passwordDelModal .modal-content {position: fixed; top:50%; left:50%; transform: translate(-50%, -50%); width: 400px; background-color: #fefefe; border-radius: 6px; padding: 30px 20px; text-align: center;}
		#passwordDelModal .close {position: absolute; top: 6px; right: 6px; display:inline-block; width: 26px; height: 26px;}
		#passwordDelModal .close img {width: 26px; height: 26px; cursor: pointer;}
		#passwordDelModal p {margin-bottom: 20px; font-size: 24px;}
		#passwordDelModal input {width: 180px; height: 32px; line-height: 32px; padding: 0 6px; border: 1px solid #ccc; border-radius: 2px; font-size: 22px;}
		#passwordDelModal button {width: 50px; border-radius: 6px; padding: 6px 0; background: #ff385d; font-size: 22px; color: #fff;}
    </style>
<body class="javajo">
    <!-- s: content -->
    <section id="edit_form" class="content">
        <div class="edit_box">
            <p class="edit_tit">회원정보</p>
            <form name="f" action="edit_form.do" method="post" onsubmit="return check()">
                <div class="edit_info">
                    <label for="id"><span>아이디</span>
                        <input type="text" id="id" name="user_id" value="${inUser.user_id}" readonly>
                    </label>
                    <label class="passwd" for="password"><span>새 비밀번호</span>
                    	<input type="password" class="password" id="password" name="user_passwd" value="" maxlength="16">
                    </label>
                    <label class="confirm_passwd" for="confirmpassword"><span>새 비밀번호 확인</span>
                        <input type="password" class="confirmpassword" id="confirmpassword" value="" maxlength="16">
                    </label>
                    <span class="pw_warning"></span>
                    <label for="name"><span>이름</span>
                        <input type="text" id="name" name="user_name" value="${inUser.user_name}">
                    </label>
                    <div class="hp_box">
                        <label for="hp1"><span>핸드폰 번호</span>
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
                    <div class="email_box">
                        <label for="email1"><span>현재 이메일</span>
                            <input type="text" id="email1" name="email1" value="${inUser.user_email1 }" maxlength="20" readonly>
                        </label>
                        @
                        <label for="email2">
                            <input type="text" name="email2" name="email2" value="${inUser.user_email2}" readonly>
                        </label>
					</div>    
                        <!-- 수정할 이메일 입력 -->
                        <c:if test="${inUser.user_loginType=='join'}">
              			<div class="email_box">
	                        <label for="email1"><span>변경 이메일</span>
	                           <input type="text" id="new_email1" name="user_email1" value="" maxlength="20">
	                        </label>
	                        @
	                        <label for="email2">
	                            <select id="new_email2" name="user_email2">
	                                <option value="naver.com">naver.com</option>
	                                <option value="nate.com">nate.com</option>
	                                <option value="gmail.com">gmail.com</option>
	                            </select>
	                        </label>
	                        <button class="accept_btn" type="button" onclick="sendEmail()">인증받기</button>
	                    </div>
	                    <div class="accept_box">
	                        <label for=""><span>인증번호</span>
	                            <input type="text" id="code" name="code" value="" maxlength="12">
	                        </label>
	                        <button class="confirm_btn" type="button" onclick="codeCheck()">인증확인</button>
	                    </div>
	                    </c:if>
                        <c:if test="${inUser.user_loginType!='join'}">
                        	<input type="hidden" name="user_email1" value="${inUser.user_email1}">
                        	<input type="hidden" name="user_email2" value="${inUser.user_email2}">
                        </c:if>
                        <ul class="pw_noti">
	                    	<li>* 비밀번호와 새 이메일은 변경을 원하시는 경우에만 작성해주세요.</li>
	                    	<li>* 소셜로그인 회원은 이메일 수정이 불가합니다.</li>
	                    </ul>
                </div>
                <div class="btn_box">
                    <button class="edit_btn" type="submit" >회원수정</button>
                    <button class="drop_btn" type="button" onclick="showPasswordDelModal()">회원탈퇴</button>
                </div>
            </form>
            <!-- 비밀번호확인 modal -->
			<div id="passwordDelModal" class="modal">
		        <div class="modal-content">
		            <span class="close" onclick="closeDelModal()"><img src="resources/images/main/close.png" alt="" /></span>
		            <p>아이디를 삭제하려면 비밀번호를 입력하세요</p>
		            <input type="password" id="modalDelPassword" placeholder="비밀번호 입력">
		            <button onclick="checkDelPassword()"> 확인</button>
		        </div>
		    </div>
        </div>
    </section>
    <!-- e: content -->
</body>
<script type="text/javascript">
function showPasswordDelModal() {
   var modalDel = document.getElementById("passwordDelModal");
   modalDel.style.display = "block";
   var passwordInput = document.getElementById("modalDelPassword");
   passwordInput.focus();
   
   // 엔터키 이벤트 리스너 추가
   passwordInput.addEventListener("keydown", function(event) {
       if (event.key === "Enter") {
    	   checkDelPassword();
       }
   });
}
function checkDelPassword() {
   var inputPw = document.getElementById("modalDelPassword").value;
	if (inputPw == ""){
		alert("비밀번호를 입력해 주세요.")
       document.getElementById("modalDelPassword").focus();
		return;
	}
   $.ajax({
   	url : "passwdCheck.do",
   	type : "post",
   	data : {"inputPw" : inputPw},
   	success : function(res){
   		if (res == 'OK'){
   			alert("확인되었습니다.")
   			location.href = 'enable_user.do';
   		} else{
   			alert("비밀번호가 일치하지 않습니다.");
               document.getElementById("modalDelPassword").value = "";
               document.getElementById("modalDelPassword").focus();
   		}
   	},
   	error : function(err){
   		console.log(err);
   		alert("비밀번호 확인 중 오류가 발생했습니다. 다시 시도해 주세요.");
   	}
   })
}
// 모달 닫기 함수
function closeDelModal() {
   var modalDel = document.getElementById("passwordDelModal");
   modalDel.style.display = "none";
}
// 외부 클릭 시 모달 닫기
	window.onclick = function(event) {
	   var modalDel = document.getElementById("passwordDelModal");
	   if (event.target == modalDel) {
	   	modalDel.style.display = "none";
	   }
	}
	let mck = true;
	function sendEmail(){
		let email1 = $('#new_email1').val().trim();
		let email2 = $('#new_email2').val().trim();
		let mode = "edit";
		if (email1 === ""){
			alert("이메일주소를 입력해 주세요")
			return $("#new_email1").focus();
		}
		$.ajax({
		    url: 'emailCheck.do',
		    type: 'POST',
		    data:{	
		          "user_email1": email1,
		          "user_email2": email2,
		          "mode" : mode
		    },
		    success: function(res) {
		    	if (res == 'OK'){
		    	$.ajax({
				    url: 'sendEmail.do',
				    type: 'POST',
				    data:{	
				          "user_email1": email1,
				          "user_email2": email2,
				          "mode" : mode
				    },
				    success: function(res) {
				    	if(res == 'OK'){
				        	alert("인증메일을 발송하였습니다.")
				        	mck = false;
				        	$('.accept_btn').text("재전송");
						    $('.accept_box').show();
				    	} else {
				    		alert("인증메일발송실패")
				    	}
				    },
				    error : function(err){
						console.log(err);
				    }
				})
		    	} else {
				    	alert("이미 등록된 이메일 입니다.")
		    	}
		    },
		    error : function(err){
				console.log(err);
		    }
		});
	};
	
	function codeCheck(){
	    let code = $('#code').val(); // 입력한 코드 가져오기
	    $.ajax({
	        url: 'codeCheck.do',
	        type: 'POST',
	        data: { "code" : code },
	        success: function(res) {
	            if (res =='OK') {
	                alert("인증 성공!");
	                mck = true;
	            } else {
	                alert("인증 실패! 다시 입력해주세요.");
	                $("#code").val("");
					$("#code").focus();
					mck = false;
	            }
	        },
	        error: function(err) {
	            console.error(err);
	            mck = false;
	        }
	    });
	};
	
	function check(){
		let email1 = $('#new_email1').val();
		let code = $('#code').val();
		if (email1 != ""){
			if (code == ""){
				alert("이메일 인증을 먼저 해주세요");
				return false;
			}
			if (mck == false){
				alert("이메일 인증을 먼저 해주세요");
				return false;
			}
		}
		
		let password = $('#password').val();
		let confirmpassword = $('#confirmpassword').val();
		
		if (password != ""){
			if (password != confirmpassword){
				alert("비밀번호가 일치하지 않습니다.")
				return false;
			}	
		} 
		 return true;
	};
	
    $('.passwd, .confirm_passwd').on('input', function() {
        let passWord = $('.password').val();
        let confirmPassword = $('.confirmpassword').val();

        if (passWord === '' && confirmPassword === '') {
        $('.pw_warning').text('');
    } else if (passWord === confirmPassword) {
        $('.pw_warning').text('* 비밀번호가 일치합니다.');
    } else {
        $('.pw_warning').text('* 비밀번호가 일치하지 않습니다.');
    };
        
    });
    $('input[name=user_passwd]').on('input',function () {
        $(this).val($(this).val().replace(/[^a-zA-Z0-9!@#$%^&*()_+\-=\[\]{};':"\\|,.<>\/?]/g, ''));
    });
    $('input[name=user_hp2], input[name=user_hp3]').on('input',function () {
 	   $(this).val($(this).val().replace(/[^\d]/g, ''));
    });
</script>
</html>
<%@ include file="guest_bottom.jsp" %>