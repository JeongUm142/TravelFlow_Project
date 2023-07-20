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
<!-- 메인메뉴(가로) -->
	<div><!-- 서버기술이기 때문에 ﹤% request...%﹥를 쓸 필요가 없음 -->
		<jsp:include page="/inc/mainmenu.jsp"></jsp:include>
	</div>
<br>
	<h1>카테고리 추가</h1>
<hr>
		<%
			if(request.getParameter("msg") != null) {
		%>
			<div style="font-size: 20px; color: #F15F5F"><%=request.getParameter("msg")%></div>
		<%
			}
		%>
	<form action="<%=request.getContextPath()%>/board/insertLocalAction.jsp" method="post">
		<table class="table table-bordered" style="text-align: center; vertical-align: middle;">
			<tr>
				<td class="table-warning">지역</td>
				<td>
					<input type="text" name="localName" class="form-control form-control-sm">
				</td>
			</tr>
		</table>
		<br>
		<a href="<%=request.getContextPath()%>/board/category.jsp" class="btn btn-sm btn-outline-dark">취소</a>
		<button type="submit" class="btn btn-sm btn-outline-dark">지역 추가</button>
	</form>
</div>
</body>
</html>