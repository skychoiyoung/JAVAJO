<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">    
 <meta name="viewport" content="width=device-width, initial-scale=1.0">
 <title>숙소 사진 등록</title>
<link rel="stylesheet" type="text/css" href="resources/css/reset.css">
<link rel="stylesheet" type="text/css" href="resources/css/index_host.css">
</head>
<body>
    <!-- 이미지 미리보기를 위한 리스트 -->
    <div class="filebox_wrap">
	    <div class="filebox">
	    	<div class="before_preview defaultPreview">
		    	<ul id="Preview" class="sortable preview_imgs"></ul>
	    	</div>
	        <div class="inputFile">
	        	<ul>
		        	<li>* 사진은 가로로 찍은 사진을 권장합니다.</li>
		        	<li>* 사진 용량은 사진 한 장당 20MB 까지 등록이 가능합니다.</li>
		        	<li>* 실제 숙소 사진 5장을 등록하셔야합니다.</li>
	        		<li>* 등록하는 이미지가 실제 숙소와 다를 경우 제재를 받을 수 있습니다.</li>
	        	</ul>
	            <label for="fileInput" class="addImgBtn">
	            	<input type="file" id="fileInput" class="upload-hidden" accept=".jpg, .png, .gif, .jpeg" multiple>
	            </label>
	        </div>
	    </div>
	
	    <!-- 등록 완료 버튼 -->
	    <button class="insert_btn" type="button" onclick="sendImages()">등록완료</button>
    </div>
 <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
 <script src="https://code.jquery.com/ui/1.12.1/jquery-ui.js"></script>
    <script>
    var MAX_IMAGES = 5; // 최대 이미지 개수
    var houseImages = []; // 사진 데이터를 담을 배열

    $(function() {
        // 드래그 앤 드롭 기능 활성화 후 업뎃!!
        $(".sortable").sortable({
            tolerance: "pointer",
            update: function(event, ui) {
                updateImageOrder();
            }
        });

     	// 파일 선택 시 처리
        $("#fileInput").change(function(e) {
            var files = e.target.files;
            var arr = Array.prototype.slice.call(files);

            // 업로드 가능 파일인지 체크
            for (var i = 0; i < files.length; i++) {
                if (!checkExtension(files[i].name, files[i].size)) {
                    return false;
                }
            }
            preview(arr);
        });
     	
     // 이미지 미리보기 후 업뎃!!
        function preview(arr) {
            var currentImageCount = $('#Preview li').length;
            var remainingSlots = MAX_IMAGES - currentImageCount;

            arr.slice(0, remainingSlots).forEach(function(f) { 
                if (f.type.match('image.*')) {
                    var reader = new FileReader();
                    reader.onload = function(e) {
                    	$(".before_preview").removeClass("defaultPreview");
                        var str = '<li class="ui-state-default">';
                        str += '<img src="' + e.target.result + '" title="' + f.name + '" style="width: 100%; height: 100%;">';
                        str += `<span class="delBtn" onclick="delImg(this)">x</span>`;
                        str += '</li>';
                        $(str).appendTo('#Preview');
                        houseImages.push(f);
                    }
                    reader.readAsDataURL(f); 
                }
            });

            if (arr.length > remainingSlots) {
                alert('최대 5장까지 업로드할 수 있습니다.');
            }
            updateImageOrder();
        }

     	// 이미지 삭제 후 업뎃
        window.delImg = function(_this) {
            var index = $(_this).closest('li').index();
            houseImages.splice(index, 1); 
            $(_this).closest('li').remove();
            if($("#Preview li").length === 0) {
            	$(".before_preview").addClass("defaultPreview");
            }
            updateImageOrder();
        }

     // 이미지 순서 업데이트!!
        function updateImageOrder() {
        	var newHouseImages = [];
        	 $('#Preview li').each(function(index) {
                 var imgSrc = $(this).find('img').attr('src');
                 var fileName = $(this).find('img').attr('title');
                 var file = findFileByName(fileName);
                 if (file) {
                     newHouseImages.push(file);
                 }
             });
             houseImages = newHouseImages;
         }

        // 파일 이름으로 파일 객체 찾기
        function findFileByName(fileName) {
		    for (var i = 0; i < houseImages.length; i++) {
		        if (houseImages[i].name === fileName) {
		            return houseImages[i];
		        }
		    }
		    return null;
		}

        // 이미지 확장자 및 크기 체크
        function checkExtension(fileName, fileSize) {
        	// 허용할 이미지 확장자 및 MIME 타입 리스트
            var allowedExtensions = /(\.jpg|\.jpeg|\.png|\.gif)$/i;
            var allowedMimeTypes = ['image/jpeg', 'image/png', 'image/gif'];
            var maxSize = 52428800; // 50MB

            if (fileSize >= maxSize) {
                alert('이미지 크기가 초과되었습니다.');
                $("#fileInput").val(""); // 파일 초기화
                return false;
            }
         	// 확장자 체크
            if (!allowedExtensions.exec(fileName)) {
                alert('이미지 파일 형식만 업로드 가능합니다. (jpg, jpeg, png, gif)');
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
        if (houseImages.length !== MAX_IMAGES) {
            alert('숙소 이미지 5장을 업로드해주세요.');
            return;
        }

        // houseImages 배열을 부모 창으로 전송
        window.opener.receiveImages(houseImages);
        window.close(); // 팝업 창 닫기
    }
</script>
</body>
</html>