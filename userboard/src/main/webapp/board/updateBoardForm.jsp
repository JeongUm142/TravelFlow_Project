<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import = "java.sql.*"%>
<%@ page import = "java.util.*"%>
<%@ page import = "vo.*" %>
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
		SELECT board_no boardNo, local_name localName, board_title boardTitle, board_content boardContent, member_id memberId, createdate, updatedate 
		FROM board WHERE board_no = ?";
	*/
	PreparedStatement boardStmt = null;
	ResultSet boardRs = null;
	String boardSql = "SELECT board_no boardNo, local_name localName, board_title boardTitle, board_content boardContent, member_id memberId, createdate, updatedate FROM board WHERE board_no = ?";
	boardStmt = conn.prepareStatement(boardSql);
	boardStmt.setInt(1, boardNo);
		System.out.println(boardStmt + "<--게시글 수정 localStmt");
		
	boardRs = boardStmt.executeQuery(); 
	Board board = new Board();
	if(boardRs.next()){//있을때만 생성
		board = new Board();
		board.setBoardNo(boardRs.getInt("boardNo"));
		board.setLocalName(boardRs.getString("localName"));
		board.setBoardTitle(boardRs.getString("boardTitle"));
		board.setBoardContent(boardRs.getString("boardContent"));
		board.setMemberId(boardRs.getString("memberId"));
		board.setCreatedate(boardRs.getString("createdate"));
		board.setUpdatedate(boardRs.getString("updatedate"));
	}
	//지역 선택을 위한 쿼리 
	PreparedStatement localStmt = null;
	ResultSet localRs = null;
	String localsql = "SELECT local_name localName FROM local";
	localStmt = conn.prepareStatement(localsql);
		System.out.println(localStmt + "<--게시글 수정에서 지역 localStmt");
		
	localRs = localStmt.executeQuery(); 
	
	ArrayList<Local> localList = new ArrayList<Local>();
	while(localRs.next()){
		Local l = new Local();
		l.setLocalName(localRs.getString("localName"));
		localList.add(l);
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

	<h1>게시물 수정</h1>
<hr>
	<%
		if(request.getParameter("msg") != null) {
	%>
		<div style="font-size: 20px; color: #F15F5F; text-align: center;"><%=request.getParameter("msg")%></div><br>
	<%
		}
	%>
	<form action="<%=request.getContextPath()%>/board/updateBoardAction.jsp?boardNo=<%=board.getBoardNo()%>">
	<table class="table table-bordered" style="text-align: center; vertical-align: middle;">
	<tr>
		<td><input type="text" name="boardNo" hidden="hidden" value="<%=board.getBoardNo()%>"></td>
		<td class="table-warning">수정 게시물 내용</td>
		<td class="table-warning">현재 게시물 내용</td>
	</tr>
		<tr>
			<td style="width: 100px" class="table-warning">지역</td>
			<td>
				<select name ="updateLocal" class="form-select form-select-sm">
	<%
		for(Local l : localList) {
	%>
				<option value="<%=l.getLocalName()%>"><%=l.getLocalName()%></option>
	<%
		}
	%>
				</select>	
			<td><input type="text" value="<%=board.getLocalName()%>" class="form-control form-control-sm" disabled></td>
		</tr>
	
		<tr>
			<td class="table-warning">제목</td>
			<td><input type="text" name ="updateTitle" value="<%=board.getBoardTitle()%>" class="form-control form-control-sm"></td>
			<td><input type="text" value="<%=board.getBoardTitle()%>" class="form-control form-control-sm" disabled></td>
		</tr>
		
		<tr>
			<td class="table-warning">내용</td>
			<td><textarea cols="50" rows="2" name ="updateContent" class="form-control form-control-sm"><%=board.getBoardContent()%></textarea></td>
			<td><textarea cols="50" rows="2" class="form-control form-control-sm" disabled><%=board.getBoardContent()%></textarea></td>
		</tr>
	
		<tr>
			<td class="table-warning">작성자</td>
			<td colspan="2"><input type="text" name ="MemberId" value="<%=board.getMemberId()%>" class="form-control form-control-sm" disabled></td>
		</tr>
		
		<tr>
			<td class="table-warning">작성일</td>
			<td colspan="2"><input type="text" name ="createdate" value="<%=board.getCreatedate()%>" class="form-control form-control-sm" disabled></td>
		</tr>
	</table>
	<a href="<%=request.getContextPath()%>/board/boardOne.jsp?boardNo=<%=board.getBoardNo()%>" class="btn btn-sm btn-outline-dark">취소</a>
	<button type="submit" class="btn btn-sm btn-outline-dark">수정</button>
	</form>
</div>
<div>
	<!-- include 페이지 : Copyright &copy; 신정음 -->
	<jsp:include page="/inc/copyright.jsp"></jsp:include>
</div>
</body>
</html>