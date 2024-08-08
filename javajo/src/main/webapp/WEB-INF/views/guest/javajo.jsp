<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file="guest_top.jsp" %>
	<!-- s: content -->
    <section id="introduce_javajo" class="content">
    	<div class="javajo_intro">
	    	<div class="javajo_img">
	    		<img src="resources/images/javajo/javajo_team.jpg" alt="" />
	    	</div>
	    	<ul class="intro_txt">
	    		<li>"여행자와 숙박 시설을 제공하는 호스트를 연결하는 <em>온라인 플랫폼</em>"</li>
	    		<li>개인이 제공하는 다양한 유형의 숙소를 예약하고 이용할 수 있도록 하는 서비스 제공</li>
	    		<li>호스트는 어디서 어떤 공간이든 호스팅할 수 있고, 게스트는 국내 어디든 다채로운 숙소를 즐길 수 있습니다.</li>
	    	</ul>
    	</div>
    	
	    <div class="javajo_detail">
	    	<p class="box_title">프로젝트 일정표</p>
	    	<ul class="detail_list">
	    		<li class="detail_weekly">
	    			<ul class="detail_items">
	    				<li>1주차</li>
	    				<li>2주차</li>
	    				<li>3주차</li>
	    				<li>4주차</li>
	    				<li>5주차</li>
	    				<li>6주차</li>
	    			</ul>
	    		</li>
	    		<li class="detail_info">
	    			<ul class="detail_items">
	    				<li>
	    					<p>기획</p>
	    					<div>
		    					<div class="animation_box animation_01">
			    					<p><span>6/3 - 6/7</span>주제선정 및 <br/>범위 조정 <br/>기능 합의</p>
		    					</div>
	    					</div>
	    				</li>
	    				<li>
	    					<p>상세 기획</p>
	    					<div>
		    					<div class="animation_box animation_02">
			    					<p><span>6/7 - 6/14</span>DB설계 <br/>와이어 프레임 <br/>역할 분담</p>
		    					</div>
	    					</div>
	    				</li>
	    				<li>
	    					<p>구현</p>
	    					<div>
		    					<div class="animation_box animation_03">
			    					<p><span>6/13 - 7/9</span>페이지 디자인 및 기능 구현 작업</p>
		    					</div>
	    					</div>
	    				</li>
	    				<li>
	    					<p>테스트</p>
	    					<div>
		    					<div class="animation_box animation_04">
			    					<p><span>7/1 - 7/11</span>통합 테스트 및 PPT 작업</p>
		    					</div>
	    					</div>
	    				</li>
	    			</ul>
	    		</li>
	    	</ul>
	    </div>
	    
	    <div class="javajo_use_program">
	    	<p class="box_title">사용 프레임워크 및 기능</p>
	    	<ul class="use_pgrm use_pgrm01">
	    		<li><img src="resources/images/javajo/spring.png" alt="" /></li>
	    		<li><img src="resources/images/javajo/oracle.jpg" alt="" /></li>
	    		<li><img src="resources/images/javajo/mybatis.png" alt="" /></li>
	    		<li><img src="resources/images/javajo/apache_tomcat.jpg" alt="" /></li>
	    	</ul>
	    	<ul class="use_pgrm use_pgrm02">
	    		<li><img src="resources/images/javajo/markup.png" alt="" /></li>
	    		<li><img src="resources/images/javajo/jquery.png" alt="" /></li>
	    		<li><img src="resources/images/javajo/ajax.png" alt="" /></li>
	    	</ul>
	    	<ul class="use_pgrm use_pgrm03">
	    		<li><img src="resources/images/javajo/kakao_developers.png" alt="" /></li>
	    		<li><img src="resources/images/javajo/import.png" alt="" /></li>
	    	</ul>
	    </div>
    </section>
    <!-- e: content -->
<%@ include file="guest_bottom.jsp" %>
<script type="text/javascript">
	$(window).scroll(function() {
	    let javajoDetailTop = $('#introduce_javajo .javajo_detail').offset().top;
	    let windowHeight = $(window).height();
	    let scrolltop = $(window).scrollTop();
	
	    if (scrolltop + windowHeight > javajoDetailTop) {
	        $('#introduce_javajo .animation_box').addClass('fill');
	    }
	});
</script>