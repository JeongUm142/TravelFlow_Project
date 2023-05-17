<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import  = "vo.*"%>
<%
	//필드가 정보 은닉이 안된 Data클래스
	Data d = new Data();
	d.x = 7;
	d.y = 10;
	System.out.println(d.x);
	System.out.println(d.y);
	
	//정보은닉의 단계 private -> default(아무것도 안씀) -> protected -> public
	Data2 d2 = new Data2();
	d.x = 7;
	// d.y = 10; // Date2 y필드는 private으로 정보은닉 되어있음으로 에러 발생
	System.out.println(d2.x);
	
	//정보은닉 - 속성을 숨기기
	//프라이빗 - 나만 볼 수 있음/ 파이썬 self(자바 This)라는 접근제한자를 사용하여 확인 가능
	//프로텍트 - 특정인은 볼 수 있음
	
	//캡슐화 - 정보은닉 된 정보를 제한적으로 읽거나 쓰기 제공 -> 자바에서는 매소드를 통해서만 진행
%>
