<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import = "vo.*" %>
<!-- Latest compiled and minified CSS -->
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/css/bootstrap.min.css" rel="stylesheet">

<!-- Latest compiled JavaScript -->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/js/bootstrap.bundle.min.js"></script>

	<%
		if(session.getAttribute("loginMemberId") == null) { // 로그인전
	%>
	<div style="position: pixed; text-align: center;">
		<a href="<%=request.getContextPath()%>/home.jsp" style="border: 10px solid #FAECC5; 
			background:#FAECC5; display: block; text-decoration: none; color: #4C4C4C; font-size: 55px; ">
		HOME
			<h6>2023.05.02~2023.05.15 
			<br>Java17, HTML, CSS, MariaDB
			<br>----------------------------
			<br>로그인, 로그아웃, 회원가입, 회원정보 수정 
			<br>게시글 댓글 카테고리 각 항목에 삽입, 삭제, 수정 기능 구현  
			<br>게시글 목록 1~10 이동 기능을 포함한 페이징
			</h6>
		</a>
		
	<br>
</div>	
	<%		
		} else { // 로그인후
	%>
<br>
<div style="position: pixed; text-align: center;">
	<a href="<%=request.getContextPath()%>/home.jsp" style="border: 0px solid #FAECC5; 
		background:#FAECC5; display: block; text-decoration: none; font-size: 55px">
	<img src="<%=request.getContextPath()%>/img/bg.jpg" height="200px">
	</a>
<br>
</div>
	<%		
		}
	%>