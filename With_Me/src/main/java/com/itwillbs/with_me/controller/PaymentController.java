package com.itwillbs.with_me.controller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RestController;

import com.itwillbs.with_me.handler.PaymentClient;
import com.itwillbs.with_me.vo.PremiumPaymentVO;

@RestController
public class PaymentController {

    @Autowired
    private PaymentClient paymentClient;

    @PostMapping("CancelPayment")
    public ResponseEntity<String> cancelPayment(@RequestBody PremiumPaymentVO request) {
        try {
        	String message = paymentClient.processCancelPayment(request.getImp_uid(), request.getMerchant_uid());
            return ResponseEntity.ok(message);
        } catch (Exception e) {
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body("결제 취소에 실패했습니다: " + e.getMessage());
        }
    }

}
