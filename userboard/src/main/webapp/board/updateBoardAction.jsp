<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import = "java.sql.*"%>
<%@ page import = "java.util.*"%>
<%@ page import = "java.net.*"%>
<%@ page import = "vo.*" %>   
<%
	//인코딩 설정
	request.setCharacterEncoding("utf-8");

	//세션 유효성 검사
	if(session.getAttribute("loginMemberId") == null) {
	   response.sendRedirect(request.getContextPath()+"/home.jsp");
	   return;
	} 

	//메시지
	String msg = "";

	//변수
	String updateLocal = request.getParameter("updateLocal");
	String updateTitle = request.getParameter("updateTitle");
	String updateContent = request.getParameter("updateContent");
	int boardNo = Integer.parseInt(request.getParameter("boardNo"));
		System.out.println(updateLocal + "<-- 게시글 업데이트 액션 updateLocal");
		System.out.println(updateTitle + "<-- 게시글 업데이트 액션 updateTitle");
		System.out.println(updateContent + "<-- 게시글 업데이트 액션 updateContent");
		System.out.println(boardNo + "<-- 게시글 업데이트 액션 boardNo");

	//유효성 검사 
	if(request.getParameter("boardNo") == null
		|| request.getParameter("updateTitle")==null 
		|| request.getParameter("updateContent")==null 	
		|| request.getParameter("updateLocal")==null
		|| request.getParameter("updateTitle").equals("")
		|| request.getParameter("updateContent").equals("")
		|| request.getParameter("updateLocal").equals ("")) {
		msg = URLEncoder.encode("게시물 내용을 모두 입력해주세요","utf-8");
		response.sendRedirect(request.getContextPath()+"/board/updateBoardForm.jsp?msg="+ msg + "&boardNo=" + boardNo);
		return;
	} 
	
	String driver = "org.mariadb.jdbc.Driver";
	String dburl = "jdbc:mariadb://127.0.0.1:3306/userboard";
	String dbuser = "root";
	String dbpw = "java1234";
	Class.forName(driver);
	Connection conn = null;
	conn = DriverManager.getConnection(dburl, dbuser, dbpw);	
	
	/*
		"UPDATE userboard SET local_name = ?, board_title = ?, board_content = ?, updatedate "
	*/
	PreparedStatement BoardUpstmt = null;
	ResultSet BoardUpRs = null;
	String BoradUpsql = "UPDATE board SET local_name = ?, board_title = ?, board_content = ?, updatedate = now() WHERE board_no=?";
	BoardUpstmt = conn.prepareStatement(BoradUpsql);
	BoardUpstmt.setString(1, updateLocal);
	BoardUpstmt.setString(2, updateTitle);
	BoardUpstmt.setString(3, updateContent);
	BoardUpstmt.setInt(4, boardNo);
		System.out.println(BoardUpstmt + "<--게시글 수정 액션 stmt");
	
	int row = BoardUpstmt.executeUpdate();
	if(row == 1) {//성공 
		System.out.println(row + "<--게시글 수정 성공");
		response.sendRedirect(request.getContextPath()+"/board/boardOne.jsp");
	} else {
		System.out.println(row + "<--게시글 수정 실패");
		response.sendRedirect(request.getContextPath()+"/board/updateBoardForm..jsp");
		return;
	}
%>  
