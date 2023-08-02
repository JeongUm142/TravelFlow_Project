<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import = "vo.*" %>
<!-- Latest compiled and minified CSS -->
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/css/bootstrap.min.css" rel="stylesheet">

<!-- Latest compiled JavaScript -->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/js/bootstrap.bundle.min.js"></script>

	<%
		if(session.getAttribute("loginMemberId") == null) { // 로그인전
	%>
	<br>
	<div style="position: pixed; text-align: center;">
		<a href="<%=request.getContextPath()%>/home.jsp" style="background:#FAECC5; display: block; text-decoration: none; color: #4C4C4C; font-size: 55px; height: 204px; width: 2000px'">
		TRAVEL FLOW
			<h6>2023.05.02~2023.05.15 
			<br>Java17, HTML, CSS, MariaDB
			<br>----------------------------
			<br>test 계정 
			<br>ID : test
			<br>PW : 1234
			</h6>
		</a>
		
	<br>
</div>	
	<%		
		} else { // 로그인후
	%>
<br>
<div style="position: pixed; text-align: center;">
	<a href="<%=request.getContextPath()%>/home.jsp" style=" display: block; text-decoration: none;">
	<img src="<%=request.getContextPath()%>/img/bgB.png" height="204px" width="100%">
	</a>
<br>
</div>
	<%		
		}
	%>