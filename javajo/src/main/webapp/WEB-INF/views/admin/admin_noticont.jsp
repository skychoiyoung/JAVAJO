<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file="admin_top.jsp" %>
<!-- s: content -->
    <section id="admin_noticeedit" class="content">
        <div class="notice_wrap">
            <div class="noti_tit-box">
                <p class="noti_tit">공지사항</p>
            </div>
            <form name="f" action="update_noticeOk.do" method="post">
            <input type="hidden" name="notice_num" value="${getNotice.notice_num}">
                <div class="insert_wrap">
                    <label class="insert_tit" for="noti_tit">
                    	<span>제목</span>
                        <input type="text" id="noti_tit" name="notice_title" value="${getNotice.notice_title}" readonly />
                    </label>
                    <label class="insert_writer" for="noti_writer">
                    	<span>작성자</span>
                        <input type="text" id="noti_writer" name="" value="${getNotice.user_id}" readonly />
                    </label>
                    <label class="insert__cont" for="noti_cont">
                    	<span>내용</span>
                    	<textarea id="noti_cont" name="notice_content" cols="50" maxlength="200" wrap="hard" readonly>${getNotice.notice_content}</textarea>
                    </label>
                </div>
                <div class="button_box">
                 	<button class="reset_btn" type="button" onclick="window.location='list_notice.do'">목록</button>
                    <button class="reset_btn" type="button" name="removefrm" onclick="removeCheck()">삭제</button>
                </div>
            </form>
        </div>
    </section>
    <!-- e: content -->
<script type="text/javascript">
	function removeCheck(){
		if(confirm("삭제하시겠습니까?")){
			window.location="delete_noticeOk.do?notice_num=${getNotice.notice_num}"
		}else{
			return;
		}
	}
</script>
<!-- e: footer -->
<%@ include file="admin_bottom.jsp" %>