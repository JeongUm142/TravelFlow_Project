<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import = "java.sql.*"%>
<%@ page import = "java.net.*"%>
<%@ page import = "vo.*" %>
<%
	//1.세션 유효성검사 
	if(session.getAttribute("loginMemberId") == null) {
		response.sendRedirect(request.getContextPath()+"/home.jsp");
		return;
	}
		
	String memberId = (String)session.getAttribute("loginMemberId");
	String beforePw = request.getParameter("beforePw");
	String newPw = request.getParameter("newPw");
	String newPwRe = request.getParameter("newPwRe");
		//디버깅
		System.out.println(beforePw + "<- 비밀번호수정 beforePw");
		System.out.println(newPw + "<- 비밀번호수정 newPw");
		System.out.println(newPwRe + "<- 비밀번호수정 newPwRe");
		
	//메시지
	String msg = "";
	
	// 비밀번호 일치 검사
	if(!newPw.equals(newPwRe)){//비밀번호 오류
		System.out.println("비밀번호 오류");
		msg = URLEncoder.encode("새 비밀번호를 확인해주세요","utf-8");
		response.sendRedirect("./updatePwForm.jsp?msg="+msg);
		return;
	}
	
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
    UPDATE member SET member_pw = PASSWORD(?)
    WHERE member_id=? and member_pw=PASSWORD(?)";
 	*/
	String sql = "UPDATE member SET member_pw = PASSWORD(?) WHERE member_id=? and member_pw=PASSWORD(?)";
	stmt = conn.prepareStatement(sql);
	stmt.setString(1, newPw);
	stmt.setString(2, memberId);
	stmt.setString(3, beforePw);
		System.out.println(stmt + "<--비밀번호수정 액션 stmt");
	
	int row = stmt.executeUpdate();
	if(row == 1) {//성공 
		System.out.println(row + "<--비밀번호 변경성공");
		msg = URLEncoder.encode("비밀번호가 변경되었습니다. 다시 로그인해주시기 바랍니다.","utf-8");
		session.invalidate();//세션무효화
		response.sendRedirect(request.getContextPath()+"/home.jsp?msg="+msg);
	} else {
		System.out.println(row + "<--비밀번호 변경실패");
		msg = URLEncoder.encode("비밀번호를 확인해주세요.","utf-8");
		response.sendRedirect(request.getContextPath()+"/member/updatePwForm.jsp?msg="+msg);
		return;
	}
%>