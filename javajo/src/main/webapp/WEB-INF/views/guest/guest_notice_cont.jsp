<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ include file="guest_top.jsp" %>
    <!-- s: content -->
    <section id="notice_cont" class="content">
        <div class="notice_wrap">
            <div class="noti_tit-box">
                <p class="noti_tit">공지사항</p>
            </div>
            <div class="qna_box">
            	<div class="question_box">
                <label for="noti_tit">
                	<span>제목</span> <input type="text" id="noti_tit" name="" value=" ${getNoticeCont.notice_title}" readonly required />
                </label>
                <label for="noti_tit">
                	<c:set var="parsedDate" value="${getNoticeCont.notice_date}" />	                       
					<fmt:parseDate var="date" value="${parsedDate}" pattern="yyyy-MM-dd HH:mm:ss" />					
                	<span>등록일자</span> 
                	<input type="text" id="noti_tit" name="" value="<fmt:formatDate value="${date}" pattern="yyyy-MM-dd"/>" readonly required />
                </label>
				<label for="noti_cont"><span>내용</span></label>
				<textarea id="noti_cont" name="" cols="50" rows="10" wrap="hard" readonly readonly>${getNoticeCont.notice_content}</textarea>
	            </div>
	            
	            <div class="button_box"> 
	            	<a href = "notice.do"><button class="list_btn" type="button">목록보기</button></a>                   
	            </div>
        	</div>
        </div>
    </section>
    <!-- e: content -->
<%@ include file="guest_bottom.jsp" %>