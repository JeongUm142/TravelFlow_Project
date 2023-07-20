<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import = "java.sql.*"%>
<%@ page import = "java.util.*"%>
<%@ page import = "vo.*"%>
<%
	//인코딩
	request.setCharacterEncoding("utf8");

	//1. 컨트롤로 계층
	//유효성 검사 
	if(request.getParameter("boardNo") == null) {
		response.sendRedirect(request.getContextPath()+"/home.jsp");
		return;
	}
	int boardNo = Integer.parseInt(request.getParameter("boardNo"));
	
	//페이징
	int currentPage = 1;
	if(request.getParameter("currentPage")!=null){
		currentPage = Integer.parseInt(request.getParameter("currentPage"));
	}
	int rowPerPage = 5;
	int startRow = (currentPage-1)*rowPerPage;
	int totalRow = 0;

	//2. 모델 계층
	//드라이브 로딩 및 쿼리실행
	String driver = "org.mariadb.jdbc.Driver";
	String dburl = "jdbc:mariadb://127.0.0.1:3306/userboard";
	String dbuser = "root";
	String dbpw = "java1234";
	Class.forName(driver);
	Connection conn = null;
	conn = DriverManager.getConnection(dburl, dbuser, dbpw);
	
	//2-1) board one 결과셋
	/*
		SELECT board_no boardNo, local_name localName, board_title boardTitle, board_content boardContent, member_id memberId, createdate, updatedate 
		FROM board 
		WHERE board_no =?
	*/
	PreparedStatement boardstmt = null;
	ResultSet boardRs = null;
	String boardSql = "SELECT board_no boardNo, local_name localName, board_title boardTitle, board_content boardContent, member_id memberId, createdate, updatedate FROM board WHERE board_no = ?";
	boardstmt = conn.prepareStatement(boardSql);
	boardstmt.setInt(1, boardNo);
	boardRs = boardstmt.executeQuery(); // row -> 1 -> board
	Board board = null;
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
	//2-2) boardList 결과셋
	/* 	
		SELECT comment_no, board_no, comment_content 
		FROM COMMENT 
		WHERE board_no = ? 
		LIMIT = ?, ?";
 	*/	
 	PreparedStatement commentListStmt = null;
 	ResultSet commentListRs = null;
	String commentListSql = "SELECT comment_no commentNo, board_no boardNo, comment_content commentContent, member_id memberId, createdate, updatedate FROM COMMENT WHERE board_no = ? ORDER BY createdate DESC LIMIT ?,?";
	commentListStmt = conn.prepareStatement(commentListSql);
	commentListStmt.setInt(1, boardNo);
	commentListStmt.setInt(2, startRow);
	commentListStmt.setInt(3, rowPerPage);
	commentListRs = commentListStmt.executeQuery(); //row -> 최대 10개 ->arrayList
		
	ArrayList<Comment> commentList = new ArrayList<Comment>();
	while(commentListRs.next()) { //누구를 반복할건가
		Comment c = new Comment();
		c.setCommentNo(commentListRs.getInt("commentNo"));
		c.setCommentContent(commentListRs.getString("commentContent"));
		c.setMemberId(commentListRs.getString("memberId"));
		c.setCreatedate(commentListRs.getString("createdate"));
		c.setUpdatedate(commentListRs.getString("updatedate"));
		commentList.add(c);
	}
	
	//페이지의 전체 행 구하는 쿼리문
		String totalRowSql = null;
		PreparedStatement totalStmt = null;
		ResultSet totalRs = null;
		totalRowSql = "SELECT count(*) FROM comment WHERE board_no=?";
		totalStmt = conn.prepareStatement(totalRowSql);
		totalStmt.setInt(1, boardNo);
		totalRs = totalStmt.executeQuery();
			//디버깅
			System.out.println("totalStmt-->"+totalStmt);
			System.out.println("totalRs-->"+totalRs);
			
		//전체 페이지수
		if(totalRs.next()){
			totalRow=totalRs.getInt("count(*)");
		}
		int lastPage = totalRow/rowPerPage;
		
		//마지막 페이지가 나머지가 0이 아니면 페이지수 1추가
		if(totalRow%rowPerPage!=0){
			lastPage++;
		}
	//3. 뷰 계층
%>
<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
	<title>UserBoard</title>
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

	<h1>게시물 상세 정보</h1>
