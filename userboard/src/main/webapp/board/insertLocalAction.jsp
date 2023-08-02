<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import = "java.sql.*"%>
<%@ page import = "java.net.*"%>
<%@ page import = "vo.*" %>
<%
	//인코딩 설정
	request.setCharacterEncoding("utf-8");

	//1.세션 유효성검사 
	if(session.getAttribute("loginMemberId") == null) {
		response.sendRedirect(request.getContextPath()+"/home.jsp");
		return;
	}
	
	//메시지
	String msg = "";
	
	//2.요청값 유효성검사
	if(request.getParameter("localName")==null ||
		request.getParameter("localName").equals("")){
		msg = URLEncoder.encode("지역명을 입력해주세요.", "utf-8");
		response.sendRedirect(request.getContextPath()+"/board/insertLocalForm.jsp?msg=" + msg);
		return;
		}

	String localName = request.getParameter("localName");
		//디버깅
		System.out.println(localName + "<- 지역추가 localName");
	
	//드라이브
	String driver = "org.mariadb.jdbc.Driver";
	String dburl = "jdbc:mariadb://127.0.0.1:3306/userboard";
	String dbuser = "root";
	String dbpw = "java1234";
	Class.forName(driver);
	Connection conn = null;
	
	conn = DriverManager.getConnection(dburl, dbuser, dbpw);
	
	/*
		INSERT INTO local(local_name, createdate, updatedate) VALUES(?, now(), now())"
 	*/
 	PreparedStatement localStmt = null;
	
	String localsql = "INSERT INTO local(local_name, createdate, updatedate) VALUES(?, now(), now())";
	localStmt = conn.prepareStatement(localsql);
	localStmt.setString(1, localName);
		System.out.println(localStmt + "<--지역 추가 localStmt");
		
	//지역 중복확인 
	PreparedStatement localstmt2 = null;
	ResultSet localRs = null;

	String localsql2 = "SELECT local_name localName from local where local_name = ?";
	localstmt2 = conn.prepareStatement(localsql2);
	localstmt2.setString(1, localName);
	System.out.println( localstmt2 + " <--지역 추가 stmt2");
	localRs = localstmt2.executeQuery();	
	
	//중복된 지역이 있는경우
	if(localRs.next()){ 
		msg = URLEncoder.encode("이미 존재하는 지역입니다.", "utf-8");
		response.sendRedirect(request.getContextPath()+"/board/insertLocalForm.jsp?msg="+msg);
		return;
	}

	int row = localStmt.executeUpdate();
	
	if(row==1){//성공 
		System.out.println(row + "<--지역등록 성공");
		response.sendRedirect(request.getContextPath()+"/board/category.jsp");
		
	} else {//실패
		System.out.println(row + "<--지역등록 실패");
		response.sendRedirect(request.getContextPath()+"/board/insertLocalForm.jsp");
		return;
	}
	
%>