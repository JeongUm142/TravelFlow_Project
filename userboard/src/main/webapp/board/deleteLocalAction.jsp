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
	//2.요청값 유효성검사
	if(request.getParameter("localName")==null 
		|| request.getParameter("localNameRe")==null
		|| request.getParameter("localName").equals ("")
		|| request.getParameter("localNameRe").equals("")){
		response.sendRedirect(request.getContextPath()+"/board/deleteLocalForm.jsp");
		return;
		}
	
	String localName = request.getParameter("localName");
	String localNameRe = request.getParameter("localNameRe");
		//디버깅
		System.out.println(localName + "<- 지역 삭제 localName");
		System.out.println(localNameRe + "<- 지역 삭제 localNameRe");
		
	//메시지
	String msg = "";
	
	//지역명 일치 검사
	if(!localName.equals(localNameRe)){//비밀번호 오류
		System.out.println("지역명 오류");
		msg = URLEncoder.encode("지역명을 확인해주세요","utf-8");
		response.sendRedirect("./deleteLocalForm.jsp?msg="+msg);
		return;
	}
	
	String driver = "org.mariadb.jdbc.Driver";
	String dburl = "jdbc:mariadb://127.0.0.1:3306/userboard";
	String dbuser = "root";
	String dbpw = "java1234";
	Class.forName(driver);
	Connection conn = null;
	conn = DriverManager.getConnection(dburl, dbuser, dbpw);
	
	//게시물이 있을 경우 삭제 XX 
	/*
		SELECT count(*) FROM board WHERE local_name=?"
 	*/
 	PreparedStatement localDelStmt = null;
	String localDelSql = "SELECT count(*) FROM board WHERE local_name=?";
	ResultSet localDelRs = null;
	localDelStmt = conn.prepareStatement(localDelSql);
	localDelStmt.setString(1, localName);
		System.out.println(localDelStmt + "<-- 삭제지역 게시물 확인 stmt");
	localDelRs = localDelStmt.executeQuery();
	
	int cnt = 0;
	if(localDelRs.next()){
		cnt = localDelRs.getInt("count(*)");
	} 
	
	if(cnt != 0) {
		System.out.println("게시물 삭제 필요");
		msg = URLEncoder.encode("해당 지역의 게시글을 삭제 후 다시 시도해주세요.","utf-8");
		response.sendRedirect(request.getContextPath() + "/board/deleteLocalForm.jsp?msg="+msg);
		return;
	}

	//지역 삭제
	/*
		DELETE FROM board WHERE local_name=?"
 	*/
	String localDelSql2 = "DELETE FROM local WHERE local_name=?";
 	PreparedStatement localDelStmt2 = null;
	ResultSet localDelRs2 = null;
	localDelStmt2 = conn.prepareStatement(localDelSql2);
	localDelStmt2.setString(1, localName);
		System.out.println(localDelStmt2 + "<-- 지역삭제 stmt2");
	
	int row = localDelStmt2.executeUpdate();
	
	if(row == 1) {//성공 
		System.out.println(row + "<--지역삭제 성공");
		response.sendRedirect(request.getContextPath()+"/board/category.jsp");
	} else {
		System.out.println(row + "<--지역삭제 실패");
		response.sendRedirect(request.getContextPath()+"/board/deleteLocalForm.jsp");
		return;
	}
%>