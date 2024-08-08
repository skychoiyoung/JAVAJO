<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %> <!-- 숫자 포맷팅 할 때 필요 -->
<%@ include file="guest_top.jsp" %>
<!-- s: content -->
<section id="reserve_detail" class="content">
    <p>숙소 예약</p>
    <form name="completePay" method="post">
        <ul class="reserve_list">
            <li class="reserve_item"><span>숙소명</span>${reserveInfo.house_name}</li>
            <li class="reserve_item"><span>주소</span>${reserveInfo.house_addr}</li>
            <li class="reserve_item"><span>인원 수</span>${reserveInfo.reserv_person}명</li>
            <li class="reserve_item"><span>체크인 일자</span>${reserveInfo.reserv_checkin}</li>
            <li class="reserve_item"><span>체크아웃 일자</span>${reserveInfo.reserv_checkout}</li>
            <li class="reserve_item"><span>숙소 이용금액</span><fmt:formatNumber value="${reserveInfo.reserv_pay}" pattern="#,###" />원</li>
            <li class="reserve_item"><span>JAVAJO 수수료</span><fmt:formatNumber value="${reserveInfo.reserv_paycharge}" pattern="#,###" />원</li>
            <li class="reserve_item">
            	<span>총 결제금액</span><fmt:formatNumber value="${reserveInfo.reserv_totpay}" pattern="#,###" />원
            	<input type="hidden" name="house_num" value="${reserveInfo.house_num}" />
            	<input type="hidden" name="house_addr" value="${reserveInfo.house_addr}" />
            	<input type="hidden" name="reserv_checkin" value="${reserveInfo.reserv_checkin}" />
            	<input type="hidden" name="reserv_checkout" value="${reserveInfo.reserv_checkout}" />
            	<input type="hidden" name="reserv_person" value="${reserveInfo.reserv_person}" />
            	<input type="hidden" name="reserv_pay" value="${reserveInfo.reserv_pay}" />
            	<input type="hidden" name="reserv_paycharge" value="${reserveInfo.reserv_paycharge}" />
            	<input type="hidden" name="reserv_totpay" value="${reserveInfo.reserv_totpay}" />
            </li>
            <li class="reserve_item">
                <span>결제 방법</span>
                <select class="reserve_opt" name="reserv_paytype">
                    <option value="카카오페이">카카오페이</option>
                    <!-- <option value="무통장입금">무통장입금</option> -->
                </select>
            </li>
            <li><button type="button" onclick="requestPay()">결제하기</button></li>
        </ul>
    </form>
</section>
<!-- e: content -->
<%@ include file="guest_bottom.jsp" %>
<script type="text/javascript" src="https://cdn.iamport.kr/js/iamport.payment-1.2.0.js"></script>
<script type="text/javascript">
    let payUser = "${inUser.user_id}";
    let HouseNum = $("input[name='house_num']").val();
    let HouseName = "${reserveInfo.house_name}";
    let checkIn = $("input[name='reserv_checkin']").val();
    let checkOut = $("input[name='reserv_checkout']").val();
    let PeoPel = $("input[name='reserv_person']").val();
    let allDayPay = $("input[name='reserv_pay']").val();
    let vat = $("input[name='reserv_paycharge']").val();
    let totalPay = $("input[name='reserv_totpay']").val();
    let payType = $(".reserve_opt option:selected").val();
    
    function requestPay() {
        IMP.init('imp82624668');
        IMP.request_pay({
            pg: 'kakaopay.TC0ONETIME',
            pay_method: 'card',
            merchant_uid: 'JAVAJO_' + new Date().getTime(), // 주문번호
            name: HouseName, // 결제할 상품
            amount: totalPay, // 결제금액
            buyer_name: payUser // 구매자 이름(id)
        }, function (rsp) {
            if (rsp.success) {
                // 결제 성공 시
                $.ajax({
                    url: '${pageContext.request.contextPath}/insertReserve.ajax',
                    method: 'POST',
                    contentType: 'application/json',
                    dataType: 'json',
                    data: JSON.stringify({
                        imp_uid: rsp.imp_uid,
                        merchant_uid: rsp.merchant_uid,
                        paid_amount: rsp.paid_amount,
                        user_id: payUser,
                        house_num: HouseNum,
                        house_name: HouseName,
                        reserv_status: '결제완료',
                        reserv_checkin: checkIn,
                        reserv_checkout: checkOut,
                        reserv_person: PeoPel,
                        reserv_pay: allDayPay,
                        reserv_paycharge: vat,
                        reserv_totpay: totalPay,
                        reserv_paytype: payType
                    }),
                    success: function(response) {
                        if (response.status === 'success') {
                            alert('결제가 성공적으로 완료되었습니다.');
                            window.location = "reserve_list.do";
                        } else {
                            console.log('결제 처리 중 오류가 발생했습니다. 다시 시도해 주세요.');
                        }
                    },
                    error: function(xhr, status, error) {
                        console.error('결제 처리 중 오류가 발생했습니다:', error);
                    }
                });
            } else {
                // 결제 실패 시
                alert('결제에 실패했습니다. 에러 내용: ' + rsp.error_msg);
            }
        });
    }
</script>