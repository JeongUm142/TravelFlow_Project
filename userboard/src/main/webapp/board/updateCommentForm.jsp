<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import = "java.sql.*"%>
<%@ page import = "java.util.*"%>
<%@ page import = "vo.*"%>
<%
	//세션 유효성 검사
	if(session.getAttribute("loginMemberId") == null) {
	   response.sendRedirect(request.getContextPath()+"/home.jsp");
	   return;
	} 
	//유효성 검사 
	if(request.getParameter("commentNo") == null) {
		response.sendRedirect(request.getContextPath()+"/home.jsp");
		return;
	}
	//id값 받기 
	String memberId = (String)session.getAttribute("loginMemberId");	
	int commentNo = Integer.parseInt(request.getParameter("commentNo"));
	
	String driver = "org.mariadb.jdbc.Driver";
	String dburl = "jdbc:mariadb://127.0.0.1:3306/userboard";
	String dbuser = "root";
	String dbpw = "java1234";
	Class.forName(driver);
	Connection conn = null;
	conn = DriverManager.getConnection(dburl, dbuser, dbpw);
	
	/*
		"SELECT comment_no commentNo, board_no boardNo, comment_content commentContent, member_id memberId, createdate, updatedate 
		FROM comment WHERE comment_no = ?";
	*/
	PreparedStatement commentStmt = null;
	ResultSet commentRs = null;
	String commentSql = "SELECT comment_no commentNo, board_no boardNo, comment_content commentContent, member_id memberId, createdate, updatedate FROM comment WHERE comment_no = ?";
	commentStmt = conn.prepareStatement(commentSql);
	commentStmt.setInt(1, commentNo);
		System.out.println(commentStmt + "<--댓글 수정 commentStmt");
		
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
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
	<title>TravelFlow</title>
	<link href="<%=request.getContextPath()%>/img/boardfavicon.png" rel="icon">
	<!-- Latest compiled and minified CSS -->
	<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/css/bootstrap.min.css" rel="stylesheet">
	<!-- Latest compiled JavaScript -->
	<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/js/bootstrap.bundle.min.js"></script>
</head>
<body>
<div class="container">
<!-- home으로 갈 이미지 -->
	<div>
      <jsp:include page="/inc/mainmenu2.jsp"></jsp:include>
	</div>
<!-- 메인메뉴(가로) -->
	<div><!-- 서버기술이기 때문에 ﹤% request...%﹥를 쓸 필요가 없음 -->
      <jsp:include page="/inc/mainmenu.jsp"></jsp:include>
	</div>

	<h1>댓글 수정</h1>
<hr>
	<%
		if(request.getParameter("msg") != null) {
	%>
		<div style="font-size: 20px; color: #F15F5F"><%=request.getParameter("msg")%></div><br>
	<%
		}
	%>
	<form action="<%=request.getContextPath()%>/board/updateCommentAction.jsp?commentNo=<%=comment.getCommentNo()%>&boardNo=<%=comment.getBoardNo()%>">
		<table class="table table-bordered">
			<tr>
				<td class="table-warning">현재 댓글</td>
				<td>
					<input type="hidden" name="commentNo" value="<%=comment.getCommentNo()%>">
					<input type="hidden" name="boardNo" value="<%=comment.getBoardNo()%>">
					<input type ="text" name="comment" value="<%=comment.getCommentContent()%>" class="form-control form-control-sm" readonly>
					</td>
			</tr>
			<tr>
				<td class="table-warning" >수정 댓글</td>
				<td><input type ="text" name="upComment" class="form-control form-control-sm"></td>
			</tr>
		</table>
		<a href="<%=request.getContextPath()%>/board/boardOne.jsp?boardNo=<%=comment.getBoardNo()%>" class="btn btn-sm btn-outline-dark">취소</a>
		<button type="submit" class="btn btn-sm btn-outline-dark">수정</button>
	</form>
</div>
<div>
	<!-- include 페이지 : Copyright &copy; 신정음 -->
	<jsp:include page="/inc/copyright.jsp"></jsp:include>
</div>
</body>
</html>