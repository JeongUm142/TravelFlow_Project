<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import = "java.sql.*"%>
<%@ page import = "java.util.*"%>
<%@ page import = "vo.*"%>
<%
	String driver = "org.mariadb.jdbc.Driver";
	String dburl = "jdbc:mariadb://127.0.0.1:3306/userboard";
	String dbuser = "root";
	String dbpw = "java1234";
	Class.forName(driver);
	Connection conn = null;
	conn = DriverManager.getConnection(dburl, dbuser, dbpw);
	
	/*
		"SELECT local_name localName FROM local"
	*/
	PreparedStatement localStmt = null;
	ResultSet localRs = null;
	String localsql = "SELECT local_name localName FROM local";
	localStmt = conn.prepareStatement(localsql);
		System.out.println(localStmt + "<--지역 삭제폼 localStmt");
		
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
<title>UserBoard</title>
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
<br>
	<h1>지역 삭제</h1>
<hr>
	<%
		if(request.getParameter("msg") != null) {
	%>
		<div style="font-size: 20px; color: #F15F5F"><%=request.getParameter("msg")%></div>
	<%
		}
	%>
		
<form action="<%=request.getContextPath()%>/board/deleteLocalAction.jsp" method="post" >
	<table class="table table-bordered" style="text-align: center; vertical-align: middle;">
		<tr>
			<td class="table-warning">삭제할 지역 선택</td>
			<td>
			<select name="localName" class="form-select" style="text-align: center;" >
		<%
			for(Local l : localList) {
		%>
				<option value="<%=l.getLocalName()%>"><%=l.getLocalName()%></option>
		<%
			}
		%>
			</select>
			</td>
		</tr>
		<tr>
			<td class="table-warning">지역명 확인</td>
			<td>
				<input type="text" name="localNameRe" class="form-control form-control-sm">
			</td>
		</tr>
	</table>
		<button type="submit" class="btn btn-sm btn-outline-dark">삭제</button>
	</form>
</div>
</body>
</html>