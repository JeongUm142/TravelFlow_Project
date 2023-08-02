<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import = "java.sql.*"%>
<%@ page import = "java.net.*"%>
<%@ page import = "vo.*" %>
<%
	//인코딩 설정
	request.setCharacterEncoding("utf-8");

	//1.세션 유효성검사 
	if(session.getAttribute("loginMemberId") != null) {
		response.sendRedirect(request.getContextPath()+"/home.jsp");
		return;
	}
	
	//메시지
	String msg = "";
	
	//2.요청값 유효성검사
	if(request.getParameter("memberId")==null ||
		request.getParameter("memberPw")==null ||
		request.getParameter("memberPwRe")==null ||
		request.getParameter("memberId").equals("") ||
		request.getParameter("memberPw").equals("") ||
		request.getParameter("memberPwRe").equals("")) {
		msg = URLEncoder.encode("아이디와 비밀번호를 입력해주세요.", "utf-8");
		response.sendRedirect(request.getContextPath()+"/member/insertMemberForm.jsp?msg=" + msg);
		return;
		}

	String memberId = request.getParameter("memberId");
	String memberPw = request.getParameter("memberPw");
	String memberPwRe = request.getParameter("memberPwRe");
		//디버깅
		System.out.println(memberId + "<- 회원가입 memberId");
		System.out.println(memberPw + "<- 회원가입 memberPw");
		System.out.println(memberPwRe + "<- 회원가입 memberPwRe");
	
	// 비밀번호 일치 검사
	if(!memberPw .equals(memberPwRe)) { //비밀번호 오류
		System.out.println("비밀번호 오류");
		msg = URLEncoder.encode("비밀번호를 확인해주세요.","utf-8");
		response.sendRedirect("./insertMemberForm.jsp?msg="+msg);
		return;
	}
		
	//파라미터값 클래스 - 해당 변수에 새로운 값을 넣어야 저장 후 로그인 가능
	Member paramMember = new Member();
	paramMember.setMemberId(paramMember.getMemberId());
	paramMember.setMemberPw(paramMember.getMemberPw());
	
	String driver = "org.mariadb.jdbc.Driver";
	String dburl = "jdbc:mariadb://127.0.0.1:3306/userboard";
	String dbuser = "root";
	String dbpw = "java1234";
	Class.forName(driver);
	Connection conn = null;
	PreparedStatement stmt = null;
	PreparedStatement stmt2 = null; //id중복값 확인용 
	ResultSet rs = null;
	conn = DriverManager.getConnection(dburl, dbuser, dbpw);
	
	/*
    INSERT INTO into member(member_id, member_pw, createdate, updatedate)
	VALUES(?, password(?), now(), now());
 	*/
	String sql = "INSERT INTO member(member_id, member_pw, createdate, updatedate) VALUES(?, password(?), now(), now())";
	stmt = conn.prepareStatement(sql);
	stmt.setString(1, memberId);
	stmt.setString(2, memberPw);
		System.out.println(stmt + "<--로그인 액션 stmt");
		
	//id 중복확인 
	String sql2 = "SELECT member_id memberId from member where member_id = ?";
	stmt2 = conn.prepareStatement(sql2);
	stmt2.setString(1, memberId);
	System.out.println( stmt2 + " <--로그인 액션 stmt2");
	rs = stmt2.executeQuery();	
	//중복된 아이디가 있는경우
	if(rs.next()){ 
		msg = URLEncoder.encode("이미 사용중인 ID입니다.", "utf-8");
		response.sendRedirect(request.getContextPath()+"/member/insertMemberForm.jsp?msg="+msg);
		return;
	}		
		
	int row = stmt.executeUpdate();
	
	if(row==1){//성공 
		System.out.println(row + "<--회원가입 성공");
		msg = URLEncoder.encode("회원가입을 축하합니다!","utf-8");
		response.sendRedirect(request.getContextPath()+"/home.jsp?msg="+msg);
		
	} else {//실패
		System.out.println(row + "<--회원가입 실패");
		response.sendRedirect(request.getContextPath()+"/member/insertMemberForm.jsp");
		return;
	}
	
%>