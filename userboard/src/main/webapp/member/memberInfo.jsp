<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import = "java.sql.*"%>
<%@ page import = "java.net.*"%>
<%@ page import = "vo.*" %>
<%
	//세션 유효성 검사
	if(session.getAttribute("loginMemberId") == null) {
	   response.sendRedirect(request.getContextPath()+"/home.jsp");
	   return;
	} 
	//id값 받기 
	String memberId = (String)session.getAttribute("loginMemberId");
	
	//2. 모델 계층
		//드라이브 로딩 및 쿼리실행
		String driver = "org.mariadb.jdbc.Driver";
		String dburl = "jdbc:mariadb://127.0.0.1:3306/userboard";
		String dbuser = "root";
		String dbpw = "java1234";
		Class.forName(driver);
		Connection conn = null;
		conn = DriverManager.getConnection(dburl, dbuser, dbpw);
		
	/*
		SELECT member_id memberId, createdate, updatedate 
		FROM member
		WHERE member_id =?
	*/
	PreparedStatement stmt = null;
	ResultSet rs = null;
	String boardSql = "SELECT member_id memberId, createdate, updatedate FROM member WHERE member_id =?";
	stmt = conn.prepareStatement(boardSql);
	stmt.setString(1, memberId);
	rs = stmt.executeQuery(); // row -> 1 -> board
	
	Member member = null;
	if(rs.next()){//있을때만 생성
		member = new Member();
		member.setMemberId(rs.getString("memberId"));
		member.setCreatedate(rs.getString("createdate"));
		member.setUpdatedate(rs.getString("updatedate"));
	}
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
	<!-- Latest compiled and minified CSS -->
	<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/css/bootstrap.min.css" rel="stylesheet">
	
	<!-- Latest compiled JavaScript -->
	<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/js/bootstrap.bundle.min.js"></script>
</head>
<body>
<div class="container" style="text-align: center;">
<!-- home으로 갈 이미지 -->
	<div>
	      <jsp:include page="/inc/mainmenu2.jsp"></jsp:include>
	</div>
<!-- 메인메뉴(가로) -->
	<div><!-- 서버기술이기 때문에 ﹤% request...%﹥를 쓸 필요가 없음 -->
		<jsp:include page="/inc/mainmenu.jsp"></jsp:include>
	</div>
	<h1 style="text-align: left;">회원정보</h1>
<hr>
	<table class="table table-bordered">
		<tr>
			<td class="table-warning">아이디</td>
			<td><%=member.getMemberId()%></td>
		</tr>
		<tr>
			<td class="table-warning">가입일자</td>
			<td><%=member.getCreatedate()%></td>
		</tr>
	</table>
<br>
	<a href="<%=request.getContextPath()%>/member/updatePwForm.jsp" class="btn btn-sm btn-outline-dark">비밀번호 변경</a>
	&nbsp;&nbsp;&nbsp;
	<a href="<%=request.getContextPath()%>/member/deleteMemberForm.jsp" class="btn btn-sm btn-outline-dark">회원탈퇴</a>
</div>
</body>
</html>