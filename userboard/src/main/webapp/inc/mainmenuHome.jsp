<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import = "vo.*" %>
<!-- Latest compiled and minified CSS -->
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/css/bootstrap.min.css" rel="stylesheet">

<!-- Latest compiled JavaScript -->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/js/bootstrap.bundle.min.js"></script>


	<!-- 
		로그인전 - 회원가입	
		로그인후 - 회원정보(~님 반갑습니다)/ 로그아웃 (로그인정보 세션 loginMemberId)
	-->
	<%
		if(session.getAttribute("loginMemberId") == null) { // 로그인전
	%>
			<a href="<%=request.getContextPath()%>/member/insertMemberForm.jsp" class="btn btn-sm btn-outline-dark">회원가입</a>
	<%		
		} else { // 로그인후
	%>
	<div style="text-align: center; line-height:50%">

			<a href="<%=request.getContextPath()%>/member/memberInfo.jsp" class="btn btn-sm btn-outline-warning text-muted">나의 정보</a>
			<a href="<%=request.getContextPath()%>/board/insertBoardForm.jsp" class="btn btn-sm btn-outline-warning text-muted">글쓰기</a>

			&nbsp;
			<br>
			<br>

			<%
		if(session.getAttribute("loginMemberId") != null 
			&& session.getAttribute("loginMemberId").equals("admin")
			|| session.getAttribute("loginMemberId").equals("test")) { // 관리자
	%>
			<a href="<%=request.getContextPath()%>/board/category.jsp" class="btn btn-sm btn-outline-warning text-muted">카테고리 관리</a>
	<%		
		}
	%>
			<a href="<%=request.getContextPath()%>/member/logoutAction.jsp" class="btn btn-sm btn-outline-warning text-muted">로그아웃</a>	

</div>
	<%				
		}
	%>




			