<hr>
	<!-- 3-1) board one 결과셋 -->
	<table class="table table-bordered">
		<tr>
			<td style="width: 100px" class="table-warning">지역</td>
			<td><%=board.getLocalName()%></td>
		</tr>
		
		<tr>
			<td class="table-warning">제목</td>
			<td><%=board.getBoardTitle()%></td>
		</tr>
		
		<tr>
			<td class="table-warning">내용</td>
			<td><%=board.getBoardContent()%></td>
		</tr>
		
		<tr>
			<td class="table-warning">작성자</td>
			<td><%=board.getMemberId()%></td>

		<tr>
			<td class="table-warning">작성일</td>
			<td><%=board.getCreatedate()%></td>
		</tr>
		
		<tr>
			<td class="table-warning">수정일</td>
			<td><%=board.getUpdatedate()%></td>
		</tr>
	</table>
	
	<!-- 3-2) comment 입력 : 세션유무에 따른 분기 -->
 	<%	//로그인 사용자만 댓글 입력허용
         if(session.getAttribute("loginMemberId") != null) { //원래는 멤버객체가 들어가서 아이디만 뽑아야함
        	 //현재 로그인 사용자의 아이디
        	 String loginMemberId = (String)session.getAttribute("loginMemberId");
        	if(loginMemberId.equals(board.getMemberId())) {
 	%>
 	<div>
		<a href="<%=request.getContextPath()%>/board/updateBoardForm.jsp?boardNo=<%=boardNo%>" class="btn btn-sm btn-outline-dark">수정</a>
		<a href="<%=request.getContextPath()%>/board/deleteBoardForm.jsp?boardNo=<%=boardNo%>" class="btn btn-sm btn-outline-dark">삭제</a>
	</div>
	<%
        	}//로그인한 사람과 게시글 작성자가 동일할 경우 수정가능 if 닫기
	%>
	<!-- 끝 board one 결과셋 --------------------------------->
 <br>
 	<h4>댓글</h4>
	<form action="<%=request.getContextPath()%>/board/insertCommentAction.jsp?boardNo=<%=boardNo%>" method="post">		
		<input type="hidden" name="boardNo" value="<%=board.getBoardNo()%>">
		<input type="hidden" name="memberId" value="<%=loginMemberId%>"> <!-- 현재로그인한 사람의 아이디 -->
		<div style="vertical-align: middle; display: flex">
		<textarea rows="2" cols="200" name="commentContent" style="width: 90%;"></textarea>
		<button type="submit" class="btn btn-sm btn-light text-dark" style="width: 10%; border-left:none;" >댓글 등록</button>	
		</div>
		<br>
	</form>
 	<!-- 끝 comment 입력 : 세션유무에 따른 분기 --------------------------------->
<%	
		
	}//로그인여부에 따른 if 닫기
%> 	
 	<!-- 3-3) comment list 결과셋 -->
	<table class="table"  style="vertical-align: middle;">
 		<tr class="table-warning">
 			<th>댓글</th>
 			<th>작성자</th>
 			<th>작성일</th>
 			<th>수정일</th>
 			<th colspan="2"></th>
 		</tr>
 		
 		<%
		for(Comment c : commentList) {
		%>
		<tr>
			<td style="width: 46%"><%=c.getCommentContent()%></td>
			<td><%=c.getMemberId()%></td>
			<td style="width: 10%"><%=c.getCreatedate()%></td>
			<td style="width: 10%"><%=c.getUpdatedate()%></td>
			<%	//로그인 사용자만 댓글 입력허용
         if(session.getAttribute("loginMemberId") != null) {
        	 //현재 로그인 사용자의 아이디
        	 String loginMemberId = (String)session.getAttribute("loginMemberId");
        		if(loginMemberId.equals(c.getMemberId())) {
 			%>
			<td style="width: 7%">
				<a href="<%=request.getContextPath()%>/board/updateCommentForm.jsp?commentNo=<%=c.getCommentNo()%>"class="btn btn-sm btn-outline-dark">수정</a>
			</td>
			<td style="width: 7%">
				<a href="<%=request.getContextPath()%>/board/deleteCommentForm.jsp?commentNo=<%=c.getCommentNo()%>"class="btn btn-sm btn-outline-dark">삭제</a>
			</td>
		</tr>
		<%
        	 		}//로그인한 사람과 댓글 작성자가 동일할 경우 수정가능 if 닫기
				} //로그인 사용자만 댓글 입력허용 닫기
			}
		%>
 	</table>
		
<div style="text-align: center;">
	<%
		if(currentPage>1){
	%>
	<a href="<%=request.getContextPath()%>/board/boardOne.jsp?boardNo=<%=boardNo%>&currentPage=<%=currentPage - 1%>" class="btn btn-sm btn-warning">이전
	</a>
	<%
		}
	%>
		&nbsp;<%=currentPage%>&nbsp;
	<%
		if(currentPage<lastPage){
	%>
	<a href="<%=request.getContextPath()%>/board/boardOne.jsp?boardNo=<%=boardNo%>&currentPage=<%=currentPage + 1%>" class="btn btn-sm btn-warning">다음
	</a>
	<%
		}
	%>
</div>
</div>
</body>
</html>