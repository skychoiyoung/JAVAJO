$( document ).ready(function() {
	// 달력(datapicker) api
	let today = moment().startOf('day');
	let dateRangePicker1 = $('input[name="datepicker1"]').daterangepicker({
		opens: 'left',
		locale: {
			format: 'YYYY-MM-DD',
			applyLabel: '적용',
			cancelLabel: '취소',
			daysOfWeek: ['일', '월', '화', '수', '목', '금', '토'],
			monthNames: ['1월', '2월', '3월', '4월', '5월', '6월', '7월', '8월', '9월', '10월', '11월', '12월'],
		},
		applyButtonClasses: 'my-apply-btn',
		cancelButtonClasses: 'my-cancel-btn',
		autoUpdateInput: false,
		minDate: today,
		minSpan: { days: 1 },
		isInvalidDate: function(date) {
			let startDate = dateRangePicker1.data('daterangepicker').startDate;
			let endDate = dateRangePicker1.data('daterangepicker').endDate;
			if (startDate && !endDate) {
				$('.daterangepicker').find('.off, .disabled').removeClass('off disabled');
			}
			$('.drp-selected').remove();
		},
	}, function(start, end, label) {
		$('input[name="datepicker1"]').val(start.format('YYYY-MM-DD') + ' - ' + end.format('YYYY-MM-DD'));
		$('input[name="checkin"]').val(start.format('YYYY-MM-DD'));
		$('input[name="checkout"]').val(end.format('YYYY-MM-DD'));
		let nights = end.diff(start, 'days'); // 숙박일 수
		$('input[name="daycount01"]').val(nights);
	});
	
	$('input[name="datepicker1"]').on('apply.daterangepicker', function(ev, picker) {
		let startDate = picker.startDate.format('YYYY-MM-DD');
		let endDate = picker.endDate.format('YYYY-MM-DD');
		$('input[name="datepicker1"]').val(startDate + ' - ' + endDate);
		dateRangePicker1.data('daterangepicker').setStartDate(startDate);
		dateRangePicker1.data('daterangepicker').setEndDate(endDate);
	});
  // 카운트기능 함수
  function countEvt(addBtn, minusBtn, maxCount) {
	    $(document).on('click', addBtn, function() {
	        var counter = $(this).closest('.count_box');
	        var value = parseInt(counter.find(".per_count").attr("value"));
	        if (value < maxCount) {
	            counter.find(".per_count").attr("value", value + 1);
	        }
	    });
	    $(document).on('click', minusBtn, function() {
	        var counter = $(this).closest('.count_box');
	        var value = parseInt(counter.find(".per_count").attr("value"));
	        if (value > 0) {
	            counter.find(".per_count").attr("value", value - 1);
	        }
	    });
	}
  // 게스트 헤더 검색창 - 카운트
  countEvt('#roomcount .plus_icon','#roomcount .minus_icon',6);
  countEvt('#bathcount .plus_icon','#bathcount .minus_icon',8);
  countEvt('#bedcount .plus_icon','#bedcount .minus_icon',6);
  
  //토글기능 함수
  function toggleEvt(toggleBtn) {
	    $(toggleBtn).on('click', function(event) {
	        let target = $(this).data('target');
	        $(target).toggle();
	        event.stopPropagation();
	    });
	    $(document).click(function(event) {
	        var $target = $(event.target);
	        if (!$target.closest('.searchOptBox').length && !$target.closest(toggleBtn).length) {
	            $('.searchOptBox').hide();
	        }
	    });
	}
  toggleEvt('.togglebtn'); // 게스트 메인 - 메뉴바
  toggleEvt('.addOptBtn'); // 게스트 메인 - 추가옵션바

  // 탭기능 함수
  function tabEvt(defaultTab) {
	    $(".cate_item").click(function() {
	        let tab_id = $(this).attr('data-tab');
	        
	        $(".cate_item").removeClass('j_active');
	        $(".tab_cont").removeClass('j_active');

	        $(this).addClass('j_active');
	        $("#" + tab_id).addClass('j_active');
	    });
	    $(".cate_item[data-tab='" + defaultTab + "']").click();
  }
  tabEvt('htheme01'); // 게스트 메인 - 카테고리 탭
	
	
  if(!$(".page_num").text()) {
	  $(".pagination").css("margin","0");
  }else {
	  $(".pagination").css("margin","30px 0");
  }
});

