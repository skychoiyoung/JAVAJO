<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ include file="guest_top.jsp" %>
     <!-- s: content -->
    <section id="main" class="content search_main">
    	<div class="sort_box">
    		<c:if test="${not empty searchResult}" > 
		    <form method="get">
		        <select class="sortForm" id="sortForm" name="sort" onchange="updateSearchList()" style="outline:none;">
		            <option value="score" ${searchParams.sort == 'score' ? 'selected' : ''}>인기순</option>
		            <option value="price" ${searchParams.sort == 'price' ? 'selected' : ''}>가격낮은순</option>
		            <option value="num" ${searchParams.sort == 'num' ? 'selected' : ''}>최신등록순</option>
		        </select>
		        <input type="hidden" id="search_area" value="${searchParams.area}"/>
		        <input type="hidden" id="search_checkin" value="${searchParams.checkin}"/>
		        <input type="hidden" id="search_checkout" value="${searchParams.checkout}"/>
		        <input type="hidden" id="search_per_count" value="${searchParams.per_count}"/>
		        <input type="hidden" id="search_build_type" value="${searchParams.build_type}"/>
		        <input type="hidden" id="search_room_cnt" value="${searchParams.room_cnt}"/>
		        <input type="hidden" id="search_bed_cnt" value="${searchParams.bed_cnt}"/>
		        <input type="hidden" id="search_bath_cnt" value="${searchParams.bath_cnt}"/>
		    </form>
		    </c:if>
		</div>
	    			
		
		<!-- s: 검색 컨텐츠 -->	
		
    	<c:if test="${not empty searchResult}" >    
    		<!-- s: 검색결과 문구 -->
	    	<div class="search_none">
		    	<p>총 ${searchResultCnt}건의 숙소가 조회되었습니다.</p>
			</div>
			<!-- e: 검색결과 문구  -->		
	    	<div>
				<ul class="cate_cont">    
				<c:forEach var="sdto" items="${searchResult}">
				   <li class="cont_item">                                
				       <a href="house_info.do?house_num=${sdto.house_num}">
				           <div class="cont_img">
				           	   <!-- 숙소 이미지 -->
				               <img src="resources/upload_house_images/${sdto.house_image1}" style="width: 100%; height: 100%;">
				               <!-- 게스트 선호 아이콘 -->
		                    	<c:forEach var="pdto" items="${guestPreferList}">
		                    		<c:if test="${sdto.house_num == pdto.house_num}">
			                        	<p class="cont_tag">게스트 선호</p>
			                        </c:if>
		                       	</c:forEach>
		                       	<!-- 위시리스트 버튼 아이콘 -->	               
							    <p class="">			                        		
		                       		<input type="button" name="wishBtn" class="cont_like wishBtn" onclick="wishClick(event, this)">
		                       		<c:forEach var="wdto" items="${wishList}">	                        		                      		
		                        		<c:if test="${wdto.house_num == pdto.house_num}">
				                            <input type="button" name="wishBtn" class="cont_like wishBtn addwish" onclick="wishClick(event, this)">
										</c:if>
		                 			</c:forEach>
		                 			<input type="hidden" name="houseNum" value="${sdto.house_num}">
		                        </p>
				           </div>
				           <div class="cont_txt">
				               <p class="cont_tit">${sdto.house_name}</p>
				               <p class="cont_price">
				               		<fmt:formatNumber value="${sdto.house_price}" pattern="###,###"/>원/박
				               </p>
				           </div>                        
				       </a>                
				   </li>
				</c:forEach>
				</ul>
			</div>
		</c:if>
		<c:if test="${empty searchResult}" >
			<ul class="search_recommend">
		    	<li>원하시는 옵션의 숙소를 찾을수가 없습니다.</li>
		    	<li>게스트들이 많이 선호하는 이런 숙소들은 어떤가요?</li>
			</ul>
	    	<div>
				<ul class="cate_cont">    
				<c:forEach var="pfdto" items="${guestPreferList}">
				   <li class="cont_item">                                
				       <a href="house_info.do?house_num=${pfdto.house_num}">
				           <div class="cont_img">
				           	   <!-- 숙소 이미지 -->
				               <img src="resources/upload_house_images/${pfdto.house_image1}" style="width: 100%; height: 100%;">
				               
				               <!-- 게스트 선호 아이콘 -->
		                    	<c:forEach var="pdto" items="${guestPreferList}">
		                    		<c:if test="${pdto.house_num == pfdto.house_num}">
			                        	<p class="cont_tag">게스트 선호</p>
			                        </c:if>
		                       	</c:forEach>
		                       	<!-- 위시리스트 버튼 아이콘 -->	               
							    <p class="">			                        		
		                       		<input type="button" name="wishBtn" class="cont_like wishBtn" onclick="wishClick(event, this)">
		                       		<c:forEach var="wdto" items="${wishList}">	                        		                      		
		                        		<c:if test="${wdto.house_num == pfdto.house_num}">
				                            <input type="button" name="wishBtn" class="cont_like wishBtn addwish" onclick="wishClick(event, this)">
										</c:if>
		                 			</c:forEach>
		                 			<input type="hidden" name="houseNum" value="${sdto.house_num}">
		                        </p>
				           </div>
				           <div class="cont_txt">
				               <p class="cont_tit">${pfdto.house_name}</p>
				               <p class="cont_price">
				               		<fmt:formatNumber value="${pfdto.house_price}" pattern="###,###"/>원/박
				               </p>
				           </div>                     
				       </a>                
				   </li>
				</c:forEach>
				</ul>
			</div>
		</c:if>
		<!-- e: 검색 컨텐츠 -->
    </section>
    <!-- e: content -->
