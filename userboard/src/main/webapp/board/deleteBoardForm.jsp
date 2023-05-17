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
	if(request.getParameter("boardNo") == null) {
		response.sendRedirect(request.getContextPath()+"/home.jsp");
		return;
	} 
	 
	//id값 받기 
	String memberId = (String)session.getAttribute("loginMemberId");	
	int boardNo = Integer.parseInt(request.getParameter("boardNo"));
	
	String driver = "org.mariadb.jdbc.Driver";
	String dburl = "jdbc:mariadb://127.0.0.1:3306/userboard";
	String dbuser = "root";
	String dbpw = "java1234";
	Class.forName(driver);
	Connection conn = null;
	conn = DriverManager.getConnection(dburl, dbuser, dbpw);
	
	/*
		SELECT board_no boardNo, local_name localName, board_title boardTitle, board_content boardContent, member_id memberId, createdate
		FROM board WHERE board_no = ?";
	*/
	PreparedStatement boardStmt = null;
	ResultSet boardRs = null;
	String boardSql = "SELECT board_no boardNo, local_name localName, board_title boardTitle, board_content boardContent, member_id memberId, createdate FROM board WHERE board_no = ?";
	boardStmt = conn.prepareStatement(boardSql);
	boardStmt.setInt(1, boardNo);
		System.out.println(boardStmt + "<--게시글 수정 localStmt");
		
	boardRs = boardStmt.executeQuery(); 
	Board board = new Board();
	ArrayList<Board> boardList= new ArrayList<Board>();
	if(boardRs.next()){//있을때만 생성
		board = new Board();
		board.setBoardNo(boardRs.getInt("boardNo"));
		board.setLocalName(boardRs.getString("localName"));
		board.setBoardTitle(boardRs.getString("boardTitle"));
		board.setBoardContent(boardRs.getString("boardContent"));
		board.setMemberId(boardRs.getString("memberId"));
		board.setCreatedate(boardRs.getString("createdate"));
	}
%>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
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

	<h1>게시물 삭제</h1>
<hr>
 	<%
		if(request.getParameter("msg") != null) {
	%>
		<div style="font-size: 20px; color: #F15F5F"><%=request.getParameter("msg")%></div><br>
    <%
		}
	%>
	<form action="<%=request.getContextPath()%>/board/deleteBoardAction.jsp?boardNo=<%=board.getBoardNo()%>">
	<table class="table table-bordered" style="text-align: center; vertical-align: middle;">
	<tr>
		
	</tr>
		<tr>
			<td style="width: 100px" class="table-warning" >지역</td>
			<td><input type="text" value="<%=board.getLocalName()%>" class="form-control form-control-sm" disabled></td>
		</tr>
	
		<tr>
			<td class="table-warning">제목</td>
			<td><input type="text" value="<%=board.getBoardTitle()%>" class="form-control form-control-sm" disabled></td>
		</tr>
		
		<tr>
			<td class="table-warning">내용</td>
			<td><textarea cols="50" rows="2" class="form-control form-control-sm" disabled><%=board.getBoardContent()%></textarea></td>
			
		</tr>
	
		<tr>
			<td class="table-warning">작성자</td>
			<td>
			<input type="text" value="<%=board.getMemberId()%>" class="form-control form-control-sm" disabled>
			<input type="text" name="boardNo" hidden="hidden" value="<%=board.getBoardNo()%>">
			</td>
		</tr>
		
		<tr>
			<td class="table-warning">작성일</td>
			<td><input type="text" name="createdate" value="<%=board.getCreatedate()%>" class="form-control form-control-sm" readonly></td>
		</tr>
		
		<tr>
			<td class="table-warning">작성일 확인</td>
			<td><input type="text" name ="createdateRe" placeholder="YYYY-MM-DD" class="form-control form-control-sm"></td>
		</tr>
	</table>
	<a href="<%=request.getContextPath()%>/board/boardOne.jsp?boardNo=<%=board.getBoardNo()%>" class="btn btn-sm btn-outline-dark">취소</a>
	<button type="submit" class="btn btn-sm btn-outline-dark">삭제</button>
	</form>
</div>
</body>
</html>