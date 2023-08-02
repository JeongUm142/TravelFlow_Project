<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import = "java.sql.*"%>
<%@ page import = "java.net.*"%>
<%@ page import = "vo.*"%>
<%
	//메시지
	String msg = "";

	//인코딩 설정
	request.setCharacterEncoding("utf-8");
	
	//세션 유효성 검사
	if(session.getAttribute("loginMemberId")==null){
		response.sendRedirect(request.getContextPath()+"/home.jsp");
		return;
	}

	//유효성 검사
	if(request.getParameter("insertLocal")==null 
		||request.getParameter("insertTitle")==null
		||request.getParameter("insertContext")==null
		||request.getParameter("insertLocal").equals("")
		||request.getParameter("insertTitle").equals("")
		||request.getParameter("insertContext").equals("")) {
	msg = URLEncoder.encode("내용을 모두 입력해주세요","utf-8");
	response.sendRedirect(request.getContextPath()+"/board/insertBoardForm.jsp?msg=" + msg);
	return;
	}
	
	String memberId = request.getParameter("memberId");
	String insertLocal = request.getParameter("insertLocal");
	String insertTitle = request.getParameter("insertTitle");
	String insertContext = request.getParameter("insertContext");
		System.out.println(memberId + "<- 게시글추가 memberId");
		System.out.println(insertLocal + "<- 게시글추가 insertLocal");
		System.out.println(insertTitle + "<- 게시글추가 insertTitle");
		System.out.println(insertContext + "<- 게시글추가 insertContext");
		
	
	//쿼리실행
	String driver = "org.mariadb.jdbc.Driver";
	String dburl = "jdbc:mariadb://127.0.0.1:3306/userboard";
	String dbuser = "root";
	String dbpw = "java1234";
	Class.forName(driver);
	Connection conn = null;
	
	conn = DriverManager.getConnection(dburl, dbuser, dbpw);
	
	/*
		INSERT INTO board(local_name, board_title, board_content, createdate, updatedate) VALUES(?, ?, ?, now(), now())";
 	*/
 	PreparedStatement boardNewStmt = null;
 	ResultSet boardNewRs = null;
	String boardNewsql = "INSERT INTO board(member_id, local_name, board_title, board_content, createdate, updatedate) VALUES(?, ?, ?, ?, now(), now())";
	boardNewStmt = conn.prepareStatement(boardNewsql);
	boardNewStmt.setString(1, memberId);
	boardNewStmt.setString(2, insertLocal);
	boardNewStmt.setString(3, insertTitle);
	boardNewStmt.setString(4, insertContext);
		System.out.println(boardNewStmt + "<--게시글 추가 boardNewStmt");
	//같은 값을 두 번 넣지 않기 위해서 1번 쿼리에는 결과값 xXX 
		
	//게시물 제목 중복
	PreparedStatement boardNewStmt2 = null;
 	ResultSet boardNewRs2 = null;
	String sql2 = "SELECT board_title boardTitle from board where board_title = ?";
	boardNewStmt2 = conn.prepareStatement(sql2);
	boardNewStmt2.setString(1, insertTitle);
		System.out.println( boardNewStmt2 + " <-- 게시글 제목 중복 여부 확인 boardNewStmt2");
	boardNewRs2 = boardNewStmt2.executeQuery();	
	
	//중복된 게시글 제목이 있는경우
	if(boardNewRs2.next()){ 
		msg = URLEncoder.encode("이미 존재하는 게시글입니다.", "utf-8");
		response.sendRedirect(request.getContextPath()+"/board/insertBoardForm.jsp?msg="+msg);
		return;
	}
	
	int row = boardNewStmt.executeUpdate();
	
	if(row==1){//성공 
		System.out.println(row + "<--게시글 등록 성공");
		response.sendRedirect(request.getContextPath()+"/home.jsp");
		
	} else {//실패
		System.out.println(row + "<--게시글 등록 실패");
		response.sendRedirect(request.getContextPath()+"/board/insertBoardForm.jsp");
		return;
	}
	
%>