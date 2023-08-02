<%@page import="java.net.URLEncoder"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import = "java.sql.*"%>
<%@ page import = "vo.*" %>
<%
	//인코딩 설정
	request.setCharacterEncoding("utf-8");

	//메시지
	String msg = "";
	
	//1.세션 유효성검사 
	if(session.getAttribute("loginMemberId") == null) {
		response.sendRedirect(request.getContextPath()+"/home.jsp");
		return;
	}

	int boardNo = Integer.parseInt(request.getParameter("boardNo"));
	
	//2.요청값 유효성검사
	if(request.getParameter("createdateRe")==null 
		|| request.getParameter("createdateRe").equals("")){
		msg = URLEncoder.encode("작성일을 확인해주세요.(YYYY-MM-DD형식으로 입력)","utf-8");
		response.sendRedirect(request.getContextPath()+"/board/deleteBoardForm.jsp?msg="+ msg + "&boardNo=" + boardNo);
		return;
		}
	
	String createdate = request.getParameter("createdate");
	String createdateRe = request.getParameter("createdateRe");
		//디버깅
		System.out.println(createdate + "<- 게시글 삭제 createdate");
		System.out.println(createdateRe + "<- 게시글 삭제 createdateRe");
	
	//지역명 일치 검사
	if(!createdate.equals(createdateRe)){//오류
		System.out.println("게시글 작성일 오류");
		msg = URLEncoder.encode("작성일을 확인해주세요.(YYYY-MM-DD형식으로 입력)","utf-8");
		response.sendRedirect(request.getContextPath()+"/board/deleteBoardForm.jsp?msg="+ msg + "&boardNo=" + boardNo);
		return;
	}
	
	String driver = "org.mariadb.jdbc.Driver";
	String dburl = "jdbc:mariadb://127.0.0.1:3306/userboard";
	String dbuser = "root";
	String dbpw = "java1234";
	Class.forName(driver);
	Connection conn = null;
	conn = DriverManager.getConnection(dburl, dbuser, dbpw);

	//게시물 삭제
	/*
		DELETE FROM board WHERE local_name=?"
	*/
	String boardDelSql = "DELETE FROM board WHERE board_no = ?";
	PreparedStatement boardDelStmt = null;
	ResultSet boardDelRs = null;
	boardDelStmt = conn.prepareStatement(boardDelSql);
	boardDelStmt.setInt(1, boardNo);
		System.out.println(boardDelStmt + "<-- 게시물삭제  stmt");
	
	int row = boardDelStmt.executeUpdate();
	
	if(row == 1) {//성공 
		System.out.println(row + "<--게시글삭제 성공");
		response.sendRedirect(request.getContextPath()+"/home.jsp");
	} else {
		System.out.println(row + "<--게시글삭제 실패");
		response.sendRedirect(request.getContextPath()+"/board/deleteBoardForm.jsp?boardNo="+boardNo);
		return;
	}
%>