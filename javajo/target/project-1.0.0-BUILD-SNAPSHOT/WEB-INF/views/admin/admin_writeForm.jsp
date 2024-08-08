<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file="admin_top.jsp" %>
<!-- s: content -->
    <section id="admin_noticeadd" class="content">
        <div class="notice_wrap">
            <div class="noti_tit-box">
                <p class="noti_tit">공지사항</p>
            </div>
            <form name="f" action="write_noticeOk.do" method="post">
                <div class="insert_wrap">
                    <label class="insert_tit" for="noti_tit">
                    	<span>제목</span>
                        <input type="text" id="noti_tit" name="notice_title" value="" required />
                    </label>
                    <label class="insert_writer" for="noti_writer">
                    	<span>작성자</span>
                        <input type="text" id="noti_writer" name="user_id" value="${inUser.user_id}" readonly />
                    </label>
                    <label class="insert__cont" for="noti_cont">
                    	<span>내용</span>
                    	<textarea id="noti_cont" name="notice_content" cols="50" maxlength="200" wrap="hard" required ></textarea>
                    </label>
                </div>
                <div class="button_box">
                    <button class="submit_btn" type="submit" onclick="regisCheck()">등록</button>
                    <button class="reset_btn" type="reset" onclick="window.location='list_notice.do'">취소</button>
                </div>
            </form>
        </div>
    </section>
    <!-- e: content -->
<script type="text/javascript">
	function regisCheck(){
	    if(f.notice_title.value==""){
	       alert("제목을 입력해주세요.");
	       f.notice_title.focus();
	    }else if(f.notice_content.value==""){
	       alert("내용을 입력해주세요.");
	       f.notice_content.focus();
	    }else if(confirm("등록하시겠습니까?")==true){
	       document.editfrm.submit();
	    }else{
	       return false;
	    }
	 }
</script>
 <%@ include file="admin_bottom.jsp" %> 