<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import = "java.sql.*"%>
<%@ page import = "java.net.*"%>  <!-- 인코딩 -->
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
	if(request.getParameter("newLocal") == null ||
		request.getParameter("newLocal").equals("")){
		msg = URLEncoder.encode("수정할 카테고리명을 입력해주세요.","utf-8");
		response.sendRedirect(request.getContextPath()+"/board/updateLocalForm.jsp?msg=" + msg);
		return;
		}
	
	String beforelocalName = request.getParameter("beforelocalName");
	String newLocal = request.getParameter("newLocal");
	String newLocalRe = request.getParameter("newLocalRe");
	String localName = request.getParameter("localName");

		//디버깅
		System.out.println(beforelocalName + "<- 카테고리수정 액션 beforelocalName");
		System.out.println(newLocal + "<- 카테고리수정 액션 newLocal");
		System.out.println(newLocalRe + "<- 카테고리수정 액션 newLocalRe");
		System.out.println(localName + "<- 카테고리수정 액션 localName");

	// 지역명 일치 검사
	if(!newLocal.equals(newLocalRe)){//지역명 오류
		System.out.println("지역명 오류");
		msg = URLEncoder.encode("새 카테고리명 확인해주세요.","utf-8");
		response.sendRedirect("./updateLocalForm.jsp?msg="+msg);
		return;
	}
	
	String driver = "org.mariadb.jdbc.Driver";
	String dburl = "jdbc:mariadb://127.0.0.1:3306/userboard";
	String dbuser = "root";
	String dbpw = "java1234";
	Class.forName(driver);
	Connection conn = null;
	PreparedStatement stmt = null;
	ResultSet rs = null;
	conn = DriverManager.getConnection(dburl, dbuser, dbpw);
	
	/*
    UPDATE local SET local_name = ?
    WHERE local_name=?";
 	*/
	String sql = "UPDATE local SET local_name = ?, updatedate = now() WHERE local_name=?";
	stmt = conn.prepareStatement(sql);
	stmt.setString(1, newLocal);
	stmt.setString(2, beforelocalName);
		System.out.println(stmt + "<--카테고리명 수정 액션 stmt");
		
	//지역 중복확인 
	PreparedStatement localstmt2 = null;
	ResultSet localRs = null;

	String localsql2 = "SELECT local_name localName from local where local_name = ?";
	localstmt2 = conn.prepareStatement(localsql2);
	localstmt2.setString(1, newLocal);
	System.out.println( localstmt2 + " <--지역 수정 stmt2");
	localRs = localstmt2.executeQuery();	
			
	//중복된 지역이 있는경우
		if(localRs.next()){ 
			msg = URLEncoder.encode("이미 존재하는 지역입니다.", "utf-8");
			response.sendRedirect(request.getContextPath()+"/board/updateLocalForm.jsp?msg="+msg);
			return;
		}
	
	int row = stmt.executeUpdate();
	if(row == 1) {//성공 
		System.out.println(row + "<--카테고리명 수정 성공");
		response.sendRedirect(request.getContextPath()+"/board/category.jsp");
	} else {
		System.out.println(row + "<--카테고리명 수정 실패");
		response.sendRedirect(request.getContextPath()+"/board/updateLocalForm.jsp");
		return;
	}
%>