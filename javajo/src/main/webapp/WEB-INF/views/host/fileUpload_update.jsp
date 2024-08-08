<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">    
 <meta name="viewport" content="width=device-width, initial-scale=1.0">
 <title>숙소 사진 수정</title>
<link rel="stylesheet" type="text/css" href="resources/css/reset.css">
<link rel="stylesheet" type="text/css" href="resources/css/index_host.css">
</head>
<body>
    <!-- 이미지 미리보기를 위한 리스트 -->
    <div class="filebox_wrap">
	    <div class="filebox">
	    	<ul id="Preview" class="sortable preview_imgs"></ul>
	        <div class="inputFile">
	        	<ul>
		        	<li>* 수정을 원하는 위치의 사진을 선택해주세요.</li>
		        	<li>* 사진은 가로로 찍은 사진을 권장합니다.</li>
		        	<li>* 사진 용량은 사진 한 장당 20MB 까지 등록이 가능합니다.</li>
	        		<li>* 등록하는 이미지가 실제 숙소와 다를 경우 제재를 받을 수 있습니다.</li>
	        	</ul>
 	            <label for="fileInput" class="addImgBtn" style="display:none;">
	            	<input type="file" id="fileInput" class="upload-hidden" accept=".jpg, .png, .gif, .jpeg" multiple>
	            </label>
	        </div>
	    </div>
	
	    <!-- 등록 완료 버튼 -->
	    <button class="insert_btn" type="button" onclick="sendImages()">수정완료</button>
    </div>
 <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
 <script src="https://code.jquery.com/ui/1.12.1/jquery-ui.js"></script>
    
       <script>
        var MAX_IMAGES = 5; // 최대 이미지 개수
        var houseImages = []; // 사진 데이터를 담을 배열
        var clickedIndex = null; // 클릭된 이미지의 인덱스를 저장할 변수

        $(function() {
            // 초기 이미지 경로 설정
            var initialImageUrls = ${imageUrls};

            // 초기 이미지를 미리보기에 추가
            initialImageUrls.forEach(function(url, index) {
                var str = '<li class="ui-state-default">';
                str += '<img src="' + url + '" title="Image' + index + '" style="width: 100%; height: 100%;">';
                str += '</li>';
                $(str).appendTo('#Preview');
            });

            console.log("잘 담겼니1?", houseImages);

            // 모든 fetch 요청을 Promise.all로 처리
            var fetchPromises = initialImageUrls.map(function(url) {
                return fetch(url)
                    .then(response => response.blob())
                    .then(blob => {
                        var filename = url.substring(url.lastIndexOf('/') + 1);
                        var fileType = blob.type.split('/')[1];
                        var file = new File([blob], filename, { type: `image/${fileType}` });

                        // houseImages 배열에 파일 객체 추가
                        houseImages.push(file);
                    })
                    .catch(error => console.error('Error fetching image:', error));
            });

            // 모든 fetch가 완료된 후에 로그 출력
            Promise.all(fetchPromises).then(function() {
                console.log("잘 담겼니2?", houseImages); 
            });

            // 파일 선택 시 처리
            $("#fileInput").change(function(e) {
                var file = e.target.files[0];

                // 업로드 가능 파일인지 체크
                if (!checkExtension(file.name, file.size)) {
                    return false;
                }

                if (clickedIndex !== null) {
                    if (file.type.match('image.*')) {
                        var reader = new FileReader();
                        reader.onload = function(e) {
                            $('#Preview li').eq(clickedIndex).find('img').attr('src', e.target.result);
                            houseImages[clickedIndex] = file; // 파일 객체로 업데이트
                            $("#fileInput").val(""); // 파일 초기화
                            clickedIndex = null; // 클릭 인덱스 초기화
                        }
                        reader.readAsDataURL(file);
                    }
                } else {
                    alert('수정할 이미지를 클릭해주세요.');
                    $("#fileInput").val(""); // 파일 초기화
                }
            });

            // 이미지 클릭 시 파일 선택창 열기
            $('#Preview').on('click', 'li', function() {
                clickedIndex = $(this).index(); // 클릭된 이미지의 인덱스 저장
                $('#fileInput').trigger('click');
                $(this).addClass('clicked').siblings().removeClass('clicked');
            });

            // 이미지 확장자 및 크기 체크
            function checkExtension(fileName, fileSize) {
                var regex = new RegExp("(.*?)\.(exe|sh|zip|alz)$");
                var maxSize = 20971520; // 20MB

                if (fileSize >= maxSize) {
                    alert('이미지 크기가 초과되었습니다.');
                    $("#fileInput").val(""); // 파일 초기화
                    return false;
                }

                if (regex.test(fileName)) {
                    alert('확장자명을 확인해주세요.');
                    $("#fileInput").val(""); // 파일 초기화
                    return false;
                }
                
            	 // 같은 파일 이름 체크
                for (var i = 0; i < houseImages.length; i++) {
                    if (houseImages[i].name === fileName) {
                        alert('이미 업로드 된 사진입니다. 다른 사진을 올려주세요.');
                        $("#fileInput").val(""); // 파일 초기화
                        return false;
                    }
                }
                return true;
            }
        });

        // 등록 완료 버튼 클릭 시 처리
        function sendImages() {
            console.log("잘 담겼니3?", houseImages);
            if (houseImages.length !== MAX_IMAGES) {
                alert('숙소 이미지 5장을 업로드해주세요.');
                return;
            }

            // houseImages 배열을 부모 창으로 전송
            window.opener.receiveImages2(houseImages);
            window.close(); // 팝업 창 닫기
        }
    </script>
</body>
</html>