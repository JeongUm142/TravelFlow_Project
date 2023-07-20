<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import = "java.sql.*"%>
<%@ page import = "java.util.*"%>
<%@ page import = "vo.*"%>
<% 
	//1. 요청분석(컨트롤러 계층)

		//1) session JSP내장(기본)객체
		//2) request / response JSP객체 (기본) 객체
	//페이징
	int currentPage = 1;
	if(request.getParameter("currentPage")!=null){
		currentPage = Integer.parseInt(request.getParameter("currentPage"));
	}
	int rowPerPage = 10;
	int startRow = (currentPage-1)*rowPerPage;// 현재 1 => (1-1) * 10 = 0, 현재 2 => (2-1)*10 =>10
	int totalRow = 0;
	
	int pageCount = 10; //한번에 출력될 페이징 버튼 수(1,2,3,4--)
	//1~10번을 눌러도 1~10페이지만 출력되도록 설정
	int startPage = ((currentPage - 1) / pageCount) * pageCount + 1; //페이징 버튼 시작 값
	int endPage = startPage + pageCount - 1; //페이징 버튼 종료 값	
	
	//드라이브 로딩 및 쿼리실행
	String driver = "org.mariadb.jdbc.Driver";
	String dburl = "jdbc:mariadb://127.0.0.1:3306/userboard";
	String dbuser = "root";
	String dbpw = "java1234";
	Class.forName(driver);
	Connection conn = null;
	conn = DriverManager.getConnection(dburl, dbuser, dbpw);
	
	//지역 목록
	/*
	SELECT '전체', COUNT(local_name) FROM board
	UNION ALL - 두개 다
	SELECT local_name, COUNT(local_name) FROM board GROUP BY local_name;
	*/
	PreparedStatement subMenuStmt = null; // 지역목록
	ResultSet subMenuRs = null; // 지역목록
	
	String subMenuSql="SELECT '전체' localName, COUNT(local_name) cnt FROM board UNION ALL SELECT local_name, COUNT(local_name) FROM board GROUP BY local_name";
	subMenuStmt = conn.prepareStatement(subMenuSql);
	subMenuRs = subMenuStmt.executeQuery();
	ArrayList<HashMap<String, Object>> subMenuList 
								= new ArrayList<HashMap<String, Object>>();
	while (subMenuRs.next()) {
		HashMap<String, Object> m = new HashMap<String, Object>();
		m.put("localName", subMenuRs.getString("localName")); // map.put(키이름, 값)
		m.put("cnt", subMenuRs.getInt("cnt"));
		subMenuList.add(m);
	}
	
	//2) 게시판 목록 결과셋(모델)
	/*
	SELECT board_no boardNo, local_name, board_title boardTitle, board_content boardContent 
	FROM board 
	WHERE local_name='?'; // lacalName != "전체 "
	*/
	
	String localName = "전체";//localName을 기본 "전체"로 두기
	if(request.getParameter("localName") != null){//null이 아닐경우 localName값을 가져오기
		localName = request.getParameter("localName");
	}
	
	PreparedStatement homeBoardStmt = null; //지역목록세부
	ResultSet homeBoardRs = null; //지역목록세부
	
	String homeBoardSql = ""; //null 대신 ""  null은 . equals가 불가함 
	if(localName.equals("전체")) {// where삭제
		homeBoardSql="SELECT board_no boardNo, local_name localName, board_title boardTitle, board_content boardContent, member_id memberId, createdate FROM board ORDER BY createdate DESC LIMIT ?, ?";
		homeBoardStmt = conn.prepareStatement(homeBoardSql);
			System.out.println(homeBoardStmt+"<--homeBoardStmt if");
		homeBoardStmt.setInt(1, startRow);
		homeBoardStmt.setInt(2, rowPerPage);

	} else {
		homeBoardSql="SELECT board_no boardNo, local_name localName, board_title boardTitle, board_content boardContent, member_id memberId, createdate FROM board WHERE local_name = ? ORDER BY createdate DESC LIMIT ?, ?";
		homeBoardStmt = conn.prepareStatement(homeBoardSql);
		homeBoardStmt.setString(1, localName);
		homeBoardStmt.setInt(2, startRow);
		homeBoardStmt.setInt(3, rowPerPage);
			System.out.println(homeBoardStmt+"<--homeBoardStmt else");
	}
	homeBoardRs = homeBoardStmt.executeQuery();
		System.out.println(homeBoardRs + "<--homeBoardRs DB쿼리 결과셋 모델");

	//ArrayList
	ArrayList<Board> homeBoardList = new ArrayList<Board>();// 애플케이션에서 사용할 모델 (사이즈 0)
	//broardRs --> boardList
	while(homeBoardRs.next()){
		Board b = new Board(); //while 밖에 있으면 안됨
		b.setBoardNo(homeBoardRs.getInt("boardNo"));
		b.setLocalName(homeBoardRs.getString("localName"));
		b.setBoardTitle(homeBoardRs.getString("boardTitle"));
		b.setBoardContent(homeBoardRs.getString("boardContent"));
		b.setCreatedate(homeBoardRs.getString("createdate"));
		b.setMemberId(homeBoardRs.getString("memberId"));

		homeBoardList.add(b);
	}
	 	System.out.println(homeBoardList);
	 	System.out.println(homeBoardList.size());
	
	 //페이지 설정 - 마지막 페이지
	//페이지의 전체 행 구하는 쿼리문
		String totalRowSql = null;
		PreparedStatement totalStmt = null;
		ResultSet totalRs = null;
		totalRowSql = "SELECT count(*) FROM board";
		totalStmt = conn.prepareStatement(totalRowSql);
		totalRs = totalStmt.executeQuery();
			//디버깅
			System.out.println("totalStmt-->"+totalStmt);
			System.out.println("totalRs-->"+totalRs);
			
		//전체 페이지수
		if(totalRs.next()){
			totalRow=totalRs.getInt("count(*)");
		}
		int lastPage = totalRow/rowPerPage;
		
		//마지막 페이지가 나머지가 0이 아니면 페이지수 1추가
		if(totalRow%rowPerPage!=0){
			lastPage++;
		}
		
		int totalPage = (int) Math.ceil(totalRow / (double) rowPerPage); //출력할 전체 페이지 수
		
		// 추가로 조건 설정
		if(currentPage > totalPage){
			currentPage = totalPage;
		}
		
		if(endPage > totalPage){
			endPage = totalPage;
		}
