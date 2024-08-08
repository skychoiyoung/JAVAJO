package com.javajo.project;

import javax.servlet.http.HttpServletRequest;

import org.springframework.web.bind.annotation.ControllerAdvice;
import org.springframework.web.bind.annotation.ExceptionHandler;

//@ControllerAdvice
//public class ExceptionController {
//
//	@ExceptionHandler(NullPointerException.class)
//	public String controlNullPointerException(NullPointerException ex, HttpServletRequest req) {
//		if (req.getSession().getAttribute("inUser") != null) {
//			req.setAttribute("msg", "잘못된 접근입니다. 이전 페이지로 이동합니다.");
//			req.setAttribute("url", "");
//		} else {
//			req.setAttribute("msg", "잘못된 접근입니다. 로그인 페이지로 이동합니다.");
//			req.setAttribute("url", "login.do");
//		}
//		return "message";
//	}
//}
