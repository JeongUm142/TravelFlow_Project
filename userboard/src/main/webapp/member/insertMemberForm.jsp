<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
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
<div class="container" style="text-align: center;">
	<!-- home으로 갈 이미지 -->
<div>
      <jsp:include page="/inc/mainmenu2.jsp"></jsp:include>
</div>
	
<br>
	<h1>회원가입</h1>
<hr>
		<%
			if(request.getParameter("msg") != null) {
		%>
			<div style="font-size: 20px; color: #F15F5F"><%=request.getParameter("msg")%></div>
			<br>
		<%
			}
		%>
	<form action="<%=request.getContextPath()%>/member/insertMemberAction.jsp" method="post">
		<table class="table table-bordered">
			<tr>
				<td class="table-warning">아이디 </td>
				<td><input type="text" name="memberId" class="form-control form-control-sm" ></td>
			</tr>
			<tr>
				<td class="table-warning">비밀번호 </td>
				<td><input type="password" name="memberPw" class="form-control form-control-sm" ></td>
			</tr>
			<tr>
				<td class="table-warning">비밀번호 확인</td>
				<td><input type="password" name="memberPwRe" class="form-control form-control-sm" ></td>
			</tr>
		</table>
		<br>
		<button type="submit" class="btn btn-sm btn-outline-dark">회원가입</button>
	</form>
</div>
</body>
</html>