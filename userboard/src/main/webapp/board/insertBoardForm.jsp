<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import = "java.sql.*"%>
<%@ page import = "java.util.*"%>
<%@ page import = "vo.*"%>
<%
	//세션 유효성 검사
	if(session.getAttribute("loginMemberId")==null){
		response.sendRedirect(request.getContextPath()+"/home.jsp");
		return;
	}
	//게시물에 작성자를 작성하기 위해 id값 필요 
	String memberId = (String)session.getAttribute("loginMemberId");	

	String driver = "org.mariadb.jdbc.Driver";
	String dburl = "jdbc:mariadb://127.0.0.1:3306/userboard";
	String dbuser = "root";
	String dbpw = "java1234";
	Class.forName(driver);
	Connection conn = null;
	conn = DriverManager.getConnection(dburl, dbuser, dbpw);
	/*
	 "SELECT member_id memberId FROM board WHERE member_id = ?"
	*/
	PreparedStatement boardStmt = null;
	ResultSet boardRs = null;
	String boardSql = "SELECT member_id memberId FROM member WHERE member_id = ?";
	boardStmt = conn.prepareStatement(boardSql);
	boardStmt.setString(1, memberId);
		System.out.println(boardStmt + "<--게시글 수정 localStmt");
		
	boardRs = boardStmt.executeQuery(); 
	Board board = new Board();
	ArrayList<Board> boardList= new ArrayList<Board>();
	if(boardRs.next()){//있을때만 생성
		board = new Board();
		board.setMemberId(boardRs.getString("memberId"));
	}
	
	//지역 선택을 위한 쿼리 
	PreparedStatement localStmt = null;
	ResultSet localRs = null;
	String localsql = "SELECT local_name localName FROM local";
	localStmt = conn.prepareStatement(localsql);
		System.out.println(localStmt + "<--게시글 입력에서 지역 localStmt");
		
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

	<h1>게시물 추가</h1>
<hr>
	<%
		if(request.getParameter("msg") != null) {
	%>
		<div style="font-size: 20px; color: #F15F5F; text-align: center;"><%=request.getParameter("msg")%></div><br>
	<%
		}
	%>
	<form action="<%=request.getContextPath()%>/board/insertBoardAction.jsp">
		<table class="table table-bordered" style="text-align: center; vertical-align: middle;">			
			<tr>
				<td class="table-warning">작성자</td>
				<td><input type="text" name="memberId" readonly="readonly" value="<%=board.getMemberId()%>" class="form-control form-control-sm"></td>
			</tr>
			<tr>
				<td class="table-warning">지역</td>
				<td>
				<select name="insertLocal" class="form-select form-select-sm">
				<%//option만 반복
					for(Local l : localList) {
				%>
					<option><%=l.getLocalName()%></option>
				<%
					}
				%>
				</select>
				</td>
			</tr>
			<tr>
				<td class="table-warning">제목</td>
				<td><input type="text" name="insertTitle" class="form-control form-control-sm"></td>
			</tr>
			<tr >
				<td class="table-warning">내용</td>
				<td><textarea cols="80" rows="2" name="insertContext" class="form-control form-control-sm"></textarea></td>
			</tr>
		</table>
		<a href="<%=request.getContextPath()%>/home.jsp" class="btn btn-sm btn-outline-dark">취소</a>
		<button type="submit" class="btn btn-sm btn-outline-dark">게시글 추가</button>
	</form>
</div>
<div>
	<!-- include 페이지 : Copyright &copy; 신정음 -->
	<jsp:include page="/inc/copyright.jsp"></jsp:include>
</div>
</body>
</html>