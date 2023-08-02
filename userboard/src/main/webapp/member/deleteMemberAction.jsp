<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import = "java.sql.*"%>
<%@ page import = "java.net.*"%>
<%@ page import = "vo.*" %>
<%
	//인코딩 설정
	request.setCharacterEncoding("utf-8");

	//1.세션 유효성검사 
	if(session.getAttribute("loginMemberId") == null) {
		response.sendRedirect(request.getContextPath()+"/home.jsp");
		return;
	}
	
	String memberId = (String)session.getAttribute("loginMemberId");	
	String chackPw = request.getParameter("chackPw");
		//디버깅
		System.out.println(memberId + "<- 탈퇴 memberId");
		System.out.println(chackPw + "<- 탈퇴 chackPw");
		
	//메시지
	String msg = "";
	
	String driver = "org.mariadb.jdbc.Driver";
	String dburl = "jdbc:mariadb://127.0.0.1:3306/userboard";
	String dbuser = "root";
	String dbpw = "java1234";
	Class.forName(driver);
	Connection conn = null;
	PreparedStatement stmt = null;
	ResultSet rs = null;
	conn = DriverManager.getConnection(dburl, dbuser, dbpw);
	
	/*
    DELETE 
    FROM member 
    WHERE member_id=? and member_pw=PASSWORD(?)";
 	*/
	String sql = " DELETE FROM member WHERE member_id=? and member_pw=PASSWORD(?)";
	stmt = conn.prepareStatement(sql);
	stmt.setString(1, memberId);
	stmt.setString(2, chackPw);
		System.out.println(stmt + "<--로그인 액션 stmt");
	
	int row = stmt.executeUpdate();
	if(row == 1) {//성공 
		System.out.println(row + "<--탈퇴성공");
		msg = URLEncoder.encode("지금까지 이용해주셔서 감사합니다.","utf-8");
		session.invalidate();//세션무효화
		response.sendRedirect(request.getContextPath()+"/home.jsp?msg="+msg);
	} else {
		System.out.println(row + "<--탈퇴실패");
		msg = URLEncoder.encode("비밀번호를 확인해주세요.","utf-8");
		response.sendRedirect(request.getContextPath()+"/member/deleteMemberForm.jsp?msg="+msg);
		return;
	}
%>