package com.itwillbs.with_me.handler;

import com.itwillbs.with_me.service.PaymentService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

@Component
public class PaymentClient {

    @Autowired
    private PaymentService paymentService;

    public String processCancelPayment(String impUid, String merchantUid) throws Exception {
    	String token = paymentService.getToken(); // 토큰 발급
        paymentService.cancelPayment(impUid, merchantUid, token); // 결제 취소 요청
        return "결제가 성공적으로 취소되었습니다.";
    }
}
