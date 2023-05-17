<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import = "java.sql.*"%>
<%@ page import = "java.net.*"%>
<%@ page import = "vo.*" %>
<%
	//세션 유효성 검사
	if(session.getAttribute("loginMemberId") == null) {
	   response.sendRedirect(request.getContextPath()+"/member/memberInfo.jsp");
	   return;
	} 
	//id값 받기 
	String memberId = (String)session.getAttribute("loginMemberId");	
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>비밀번호 변경</title>
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
	<h1>비밀번호 변경</h1>
<hr>
      	<%
			if(request.getParameter("msg") != null) {
		%>
			<div style="font-size: 20px; color: #F15F5F"><%=request.getParameter("msg")%></div>
      	<%
			}
		%>
<br>
	<form action="<%=request.getContextPath()%>/member/updatePwAction.jsp" method="post">
	<table class="table table-bordered" style="vertical-align: middle;">
		<tr>
			<td class="table-warning">현재 비밀번호 입력</td>
			<td><input type="password" name="beforePw" class="form-control form-control-sm" ></td>
		</tr>
		<tr> 
			<td class="table-warning">새 비밀번호 입력</td>
			<td><input type="password" name="newPw" class="form-control form-control-sm" ></td>
		</tr>
		<tr>
			<td class="table-warning">새 비밀번호 재입력</td>
			<td><input type="password" name="newPwRe" class="form-control form-control-sm" ></td>
		</tr>
	</table>
		<a href="<%=request.getContextPath()%>/member/memberInfo.jsp" class="btn btn-sm btn-outline-dark">취소</a>
		<button type="submit" class="btn btn-sm btn-outline-dark">비밀번호 변경</button>
	</form>
</div>
</body>
</html>