<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import = "java.sql.*"%>
<%@ page import = "java.net.*"%>
<%@ page import = "vo.*" %>
<%
	//인코딩 설정
	request.setCharacterEncoding("utf-8");

	//1.세션 유효성검사 
	if(session.getAttribute("loginMemberId") != null) {
		response.sendRedirect(request.getContextPath()+"/home.jsp");
		return;
	}

	//2.요청값 유효성검사
	String memberId = request.getParameter("memberId");
	String memberPw = request.getParameter("memberPw");
		//디버깅
		System.out.println(memberId + "<--로그인 memberId");
		
	Member paramMember = new Member();
	paramMember.setMemberId(paramMember.getMemberId());
	paramMember.setMemberPw(paramMember.getMemberPw());
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
    SELECT member_id memberId FROM member 
    WHERE member_id = ? AND member_pw = PASSWORD(?)"
 	*/
	String sql = "SELECT member_id memberId FROM member WHERE member_id = ? AND member_pw = PASSWORD(?)";
	stmt = conn.prepareStatement(sql);
	stmt.setString(1, memberId);
	stmt.setString(2, memberPw);
		System.out.println(stmt + "<--로그인 액션 stmt");
	rs = stmt.executeQuery();
	
	if(rs.next()) {//로그인 성공
		//세션에 로그인정보 저장
		session.setAttribute("loginMemberId", rs.getString("memberId"));
		System.out.println("로그인 성공 세션정보 : " + session.getAttribute("loginMemberId"));
		response.sendRedirect(request.getContextPath()+"/home.jsp?msg="+msg);
	} else { // 로그인 실패
		System.out.println("로그인 실패");
		msg = URLEncoder.encode("ID와 PW를 확인해주세요.", "utf-8");
		response.sendRedirect(request.getContextPath()+"/home.jsp?msg="+msg);
	}
	
%>