<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ include file="guest_top.jsp" %>
    <!-- s: content -->
    <section id="main">   
		<ul class="cate_list">
		    <c:forEach var="dto" items="${listTheme}">
		        <li class="cate_item" data-tab="${dto.htheme}">        
	                <div class="img_box">
	                    <img src="resources/images/theme/${dto.htheme_image}" alt="">
	                </div>
	                <p class="cate_tit">${dto.htheme_des}</p>
		        </li>
		    </c:forEach>
		</ul>
		<!-- e: 카테고리 아이콘 -->		
		
		<!-- s: 카테고리별 숙소-->	    
		<c:forEach var="dto" items="${listTheme}">
			<c:set var="listHousebyTheme" value="${housesByTheme[dto.htheme]}" />
		    <div id="${dto.htheme}" class="tab_cont">    	
				<form method="post">
			    	<select id="${dto.htheme}-search" class="sortForm" name="sort" onchange="updateList()">		    		
			            <option value="score" ${sort == 'score' ? 'selected' : ''}>인기순</option>
	           	 		<option value="price" ${sort == 'price' ? 'selected' : ''}>가격낮은순</option>
	           			<option value="num" ${sort == 'num' ? 'selected' : ''}>최신등록순</option>
			        </select>
		        </form>	
		        <ul class="cate_cont">
			        <c:if test="${empty listHousebyTheme}">			        	
		                <li class="cont_item">
		                	<div class="cont_txt">
		                    	<p class="cont_tit">${dto.htheme_des} 테마로 등록된 숙소가 없습니다.</p>
		                    </div>
		                </li>
		            </c:if>
                    
		        	<c:forEach var="hdto" items="${listHousebyTheme}">
			            <li class="cont_item"> 
			                <a href="house_info.do?house_num=${hdto.house_num}">
			                    <div class="cont_img">
			                    	<!-- 숙소 이미지 -->
			                    	<img class="pdt_img" src="resources/upload_house_images/${hdto.house_image1}">
			                    	<!-- 게스트 선호 아이콘 -->
			                    	<c:forEach var="pdto" items="${guestPreferList}">
			                    		<c:if test="${pdto.house_num == hdto.house_num}">
				                        	<p class="cont_tag" style="color: #000;">게스트 선호</p>
				                        </c:if>
		                        	</c:forEach>
		                        	<!-- 위시리스트 버튼 아이콘 -->
			                        <p class="">			                        		
		                        		<input type="button" name="wishBtn" class="cont_like wishBtn" onclick="wishClick(event, this)">
		                        		<c:forEach var="wdto" items="${wishList}">	                        		                      		
			                        		<c:if test="${wdto.house_num == hdto.house_num}">
					                            <input type="button" name="wishBtn" class="cont_like wishBtn addwish" onclick="wishClick(event, this)">
											</c:if>
                    					</c:forEach>
                    					<input type="hidden" name="houseNum" value="${hdto.house_num}">
			                        </p>
			                    </div>
			                    <div class="cont_txt">
			                        <p class="cont_tit">${hdto.house_name}</p>
			                        <p class="cont_price">
			                        	<fmt:formatNumber value="${hdto.house_price}" pattern="###,###"/>원/박
			                        </p>
			                    </div>                        
			                </a>                
			            </li>
		            </c:forEach>
		        </ul>
		    </div>
		</c:forEach>
		<!-- e: 카테고리별 숙소-->
		<div class="top_btn">
		</div>
    </section>
    <!-- e: content -->
    <input type="hidden" id="check">

