<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8" %>
<%@ include file="admin_top.jsp" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
  	<!-- s: content -->
    <section id="admin_custome_noti" class="content">
        <div class="notice_wrap">
            <div class="noti_tit-box">
                <p class="noti_tit">고객문의</p>
            </div>
            <div class="question_box">
             
                <div class="question_wrap">
                	<label class="question_tit" for="noti_tit">
                    	<span>제목</span>
                        <input type="text" id="noti_tit" name="adminqna_notice_title" value="${getAdminQnaByNum.adminqna_title}" readonly />
                    </label>
                    <label class="question_type" for="noti_type">
                    	<span>문의 유형</span>
                        <input type="text" id="noti_type" name="adminqna_notice_type" value="${getAdminQnaByNum.adminqna_type}" readonly />
                    </label>
                    <label class="question_writer" for="noti_writer">
                    	<span>작성자</span>
                        <input type="text" id="noti_writer" name="adminqna_notice_writer" value="${getAdminQnaByNum.user_id}" readonly />
                    </label>
                    <c:if test="${not empty getAdminQnaByNum.adminqna_image}">
                    <div class="qna_img_box">
	                    <label class="question_cont" for="noti_cont">
	                    	<p>내용</p>
	                    	<textarea id="noti_cont" name="" cols="50" maxlength="200" wrap="hard" readonly style="width: 400px;" >${getAdminQnaByNum.adminqna_gcontent}</textarea>
	                    </label>
	              		<div class="question_img">
	              			<p>첨부파일 이미지</p>
	              			<c:if test="${not empty getAdminQnaByNum.adminqna_image}">
		              			<img src="resources/upload_adminQna/${getAdminQnaByNum.adminqna_image}" width="150px" height="120px" style="cursor: pointer;" onclick="openImage('resources/upload_adminQna/${dto.adminqna_image}')">		              	
		              		</c:if>
	              			<c:if test="${empty getAdminQnaByNum.adminqna_image}">
		              			<div class="img_none">
			              			<p>첨부된 이미지가 없습니다.</p>
		              			</div>
		              		</c:if>
	              		</div>
                    </div>
                    </c:if>
                    <c:if test="${empty getAdminQnaByNum.adminqna_image}">
		            <div class="qna_img_box">
	                    <label class="question_cont" for="noti_cont">내용
	                    	<textarea id="noti_cont" name="" cols="50" maxlength="200" wrap="hard" readonly style="width: 688px;" >${getAdminQnaByNum.adminqna_gcontent}</textarea>
	                    </label>
                    </div>
             		</c:if>
                </div>
            </div>
            <!-- admin 내용이 비어있지 않다면 삭제 버튼-->
			<c:if test="${not empty getAdminQnaByNum.adminqna_acontent}">
            <form name="f" action="adminQnaDelete.do?adminqna_num=${getAdminQnaByNum.adminqna_num}" method="post">
               <input type="hidden" value="${getAdminQnaByNum.adminqna_num}" name="adminqna_num">
               <div class="answer_box">
                    <div class="answer_wrap">
                    <!-- 
                        <label class="answer_writer" for="noti_writer2">답변상태
                            <input type="text" id="noti_writer2" name="adminqna_status" value="${getAdminQnaByNum.adminqna_status}" readonly />
                        </label>
                     -->
                        <label class="answer_cont" for="noti_cont2">답변내용</label> 
                        <textarea id="noti_cont2" name="adminqna_gcontent" cols="50" maxlength="200" wrap="hard" required >${getAdminQnaByNum.adminqna_acontent}</textarea>
                    </div>
                    <div class="button_box">
                        <button class="reset_btn" type="button" onclick="window.location='customer_qna.do'">목록</button>
                        <!-- <button class="edit_btn" type="submit">답글달기</button> -->
                    	<button class="reset_btn" type="submit" name="removefrm" onclick="removeCheck()">답글삭제</button>
                    	<!-- <a href="#" type="button" onclick="deleteAdminQna(event)">삭제</a> -->
                    </div>
                </div>
            </form>
            </c:if>
            <!-- admin 답변내용이 비어있다면 답글달기 -->
            <c:if test="${empty getAdminQnaByNum.adminqna_acontent}">
            <form name="f" action="adminQnaEdit.do" method="post">
                <input type="hidden" value="${getAdminQnaByNum.adminqna_num}" name="adminqna_num">
                <div class="answer_box">
                    <div class="answer_wrap">
                        <label class="answer_cont" for="noti_cont2">답변내용 </label> 
                        <textarea id="noti_cont2" name="adminqna_acontent" cols="50" maxlength="200" wrap="hard" required ></textarea>
                    </div>
                    <div class="button_box">
                        <button class="reset_btn" type="button" onclick="window.location='customer_qna.do'">목록</button>
                    	<button class="edit_btn" type="submit" name="editfrm" onclick="editCheck()">답글달기</button>
                    </div>
                </div>
            </form>
            </c:if>
        </div>
        
    </section>
    <!-- e: content -->
    <script type="text/javascript">
    function editCheck(){
	    if(f.adminqna_acontent.value==""){
	       alert("답변내용을 입력해주세요.");
	       f.adminqna_acontent.focus();
	    }else if(confirm("등록하시겠습니까?")==true){
	       document.editfrm.submit();
	    }else{
	       return false;
	    }
	 }

	function removeCheck(){
		if(confirm("삭제하시겠습니까?")==true){
			document.removefrm.submit();
		}else{
			return false;
		}
	}
</script>
    
<%@ include file="admin_bottom.jsp" %>
  	