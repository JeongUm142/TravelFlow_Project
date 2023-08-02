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
	String localName = request.getParameter("localName");

	//드라이브
	String driver = "org.mariadb.jdbc.Driver";
	String dburl = "jdbc:mariadb://127.0.0.1:3306/userboard";
	String dbuser = "root";
	String dbpw = "java1234";
	Class.forName(driver);
	Connection conn = null;
	conn = DriverManager.getConnection(dburl, dbuser, dbpw);
	
	/*
		"SELECT local_name localName, createdate, updatedate FROM local"
	*/
	PreparedStatement localstmt = null;
	ResultSet localRs = null;
	String localSql = "SELECT local_name localName, createdate, updatedate FROM local";
	localstmt = conn.prepareStatement(localSql);
		System.out.println(localstmt + "<-카테고리 localstmt");
		
	localRs = localstmt.executeQuery(); 
	
	ArrayList<Local> localList = new ArrayList<Local>();
	while(localRs.next()){//있을때만 생성
		Local l = new Local();
		l.setLocalName(localRs.getString("localName"));
		l.setCreatedate(localRs.getString("createdate"));
		l.setUpdatedate(localRs.getString("updatedate"));
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
<div class="container" style="text-align: center;">
<!-- home으로 갈 이미지 -->
	<div>
      <jsp:include page="/inc/mainmenu2.jsp"></jsp:include>
	</div>
<!-- 메인메뉴(가로) -->
	<div><!-- 서버기술이기 때문에 ﹤% request...%﹥를 쓸 필요가 없음 -->
      <jsp:include page="/inc/mainmenu.jsp"></jsp:include>
	</div>
	<h1 style="text-align: left;">카테고리 관리</h1>
<hr>
	<div style ="text-align: right;">
	<a href="<%=request.getContextPath()%>/board/insertLocalForm.jsp" class="btn btn-sm btn-outline-dark"> 카테고리 추가 </a>
	<a href="<%=request.getContextPath()%>/board/updateLocalForm.jsp" class="btn btn-sm btn-outline-dark"> 카테고리명 수정</a>
	<a href="<%=request.getContextPath()%>/board/deleteLocalForm.jsp" class="btn btn-sm btn-outline-dark"> 카테고리 삭제</a>
	</div>
<br>
	<table class="table table-bordered" style="text-align: center; vertical-align: middle;">
		<tr class="table-warning">
			<td style="text-align: center; width: 50%">지역</td>
			<td>등록일</td>
			<td>수정일</td>
		</tr>
		<%
			for(Local l : localList) {
		%>
		<tr>
			<td>
				<%=l.getLocalName()%>
			</td>
			<td>
				<%=l.getCreatedate()%>
			</td>
			<td>
				<%=l.getUpdatedate()%>
			</td>
		</tr>
		<%
			}
		%>
	</table>
</div>
<div>
	<!-- include 페이지 : Copyright &copy; 신정음 -->
	<jsp:include page="/inc/copyright.jsp"></jsp:include>
</div>
</body>
</html>