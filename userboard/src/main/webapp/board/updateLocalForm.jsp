<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import = "java.sql.*"%>
<%@ page import = "java.util.*"%> <!-- arraylist -->
<%@ page import = "vo.*" %>
<%
	//세션 유효성 검사
	if(session.getAttribute("loginMemberId") == null) {
	   response.sendRedirect(request.getContextPath()+"/home.jsp");
	   return;
	} 
	//id값 받기 
	String memberId = (String)session.getAttribute("loginMemberId");	
	
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
	PreparedStatement localUpStmt = null;
	ResultSet localUpRs = null;
	String localUpsql = "SELECT local_name localName FROM local";
	localUpStmt = conn.prepareStatement(localUpsql);
		System.out.println(localUpStmt + "<--지역 수정 localStmt");
		
	localUpRs = localUpStmt.executeQuery(); 
	
	ArrayList<Local> localList = new ArrayList<Local>();
	while(localUpRs.next()){
		Local l = new Local();
		l.setLocalName(localUpRs.getString("localName"));
		localList.add(l);
	}
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>카테고리 수정</title>
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
	<h1>카테고리 수정</h1>
<hr>
	<%
		if(request.getParameter("msg") != null) {
	%>
		<div style="font-size: 20px; color: #F15F5F"><%=request.getParameter("msg")%></div>
	<%
		}
	%>
<br>
	<form action="<%=request.getContextPath()%>/board/updateLocalAction.jsp" method="post">
	<table class="table table-bordered" style="text-align: center; vertical-align: middle;">
		<tr>
			<td class="table-warning">현재 카테고리명 입력</td>
			<td>
			<select name="beforelocalName" class="form-select form-select-sm" style="text-align: center;" >
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
			<td class="table-warning">새 카테고리명 입력</td>
			<td><input type="text" name="newLocal" class="form-control form-control-sm"></td>
		</tr>
		<tr>
			<td class="table-warning">새 카테고리명 재입력</td>
			<td><input type="text" name="newLocalRe" class="form-control form-control-sm"></td>
		</tr>
	</table>
		<a href="<%=request.getContextPath()%>/board/category.jsp" class="btn btn-sm btn-outline-dark">취소</a>
		<button type="submit" class="btn btn-sm btn-outline-dark">카테고리명 변경</button>
	</form>
</div>
</body>
</html>