<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import = "java.sql.*"%>
<%@ page import = "vo.*"%>
<%
	//인코딩
	request.setCharacterEncoding("utf8");
	
	//세션 유효성 검사
	if(session.getAttribute("loginMemberId") == null) {
	   response.sendRedirect(request.getContextPath()+"/board/boardOne.jsp");
	   return;
	} 
	
	//유효성 검사
	if(request.getParameter("commentContent") == null
		|| request.getParameter("boardNo") == null
		|| request.getParameter("memberId") == null) {
		response.sendRedirect(request.getContextPath()+"/board/boardOne.jsp");
		return;
	} 
	
	//값 지정
	int boardNo = Integer.parseInt(request.getParameter("boardNo"));
	String commentContent = request.getParameter("commentContent");
	String memberId = request.getParameter("memberId");
	
		System.out.println(boardNo + "<- 댓글입력 boardNo");
		System.out.println(commentContent + "<- 댓글입력 commentContent");
		System.out.println(memberId + "<- 댓글입력 memberId");
		
	//드라이브 로딩 및 쿼리실행
	String driver = "org.mariadb.jdbc.Driver";
	String dburl = "jdbc:mariadb://127.0.0.1:3306/userboard";
	String dbuser = "root";
	String dbpw = "java1234";
	Class.forName(driver);
	Connection conn = null;
	conn = DriverManager.getConnection(dburl, dbuser, dbpw);
	
	/*
		INSERT INTO COMMENT(comment_content commentContent, member_id memberId, createdate, updatedate) 
		VALUE(?, ?, NOW(), NOW())";
	*/
	PreparedStatement commentstmt = null;
	String commentSql = "INSERT INTO COMMENT(comment_content, member_id, board_no, createdate, updatedate) VALUES(?, ?, ?, NOW(), NOW())";
	commentstmt = conn.prepareStatement(commentSql);
	commentstmt.setString(1, commentContent);
	commentstmt.setString(2, memberId);
	commentstmt.setInt(3, boardNo);
	
	int row = commentstmt.executeUpdate();
	
	if(row==1){//성공 
		System.out.println(row + "<--댓글입력 성공");
		response.sendRedirect(request.getContextPath()+"/board/boardOne.jsp?boardNo=" + boardNo);
		
	} else {//실패
		System.out.println(row + "<--댓글입력 실패");
		response.sendRedirect(request.getContextPath()+"/board/boardOne.jsp");
		return;
	}
%>