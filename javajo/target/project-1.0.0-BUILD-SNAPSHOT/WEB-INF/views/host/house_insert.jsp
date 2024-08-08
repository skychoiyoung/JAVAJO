<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %> 
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ include file="house_top.jsp" %>
	<section id="host_houseadd" class="content">
        <div class="host_house">
            <div class="tit_box">
                <p>숙소등록</p>
            </div>
            
            <div class="house_info">
				<form name="f2" action="insertHouse.do" method="post" enctype="multipart/form-data">
                    <ul class="info_list">
                        <li>
                            <span>숙소명</span>
                            <input type="text" name="house_name" value="" maxlength="10" required />
                        </li>
                        <li>
                            <span>숙소주소</span>
                            <input class ="longinput" type="text" id="postcode" name="zipcode" size="5" readonly>&nbsp;
							<input class ="post_check" type="button" value="우편번호 검색" onclick="checkPost()">
                        </li>
                        <li>
                        	<input class="longinput2" type="text" id="address" name="addr1" size="50" placeholder="주소" readonly>
                        </li>
                        <li>
							<input class="longinput2" type="text" id="detailAddress" name="addr2" size="50" placeholder="상세주소">
                        	<input type="hidden" id="house_addr" name="house_addr">
                        </li>
                        <li>
                            <span>숙소유형</span>
                            <select id="pdt_type" name="house_type">
									<c:forEach var ="dto" items="${listHouseType}">
											<option value="${dto.htype}">
												${dto.htype_des}
											</option>	
									</c:forEach>						
								</select>
                        </li>
                        <li>
                            <span>방 개수</span>
                            <img class="minus_btn" src="resources/images/main/left_arrow.png" alt="감소 버튼" onclick="minus('room_count')">
                            <input class="count_box" id="room_count" type="text" name="house_room" value="1" />
                            <img class="plus_btn" src="resources/images/main/right_arrow.png" alt="증가 버튼" onclick="plus('room_count')">
                        </li>
                        <li>
                            <span>침대 개수</span>
							<img class="minus_btn" src="resources/images/main/left_arrow.png" alt="감소 버튼" onclick="minus('bed_count')">
                            <input class="count_box" id="bed_count" type="text" name="house_bed" value="1"  />
                            <img class="plus_btn" src="resources/images/main/right_arrow.png" alt="증가 버튼" onclick="plus('bed_count')">
                        </li>
                        <li>
                            <span>욕실개수</span>
                           	<img class="minus_btn" src="resources/images/main/left_arrow.png" alt="감소 버튼" onclick="minus('bath_count')">
                            <input class="count_box" id="bath_count" type="text" name="house_bath" value="1"  />
                            <img class="plus_btn" src="resources/images/main/right_arrow.png" alt="증가 버튼" onclick="plus('bath_count')">	
                        </li>
                        <li>
                            <span>최대 허용 인원</span>
                           	<img class="minus_btn" src="resources/images/main/left_arrow.png" alt="감소 버튼" onclick="minus('max_count')">
                            <input class="count_box" id="max_count" type="text" name="house_maxperson" value="1" readonly required />
                            <img class="plus_btn" src="resources/images/main/right_arrow.png" alt="증가 버튼" onclick="plus('max_count')">	
                        </li>
                        <li>
                            <span>숙소사진(5장)</span>
                            <div class="file_box">
                                <input class="file_name" value="첨부파일" placeholder="첨부파일" readonly>
                                <input type="button" id="fileUploadBtn" value = "사진올리기" onclick="openFileUpload()">
                            </div>
                        </li>
                        <li>
                            <span>숙소테마</span>
                            <div class="theme_box">
                                <c:forEach var ="themedto" items="${listHouseTheme}">
								 	<c:if test="${themedto.htheme_des ne '모든 테마'}"> <!--ALL은 제외 -->
									<label for="${themedto.htheme}">			
										<input id="${themedto.htheme}" type="checkbox" name="house_theme" value="${themedto.htheme}">${themedto.htheme_des}		
									</label>
									</c:if>				
								</c:forEach>
                            </div>
                        </li>
                        <li>
                            <span>숙소편의</span>
                            <div class="fac_box">
                                <c:forEach var ="facdto" items="${listHouseFac}">
									<label for="${facdto.hfac}">		
										<input id="${facdto.hfac}" type="checkbox" name="house_fac" value="${facdto.hfac}">${facdto.hfac_des}			
									</label>	
								</c:forEach>
                            </div>
                        </li>
                        <li>
                            <span>숙소 소개글</span>
                            <textarea name="house_content" rows="10" cols="60"></textarea>
                        </li>
                         <li>
                            <span>체크인 시간</span>
                            <div class="time_select">
	                            <select name="house_checkin1">
								    <c:forEach begin="10" end="18" var="hour">
								        <option value="${hour}">${hour}시</option>
								    </c:forEach> 
								</select>
								<select name="house_checkin2">							    
								    <c:forEach begin="0" end="30" var="minute">
								        <c:if test="${minute % 30 == 0}">
								            <option value="${minute}">${minute}분</option>
								        </c:if>
								    </c:forEach> 
								</select>							                           
                            </div>
                        </li>
                        <li>
                            <span>체크아웃 시간</span>
                            <div class="time_select">
	                            <select name="house_checkout1">
								    <c:forEach begin="10" end="13" var="hour">
								        <option value="${hour}">${hour}시</option>
								    </c:forEach> 
								</select>
								<select name="house_checkout2">							    
								    <c:forEach begin="0" end="30" var="minute">
								        <c:if test="${minute % 30 == 0}">
								            <option value="${minute}">${minute}분</option>
								        </c:if>
								    </c:forEach> 
								</select>
                            </div>
                        </li>
                        <li>
                            <span>이용금액/1박</span>
                            <p class="price_tit"><input type="text" id="commas" onkeyup="inputNumberFormat(this)" name="house_price" class="box" maxlength="9"> 원</p>
                        </li>
                    </ul>
                    <ul class="house_noti">
                        <li>등록하신 금액은 평일 기준 금액으로, 실제 게스트가 결제하는 금액과 차이가 있을 수 있습니다.</li>
                        <li>등록하신 금액에서 주말은 10%, 성수기는 50%가 추가됩니다.</li>
                        <li>JAVAJO 서비스 이용 수수료는 총 숙박액의 10%입니다.</li>
                        <li>총 결제금액은 숙박금액과 JAVAJO 서비스 이용 수수료가 포함된 금액입니다.</li>
                        <li>이는 게스트가 부담하며, 호스트는 JAVAJO 서비스 이용 수수료를 제외한 금액을 정산받습니다.</li>
                    </ul>
                    <div class="btn_box">
                        <button class="insert_btn" type="button" onclick="checkRegister()">등록완료</button>
						<button class="insert_btn" type="button" onclick="window.location='manageHouse.do'">취소</button>
                    </div>
                </form>
            </div>
        </div>
    </section>
	<%@ include file="house_bottom.jsp" %>

		<!-- 주소 검색 API -->
		<script src="https://t1.daumcdn.net/mapjsapi/bundle/postcode/prod/postcode.v2.js"></script>
		<script type="text/javascript">
			// 파일 팝업창에서 받을 파일들 전연변수로 미리 선언
			var selectedFiles = [];
			// 파일업로드 창 띄우기
		 	function openFileUpload() {
				// 창 크기 설정
			   var url = "fileUpload.do";
	           var width = 1200;
	           var height = 800;
				// 화면의 너비와 높이를 가져와서 중앙 위치 계산
	           var screenWidth = window.screen.width;
	           var screenHeight = window.screen.height;
	           var left = (screenWidth / 2) - (width / 2);
	           var top = (screenHeight / 2) - (height / 2);   
	             
	           window.open(url, 'fileUploadWindow', 'width=' + width + 
	           		        ',height=' + height + ',left=' + left + ',top=' + top);
		    }
			
			// 팝업 창에서 호출되어 이미지 파일 배열을 받아 처리하는 함수
		    function receiveImages(images) {
		    	selectedFiles = images; // 전역 변수에 이미지 배열 저장
	            console.log('받은 파일 체크:', images);
		    	
	         // input 파일 커스텀
			   if (images.length > 0) {
                // 파일 이름을 조합하여 file_name 요소의 값 변경
                var fileNames = images.map(function(file) { return file.name; }).join(', ');
                $(".file_name").val(fileNames);
           	 }
		        
		    }
		
			function checkRegister(){		
				if (f2.house_name.value== ""){				
					alert("숙소명을 입력해주세요.")
					f2.house_name.focus()
					return false;
				}
				
				if (f2.addr1.value ==""){
					alert("주소를 입력해주세요.")
					f2.addr1.focus()
					return false;
				}
				
				 var fileName = $(".file_name").val();
	            	if (fileName === "첨부파일") {
	                alert("파일을 첨부해주세요.");
	               	return false;
		            }
	            	
            	if (f2.house_price.value ==""){
					alert("금액을 입력해주세요.")
					f2.house_price.focus()
					return false;
				}	
							
				// 체크박스 유효성 검사 (숙소 테마, 편의)
				var checkTheme = document.getElementsByName("house_theme"); // 체크박스들의 배열을 가져옴
				var checkFac = document.getElementsByName("house_fac");
			    var isChecked1 = false;
			    var isChecked2 = false;
			    
			    for (var i = 0; i < checkTheme.length; i++) {
			        if (checkTheme[i].checked) {
			            isChecked1 = true;
			            break; // 하나라도 체크되어 있으면 반복문 탈출
			        }
			    }
			    
			    for (var i = 0; i < checkFac.length; i++) {
			        if (checkFac[i].checked) {
			            isChecked2 = true;
			            break; // 하나라도 체크되어 있으면 반복문 탈출
			        }
			    }
	
			    if (!isChecked1) {
			        alert("숙소 테마를 하나 이상 선택해주세요.");
			        return false; // 폼 전송을 막음
			    }
			    
			    if (!isChecked2) {
			        alert("숙소 편의를 하나 이상 선택해주세요.");
			        return false; // 폼 전송을 막음
			    }
			    
		        // 숙소명 중복 체크
				var checkHousename = "${checkHousename}"; 
		        for (var i = 0; i < checkHousename.length; i++) {
		            if (f2.house_name.value == checkHousename[i].house_name) {
		                alert("중복된 숙소 이름입니다.");
		                document.f2.house_name.focus();
		                return false;
		            }
		        } 
		        
		        var formData = new FormData();
	
		        for (var i = 0; i < selectedFiles.length; i++) {
	                formData.append('files', selectedFiles[i]);
	            }
		        
		        var xhr = new XMLHttpRequest();
		        xhr.open('POST', 'imageUpload.do', true);
	
		        xhr.onreadystatechange = function() {
		            if (xhr.readyState === 4) {
		                if (xhr.status === 200) {
		                    console.log('Success:', xhr.responseText);
		                } else {
		                    console.error('Error:', xhr.statusText);
		                }
		            }
		        };
		       		xhr.send(formData);
			        document.f2.submit();
			}
		
		    function checkPost() {
		        new daum.Postcode({
		            oncomplete: function(data) {
		               
		                var addr = ''; // 주소 변수
		                var extraAddr = ''; // 참고항목 변수
		
		                //사용자가 선택한 주소 타입에 따라 해당 주소 값을 가져온다.
		                if (data.userSelectedType === 'R') { // 사용자가 도로명 주소를 선택했을 경우
		                    addr = data.roadAddress;
		                } else { // 사용자가 지번 주소를 선택했을 경우(J)
		                    addr = data.jibunAddress;
		                }
		
		                // 사용자가 선택한 주소가 도로명 타입일때 참고항목을 조합한다.
		                if(data.userSelectedType === 'R'){
		                    // 법정동명이 있을 경우 추가한다. (법정리는 제외)
		                    // 법정동의 경우 마지막 문자가 "동/로/가"로 끝난다.
			                    if(data.bname !== '' && /[동|로|가]$/g.test(data.bname)){
			                        extraAddr += data.bname;
			                    }
			                    // 건물명이 있고, 공동주택일 경우 추가한다.
			                    if(data.buildingName !== '' && data.apartment === 'Y'){
			                        extraAddr += (extraAddr !== '' ? ', ' + data.buildingName : data.buildingName);
			                    }
		                   
		                }
		
		                // 우편번호와 주소 정보를 해당 필드에 넣는다.
		                document.getElementById('postcode').value = data.zonecode;
		                document.getElementById("address").value = addr;
		                // 커서를 상세주소 필드로 이동한다.
		                document.getElementById("detailAddress").focus();
		            }
		        }).open();
		        
		    }
		    
		    // 감소 버튼 클릭 시 호출되는 함수
		    function minus(fieldId) {
		        var input = document.getElementById(fieldId);
		        var value = parseInt(input.value, 10); // 현재 값 가져오기
		        value = isNaN(value) ? 0 : value; // 숫자가 아닌 경우 처리
		        value--; // 감소
		        if (value < 0) value = 0; // 음수 방지
		        input.value = value; // 값 적용
		    }
		
		    // 증가 버튼 클릭 시 호출되는 함수
		    function plus(fieldId) {
		        var input = document.getElementById(fieldId);
		        var value = parseInt(input.value, 10); // 현재 값 가져오기
		        value = isNaN(value) ? 0 : value; // 숫자가 아닌 경우 처리
		        value++; // 증가
		        input.value = value; // 값 적용
		    }
		    
		    function inputNumberFormat(input) {
		        // 입력된 값
		        let value = input.value;
		        // 숫자만 입력
		        let cleanValue = value.replace(/[^\d]/g, '');	        
		        input.value = cleanValue;
		        }
		</script>
   