%>
<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
	<title>UserBoard</title>
	<!-- Latest compiled and minified CSS -->
	<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/css/bootstrap.min.css" rel="stylesheet">		
	<style>
	
	.page-item.active .page-link {
	 z-index: 1;
	 color: #555;
	 background-color: #FAECC5;
	 border-color: #ccc;
	 
	}
	.page-link:focus .page-link:hover {
	  color: #ccc;
	  background-color: pink; 
	  color: #555;
	  
	}
</style>
</head>
<body>
<div class="container-fluid" style="text-align: center;">
<div class="row">
	<!-- js include페이지 : Copyright &copy; 구디아카데미 -->
	<!-- 
	인클루드 - A,B를 같이 보여줌, 포워딩 - A에 B를 덮어쓰기 해서 B만 보여줌 ->>이를 하는 것을 RequestDispatcher라고 함
	request.getRequestDispatcher(request.getContextPath()+"/inc.copyright.jsp").include(request, response);
	위 코드를 액션태그로 변경 - 가독성을 위해서
	 -->
	
<div class="col-sm-2 container">
	<div style="margin-top: 50px; height:170px;">
	<!--메세지 -->
      <%
         if(session.getAttribute("loginMemberId") == null) { // 로그인전이면 로그인폼출력
      %>
      	<%
			if(request.getParameter("msg") != null) {
		%>
			<div style="font-size: 15px; color: #F15F5F"><%=request.getParameter("msg")%></div>				
		<%
         	}
		%>
		<!-- 로그인 폼 -->
		<div style="display: inline-block; text-align: center;">
            <form action="<%=request.getContextPath()%>/member/loginAction.jsp" method="post">
               <table>
				<tr>
                     <td>아이디</td>
                </tr>
      			<tr>
                     <td><input type="text" name="memberId" placeholder="Enter ID" class="form-control form-control-sm" style="width: 200px"></td>
				</tr>
				<tr>
                     <td>패스워드</td>
				</tr>
				<tr>
                     <td><input type="password" name="memberPw" placeholder="Enter PassWord" class="form-control form-control-sm"></td>
				</tr>
               </table>
               <br>
              <button type="submit" class="btn btn-sm btn-outline-dark">로그인</button>
              <jsp:include page="/inc/mainmenuHome.jsp"></jsp:include>
            </form>
		</div>
      <%   
         } else {
      %>
      		<h2 style="text-align: center;"><%=session.getAttribute("loginMemberId")%>님 <br> 반갑습니다.</h2>
      		<!-- 메인메뉴(가로) -->
			<!-- 서버기술이기 때문에 ﹤% request...%﹥를 쓸 필요가 없음 -->
      		<jsp:include page="/inc/mainmenuHome.jsp"></jsp:include>
      <%
         }
      %>    
   </div><!-- 로그인 끝-->
