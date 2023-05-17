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

	//2.요청값 유효성검사
	if(request.getParameter("createdateRe")==null 
		|| request.getParameter("createdateRe").equals("")){
		response.sendRedirect(request.getContextPath()+"/board/deleteCommentForm.jsp");
		return;
		}
	
	int commentNo = Integer.parseInt(request.getParameter("commentNo"));
	String createdate = request.getParameter("createdate");
	String createdateRe = request.getParameter("createdateRe");
		//디버깅
		System.out.println(createdate + "<- 댓글 삭제 createdate");
		System.out.println(createdateRe + "<- 댓글 삭제 createdateRe");
		
	//메시지
	String msg = "";
	
	//지역명 일치 검사
	if(!createdate.equals(createdateRe)){//비밀번호 오류
		System.out.println("댓글 작성일 오류");
		msg = URLEncoder.encode("작성일을 확인해주세요.(YYYY-MM-DD형식으로 입력)","utf-8");
		response.sendRedirect(request.getContextPath()+"/board/deleteCommentForm.jsp?msg="+ msg);
		return;
	}
	
	String driver = "org.mariadb.jdbc.Driver";
	String dburl = "jdbc:mariadb://127.0.0.1:3306/userboard";
	String dbuser = "root";
	String dbpw = "java1234";
	Class.forName(driver);
	Connection conn = null;
	conn = DriverManager.getConnection(dburl, dbuser, dbpw);

	//댓글 삭제
	/*
		DELETE FROM comment WHERE comment_no=?"
	*/
	String commentDelSql = "DELETE FROM comment WHERE comment_no = ?";
	PreparedStatement commentDelStmt = null;
	ResultSet commentDelRs = null;
	commentDelStmt = conn.prepareStatement(commentDelSql);
	commentDelStmt.setInt(1, commentNo);
		System.out.println(commentDelStmt + "<-- 댓글삭제  stmt");
	
	PreparedStatement commentStmt = null;
	ResultSet commentRs = null;
	String commentSql = "SELECT comment_no commentNo, board_no boardNo, comment_content commentContent, member_id memberId, createdate, updatedate FROM comment WHERE comment_no = ?";
	commentStmt = conn.prepareStatement(commentSql);
	commentStmt.setInt(1, commentNo);
		System.out.println(commentStmt + "<--댓글삭제 commentStmt");
		
	commentRs = commentStmt.executeQuery(); 
	Comment comment = new Comment();
	if(commentRs.next()){//있을때만 생성
		comment = new Comment();
		comment.setCommentNo(commentRs.getInt("commentNo"));
		comment.setBoardNo(commentRs.getInt("boardNo"));
		comment.setCommentContent(commentRs.getString("commentContent"));
		comment.setMemberId(commentRs.getString("memberId"));
		comment.setCreatedate(commentRs.getString("createdate"));
		comment.setUpdatedate(commentRs.getString("updatedate"));
	}	
		
	int row = commentDelStmt.executeUpdate();
	
	if(row == 1) {//성공 
		System.out.println(row + "<--댓글삭제 성공");
		response.sendRedirect(request.getContextPath()+"/boardOne.jsp?boardNo=");
	} else {
		System.out.println(row + "<--댓글삭제 실패");
		response.sendRedirect(request.getContextPath()+"/board/deleteBoardForm.jsp");
		return;
	}
%>