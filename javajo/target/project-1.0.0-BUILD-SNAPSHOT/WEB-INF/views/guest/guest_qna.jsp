<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ include file="guest_top.jsp" %>
    <!-- s: content -->
    <section id="qna_list" class="content">
        <div class="qna_wrap">
            <div class="qna_tit-box">
                <p class="qna_tit">고객문의</p>
                <a class="qna_btn" >문의 등록</a>
            </div>
            <table class="qna_list j_table">
                <thead>
                    <tr>
                        <th class="qna_num">No</th>
                        <th class="qna_date">등록일</th>
                        <th class="qna_tit">제목</th>
                        <th class="qna_cate">문의 유형</th>
                        <th class="qna_writer">작성자</th>
                        <th class="qna_state">문의상태</th>
                    </tr>
                </thead>
                <tbody>
                	<c:if test="${empty qnaList}">
                		<tr>
                			<td colspan="6">등록된 문의내역이 없습니다.</td>
                		</tr>
                	</c:if>
                	<c:if test="${!empty qnaList}">
	                	<c:forEach var="dto" items="${qnaList}" varStatus="status">
		                    <tr>
		                        <td class="qna_num">${no - status.index}</td>
		                        <td class="qna_date">
			                        <c:set var="parsedDate" value="${dto.adminqna_date}" />	                       
								    <fmt:parseDate var="date" value="${parsedDate}" pattern="yyyy-MM-dd HH:mm:ss" />
								    <fmt:formatDate value="${date}" pattern="yyyy-MM-dd" />	
		                        </td>		                        
		                        <td class="qna_tit"><a href="qna_cont.do?adminqna_num=${dto.adminqna_num}"> ${dto.adminqna_title}</a></td>
		                        <td class="qna_cate">${dto.adminqna_type}</td>
		                        <td class="qna_writer">${dto.user_id}</td>
		                        <td class="qna_state">${dto.adminqna_status}</td>		                        
		                    </tr>
	                    </c:forEach>
	                </c:if>
                </tbody>                
            </table>
            <!-- 페이징 -->
	        <div class="pagination">
			    <c:if test="${startPage > pageBlock}"> 
			        <a class="page_btn prev_btn" href="qna_list.do?pageNum=${startPage-3}"><img src="resources/images/main/arrow.png" alt="" /></a>
			    </c:if>
			    
			    <c:forEach var="i" begin="${startPage}" end="${endPage}">
			        <c:set var="activeClass" value=""/>
			        <c:choose>
			            <c:when test="${empty param.pageNum and i == 1}">
			                <c:set var="activeClass" value="p_active"/>
			            </c:when>
			            <c:when test="${param.pageNum == i}">
			                <c:set var="activeClass" value="p_active"/>
			            </c:when>
			        </c:choose>
			        <a href="qna_list.do?pageNum=${i}" class="${activeClass} page_num">${i}</a>
			    </c:forEach>
			    
			    <c:if test="${pageCount > endPage}">
			        <a class="page_btn next_btn" href="qna_list.do?pageNum=${startPage+3}"><img src="resources/images/main/arrow.png" alt="" /></a>
			    </c:if>
			</div>
        </div>
		
        <div class="insert_box" style="display: none;">
            <p class="insert_tit">고객문의 등록</p>
            <form name="f" action="qna_insert.do" method="post" enctype="multipart/form-data">
                <div class="insert_wrap">
                    <label for="qna_type">문의유형
                        <select id="qna_type" name="adminqna_type">
                            <option value="site">사이트 이용문의</option>
                            <option value="house">숙소 이용문의</option>
                            <option value="refund">환불 문의</option>
                            <option value="etc">기타</option>
                        </select>
                    </label>
                    <label for="qna_tit">문의제목
                        <input type="text" id="qna_tit" name="adminqna_title" maxlength="20" required />
                    </label>
                    <label for="qna_cont">문의내용</label>
                        <textarea id="qna_cont" name="adminqna_gcontent" cols="50" maxlength="200" wrap="hard" placeholder="문의 내용을 작성해주세요. (200자 제한)" required ></textarea>
                    <div class="file_box">
                        <input class="file_name" value="첨부파일" placeholder="첨부파일" readonly>
                        <label for="file">파일찾기</label> 
                        <input type="file" id="file" name="file" accept="image/*" >
                    </div>
                </div>
                <div class="button_box">
	                <button class="submit_btn" type="submit">등록</button>
	                <button class="reset_btn" type="reset">취소</button>
            	</div> 
            </form>                  
        </div>
        <div class="dimm" style="display: none;"></div>
    </section>
    <!-- e: content -->
<%@ include file="guest_bottom.jsp" %>
<script type="text/javascript">
    // input 파일 커스텀
    $("#file").on('change',function(){
        var fileName = $("#file").val();
        $(".file_name").val(fileName);
    });
    // 문의등록 열기
    $('#qna_list .qna_btn').on('click',function () {
    	$('.dimm').show();
        $('.insert_box').show();        
    });
    // 문의등록 닫기
    $('#qna_list .reset_btn').on('click',function () {
        $('.insert_box').hide();
        $('.dimm').hide();
    });
</script>