<div style="margin-top: 32px; text-align: center;">
<!-- 목록 -->
	<table class="table table-bordered">
		<%
			for(HashMap<String, Object> m : subMenuList){
		%>
			<tr class="table-warning">
			<td>
				<a href="<%=request.getContextPath()%>/home.jsp?localName=<%=(String)m.get("localName")%>" style="text-decoration: none; color: #1266FF">
					<%=(String)m.get("localName")%>(<%=(Integer)m.get("cnt")%>)
				</a>
			</td>
			</tr>
		<%
			}
		%>
	</table>
</div>
</div><!-- 목록 끝-->
<!--[시작]boardList---------------------------------------------------------->
	<div class="col-sm-10">
	
<!-- home으로 갈 이미지 -->
	<div>
      <jsp:include page="/inc/mainmenu2.jsp"></jsp:include>
	</div>
<!-- 카테고리별 게시글 5개씩 -->
	<table class="table table-bordered">
		<tr class="table-warning">
			<td style="width: 20%">지역</td>
			<td style="width: 30%">제목</td>
			<td>내용</td>
			<td>작성자</td>
			<td>작성일</td>
		</tr>
        <%
			for(Board b : homeBoardList){
		%>
			<tr>
			<td><%=b.getLocalName()%></td>
			<td>
				<a href="<%=request.getContextPath()%>/board/boardOne.jsp?boardNo=<%=b.getBoardNo()%>" style="text-decoration: none; color: #1266FF">
				<%=b.getBoardTitle()%></a></td>
			<td><%=b.getBoardContent().substring(0,7)%></td>
			<td><%=b.getMemberId()%></td>
			<td><%=b.getCreatedate().substring(0,10)%></td>
			</tr>
		<%
			}
		%>
	</table>
   </div>
   <!--[끝]boardList---------------------------------------------------------->
   </div>
   
   <div class="container mt-3">
	<ul class="pagination justify-content-center" style="margin:20px 0">
		<%
			//이전 페이지 버튼
			if(currentPage > pageCount){
		%>
	   			<li class="page-item">
	   				<a class="page-link text-dark" href="<%=request.getContextPath()%>/home.jsp?currentPage=<%=startPage-10 %>&localName=<%=localName%>">
	   					Previous
	   				</a>
	   			</li>
	   	<%
			}
	        for(int i = startPage; i <= endPage; i++){
	        	if(i==currentPage){
	    %>
	        		<li class="page-item active">
	        			<a class="page-link text-dark" href="<%=request.getContextPath()%>/home.jsp?currentPage=<%=i %>&localName=<%=localName%>">
	        				<%=i %>
	        			</a>
	        		</li>
	    <%
	        	}else{
	   	%>
	       		<li class="page-item">
	       			<a class="page-link text-dark" href="<%=request.getContextPath()%>/home.jsp?currentPage=<%=i %>&localName=<%=localName%>">
	       				<%=i %>
	       			</a>
	       		</li>
	       <%
	       		}
	        }
	    	//다음 페이지 버튼
	    	if(currentPage < (lastPage-pageCount+1)){
	       %>
			<li class="page-item">
				<a class="page-link text-dark" href="<%=request.getContextPath()%>/home.jsp?currentPage=<%=endPage+1 %>&localName=<%=localName%>">
					Next
				</a>
			</li>
		<%
			}
		%>
	</ul>
	</div>
	<div>
      <!-- include 페이지 : Copyright &copy; 구디아카데미 -->
      <jsp:include page="/inc/copyright.jsp"></jsp:include>
   </div>
</div>
</body>
</html>