<script type="text/javascript">
	function tabEvt2(defaultTab) {
    	$(".cate_item").click(function() {
            var tabId = $(this).attr('data-tab');
            $(".cate_item").removeClass('j_active');
            $(".tab_cont").removeClass('j_active');

            $(this).addClass('j_active');
            $("#" + tabId).addClass('j_active');
    	});   
        $(".cate_item[data-tab='" + defaultTab + "']").addClass('j_active');
        $("#" + defaultTab).addClass('j_active');   	
    }
	
	function updateList() {
	    var selectedTab = $(".tab_cont.j_active").attr("id"); 
	    var sortOption = $("#" + selectedTab + "-search").val(); // 정렬 옵션 가져오기

	    // AJAX 요청을 수행
	    $.ajax({
	        type: "GET",
	        url: "guest_index.ajax",
	        data: {
	            sort: sortOption,
	            selectedTab: selectedTab
	        },
	        success: function(response) {
	            // JSON 데이터를 받아서 HTML로 변환
	            var housesByTheme = response.housesByTheme;   // 테마별 숙소
	            var listHousebyTheme = housesByTheme[selectedTab];  // 선택된 테마 숙소리스트
	            var wishList = response.wishList;
	            var guestPreferList = response.guestPreferList;
	            var newContent = '';

	            if (listHousebyTheme.length === 0) {
	                newContent = '<li class="cont_item"><div class="cont_txt"><p class="cont_tit">' + 
	                             selectedTab + ' 테마로 등록된 숙소가 없습니다.</p></div></li>';
	            } else {
	                for (var i = 0; i < listHousebyTheme.length; i++) {
	                	
	                    // 테마별/정렬별 숙소리스트
	                	var hdto = listHousebyTheme[i];	                    
	                    
	                    // 위시리스트 아이콘 fill 유지 대상 확인
	                    var isWished = false;
	                    for (var j = 0; j < wishList.length; j++) {
	                        if (wishList[j].house_num == hdto.house_num) {
	                            isWished = true;	                            
	                            break;
	                        }
	                    }
	                    
	                 	// 게스트 선호 여부 확인
	                    var isGuestPreferred = false;
	                    for (var k = 0; k < guestPreferList.length; k++) {
	                        if (guestPreferList[k].house_num == hdto.house_num) {
	                            isGuestPreferred = true;
	                            break;
	                        }
	                    }

	                    newContent += '<li class="cont_item">' +
	                                  '<a href="house_info.do?house_num=' + hdto.house_num + '">' +
	                                  '<div class="cont_img">' +
	                                  '<img src="resources/upload_house_images/' + hdto.house_image1 + '" style="width: 100%; height: 100%;">' +
	                                  (isGuestPreferred ? '<p class="cont_tag" style="color: #000;">게스트 선호</p>' : '') + 
	                                  '<p class="">' +
	                                  '<input type="button" name="wishBtn" class="cont_like wishBtn" onclick="wishClick(event, this)">' +
	                                  '<input type="button" name="wishBtn" class="cont_like wishBtn ' + (isWished ? 'addwish' : '') + '" onclick="wishClick(event, this)">' +
	                                  '<input type="hidden" name="houseNum" value="' + hdto.house_num + '">' +
	                                  '</p>' +
	                                  '</div>' +
	                                  '<div class="cont_txt">' +
	                                  '<p class="cont_tit">' + hdto.house_name + '</p>' +
	                                  '<p class="cont_price">' + new Intl.NumberFormat().format(hdto.house_price) + '원/박</p>' +
	                                  '</div>' +
	                                  '</a>' +
	                                  '</li>';
	                }
	            }

	            // 해당 탭의 콘텐츠 업데이트
	            $("#" + selectedTab + " .cate_cont").html(newContent);

	            // 탭을 다시 설정
	            tabEvt2(selectedTab);
	        },
	        error: function(err) {
	            console.log(err);
	        }
	    });
	}
	

	// 위시버튼 클릭 이벤트
	function wishClick(event, button) {
		// 이벤트 기본 동작 막기(상세페이지로 넘어가는 부분)
	    event.preventDefault();
		
		// 클릭된 버튼의 부모 요소인 form을 찾아 그 안의 hidden input 값을 가져옴
        var houseNum = button.nextElementSibling.value;
        console.log("house_num:", houseNum);
        
    	// 로그인되어있는 아이디 가져오기
    	var userId = "${inUser.user_id}";
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
</script> 
<%@ include file="guest_bottom.jsp" %>