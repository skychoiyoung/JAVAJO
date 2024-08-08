<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ include file="guest_top.jsp" %>
    <!-- s: content -->
    <section id="admin_custome_noti" class="content">
        <div class="question_wrap">
            <div class="question_tit-box">
                <p class="question_tit">고객문의</p>
            </div>
            <c:forEach var="dto" items="${qnaContList}">
	            <div class="question_box">           		
	               	<div class="question_wrap">
	               		<label for="qna_tit"><span>제목</span>
	                        <input type="text" id="qna_tit" name="" value="${dto.adminqna_title}" readonly />
	                    </label>
	                    <label for="qna_type"><span>문의 유형</span>
	                        <input type="text" id="qna_type" name="" value="${dto.adminqna_type}" readonly />
	                    </label>
	                    <label for="qna_writer"><span>작성자</span>
	                        <input type="text" id="qna_writer" name="" value="${dto.user_id}" readonly />
	                    </label>
	                    <c:if test="${not empty dto.adminqna_image}">
	              		<div class="qna_img_box">
		                    <label class="question_cont" for="question_cont"><p>내용</p>
		                    	<textarea id="question_cont" name="" cols="150" maxlength="200" wrap="hard" readonly style="width: 400px;" >${dto.adminqna_gcontent}</textarea>
		                    </label>
	              			<c:if test="${not empty dto.adminqna_image}">
		              		<div class="question_img">
		              			<p>첨부파일 이미지</p>
	              				<img src="resources/upload_adminQna/${dto.adminqna_image}" style="cursor: pointer;" onclick="openImage('resources/upload_adminQna/${dto.adminqna_image}')">		              	
		              		</div>
	              			</c:if>
	                    </div>
              			</c:if>
              			<c:if test="${empty dto.adminqna_image}">
		              	 <div class="qna_img_box">
		                    <label class="question_cont" for="question_cont"><p>내용</p>
		                    	<textarea id="question_cont" name="" cols="150" maxlength="200" wrap="hard" readonly style="width: 688px;" >${dto.adminqna_gcontent}</textarea>
		                    </label>
	                    </div>
              			</c:if>
	                   
	              	</div>               
	            </div>
				<c:if test="${not empty dto.adminqna_acontent}">
	                <div class="answer_box">
	                    <div class="answer_wrap">
	                        <label class="answer_cont" for="answer_cont">관리자 답변내용</label>
	                        <textarea id="answer_cont" name="" cols="150" maxlength="200" wrap="hard" readonly>${dto.adminqna_acontent}</textarea>
	                    </div>
	                </div>
	            </c:if>
             
	            <div class="answer_box" align="center">
	            	<a href="qna_list.do"><button class="list_btn" type="button">목록</button></a>
	            	<c:if test="${empty dto.adminqna_acontent}">
	            		<a href="qna_del.do?adminqna_num=${dto.adminqna_num}"><button class="reset_btn" type="button">삭제</button></a>
	            	</c:if>
	            </div>
            </c:forEach>    
        </div>
    </section>
    <!-- e: content -->
<%@ include file="guest_bottom.jsp" %>
<script type="text/javascript">
 function openImage(imageUrl) {
     window.open(imageUrl, 'Image', 'width=800,height=600,resizable=yes');
 }
</script>