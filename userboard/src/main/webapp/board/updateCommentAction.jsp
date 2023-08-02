<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import = "java.sql.*"%>
<%@ page import = "java.util.*"%>
<%@ page import = "java.net.*"%>
<%@ page import = "vo.*"%>
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
	
	// commentNo 유효성 검사시 사용을 위해
	int commentNo = Integer.parseInt(request.getParameter("commentNo"));
	
	//유효성 검사 
	if(request.getParameter("commentNo") == null
		|| request.getParameter("comment")==null
		|| request.getParameter("upComment")==null
		|| request.getParameter("comment").equals ("")
		|| request.getParameter("upComment").equals ("")) {
		msg = URLEncoder.encode("수정할 댓글을 입력해주세요.","utf-8");
		response.sendRedirect(request.getContextPath()+"/board/updateCommentForm.jsp?msg=" + msg + "&commentNo=" + commentNo);
		return;
	} 
	
	//변수
	int boardNo = Integer.parseInt(request.getParameter("boardNo"));
	String comment = request.getParameter("comment");
	String upComment = request.getParameter("upComment");
	
		System.out.println(boardNo + "<-- 댓글 업데이트 액션 boardNo");
		// System.out.println(commentNo + "<-- 댓글 업데이트 액션 commentNo");
		// System.out.println(comment + "<-- 댓글 업데이트 액션 comment");
		// System.out.println(upComment + "<-- 댓글 업데이트 액션 upComment");
	
	String driver = "org.mariadb.jdbc.Driver";
	String dburl = "jdbc:mariadb://127.0.0.1:3306/userboard";
	String dbuser = "root";
	String dbpw = "java1234";
	Class.forName(driver);
	Connection conn = null;
	conn = DriverManager.getConnection(dburl, dbuser, dbpw);	
	
	/*
		"UPDATE comment SET comment_content = ? updatedate = now() WHERE comment_content = ?"
	*/
	PreparedStatement CommentUpstmt = null;
	ResultSet CommentUpRs = null;
	String CommentUpsql = "UPDATE comment SET comment_content = ?, updatedate = now() WHERE comment_no = ?";
	CommentUpstmt = conn.prepareStatement(CommentUpsql);
	CommentUpstmt.setString(1, upComment);
	CommentUpstmt.setInt(2, commentNo);
		System.out.println(CommentUpstmt + "<--댓글 수정 액션 stmt");
	
	int row = CommentUpstmt.executeUpdate();
	if(row == 1) {//성공 
		System.out.println(row + "<--댓글 수정 성공");
		response.sendRedirect(request.getContextPath()+"/board/boardOne.jsp?boardNo=" + boardNo);
	} else {
		System.out.println(row + "<--댓글 수정 실패");
		response.sendRedirect(request.getContextPath()+"/board/updateCommentForm.jsp?commentNo=" + commentNo);
		return;
	}
%>