<%@ include file="guest_bottom.jsp" %>
<script type="text/javascript">
/* $(document).ready(function() {
    // 기존 검색 값을 가져와서 폼에 설정
    var searchParams = ${searchParams};
    if (searchParams) {
        $("select[name='area']").val(searchParams.area);
        //$("input[name='checkin']").val(searchParams.checkin);
        //$("input[name='checkout']").val(searchParams.checkout);
        $("input[name='per_count']").val(searchParams.per_count);
    }
}); */

// 위시버튼 클릭 이벤트
function wishClick(event, button) {
	// 이벤트 기본 동작 막기(상세페이지로 넘어가는 부분)
    event.preventDefault();
	
	// 클릭된 버튼의 부모 요소인 form을 찾아 그 안의 hidden input 값을 가져옴
    var houseNum = button.nextElementSibling.value;
    console.log("house_num:", houseNum);
    
	// 로그인되어있는 아이디 가져오기
	var userId = "${inUser.user_name}";
	console.log("login_user:", userId);    
	
    if (!$(button).hasClass('addwish')) {
    	addToWishlist(houseNum, userId, button);
    }
    else {
    	removeFromWishlist(houseNum, userId, button);
    }
}

//위시리스트 추가
function addToWishlist(houseNum, userId, button) {
	var data = {
			user_id : userId,
			house_num : houseNum
	}
	//위시리스트 추가 ajax
    $.ajax({
    	url: "addWish.ajax",
        type: "POST",
        data: JSON.stringify(data),
        contentType: "application/json",
        dataType: "text",
        success: function(res) {
        	$(button).addClass('addwish');
            alert("위시리스트에 추가되었습니다.");
        },
        error: function(err) {
            console.log(err);
        }
    });
};

// 위시리스트 삭제
function removeFromWishlist(houseNum, userId, button) {
	var data = {
			user_id : userId,
			house_num : houseNum
	}
	//위시리스트 삭제 ajax
    $.ajax({
    	url: "delWish.ajax",
        type: "DELETE",
        data: JSON.stringify(data),
        contentType: "application/json",
        dataType: "text",
        success: function(res) {
        	$(button).removeClass('addwish');
        	alert("위시리스트에서 삭제되었습니다.");
        },
        error: function(err) {
            console.log(err);
        }
    });
};

function updateSearchList() {
    // 선택한 옵션의 값
    var sortValue = $("#sortForm").val();
    var areaValue = $("#search_area").val();
    var checkinValue = $("#search_checkin").val();
    var checkoutValue = $("#search_checkout").val();
    var per_countValue = $("#search_per_count").val();
    var build_typeValue = $("#search_build_type").val();
    var room_cntValue = $("#search_room_cnt").val();
    var bed_cntValue = $("#search_bed_cnt").val();
    var bath_cntValue = $("#search_bath_cnt").val();
    
    // AJAX 요청을 수행
    $.ajax({
        type: "GET",
        url: "guest_search.do",
        data: {
        	sort: sortValue,
            area: areaValue,
            checkin: checkinValue,
            checkout: checkoutValue,
            per_count: per_countValue,
            build_type : build_typeValue,
            room_cnt : room_cntValue,
            bath_cnt : bath_cntValue,
            bed_cnt : bed_cntValue
        },
        success: function(response) {
        	$(".javajo").html(response);            
        },
        error: function(err) {
            console.log(err);
        }
    });
}
</script>