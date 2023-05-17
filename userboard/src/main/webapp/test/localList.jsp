<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import = "java.sql.*"%>
<%@ page import = "java.util.*"%>
<%
	String driver = "org.mariadb.jdbc.Driver";
	String dburl = "jdbc:mariadb://127.0.0.1:3306/userboard";
	String dbuser = "root";
	String dbpw = "java1234";
	Class.forName(driver);
	Connection conn = null;
	PreparedStatement stmt = null; // 한 행만
	PreparedStatement stmt2 = null; //hash map 로컬 전부
	PreparedStatement stmt3 = null; //로컬 숫자
	ResultSet rs = null;
	ResultSet rs2 = null;
	ResultSet rs3 = null;
	conn = DriverManager.getConnection(dburl, dbuser, dbpw);
	
	/*
	SELECT local_name localName,'대한민국' country,'신정음' worker 
	FROM local 
	LIMIT 0,1
		*/
	String sql = "SELECT local_name localName,'대한민국' country,'신정음' worker FROM local LIMIT 0,1";
	stmt = conn.prepareStatement(sql);
	rs = stmt.executeQuery();
	//VO대신 HashMap타입을 사용
	
	//object(부모타입)는 모든 참조타입이 들어올 수 있음
			//키 이름, 값
	HashMap<String, Object> map = null;
	if(rs.next()){
		//디버깅 
		//System.out.println(rs.getString("localName") + "<--로컬리스트 localName");
		//System.out.println(rs.getString("country") + "<--로컬리스트 country");
		//System.out.println(rs.getString("worker") + "<--로컬리스트 worker");
		map = new HashMap<String, Object>();
		map.put("localName", rs.getString("localName")); // map.put(키이름, 값)
		map.put("country", rs.getString("country"));
		map.put("worker", rs.getString("worker"));
	}
		System.out.println((String)map.get("localName") + "<--맵 localName");
		System.out.println((String)map.get("country") + "<--맵 country");
		System.out.println((String)map.get("worker") + "<--맵 worker");
		
	/*
	SELECT local_name localName,'대한민국' country,'신정음' worker 
	FROM local 
		*/
	String sql2 = "SELECT local_name localName,'대한민국' country,'신정음' worker FROM local";
	stmt2 = conn.prepareStatement(sql2);
	rs2 = stmt.executeQuery();
	//<> 무슨모양이 여러개? - hashmap이 여러개 
	ArrayList<HashMap<String, Object>> list = new ArrayList<HashMap<String, Object>>();
	while(rs2.next()) {
		HashMap<String, Object> m = new	HashMap<String, Object>();
		m.put("localName", rs2.getString("localName")); // map.put(키이름, 값)
		m.put("country", rs2.getString("country"));
		m.put("worker", rs2.getString("worker"));
		list.add(m);
	}
	
	/*
	SELECT local_name, COUNT(local_name) cnt FROM board
	GROUP BY local_name
		*/
	String sql3 = "SELECT local_name localName, COUNT(local_name) cnt FROM board GROUP BY local_name";
	stmt3 = conn.prepareStatement(sql3);
	rs3 = stmt3.executeQuery();
	//<> 무슨모양이 여러개? - hashmap이 여러개 
	ArrayList<HashMap<String, Object>> list3 = new ArrayList<HashMap<String, Object>>();
	while(rs3.next()) {
		HashMap<String, Object> m = new	HashMap<String, Object>();
		m.put("localName", rs3.getString("localName")); // map.put(키이름, 값)
		m.put("cnt", rs3.getInt("cnt"));
		list3.add(m);
	}

%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>localList</title>
</head>
<body>
	<div>
		<h2>rs1 결과셋</h2>
		<%=map.get("localName")%>
		<%=map.get("country")%>
		<%=map.get("worker")%>
	</div>
	<hr>
	<h2>rs2 결과셋</h2>
	<table>
			<tr>
				<td>localName</td>
				<td>country</td>
				<td>worker</td>
			</tr>
	
		<%
			for(HashMap<String, Object> m : list) {
		%>
				<tr>
					<td><%=m.get("localName")%></td>
					<td><%=m.get("country")%></td>
					<td><%=m.get("worker")%></td>
				</tr>
		<%		
			}
		%>
	</table>
	
	<hr>
	<h2>rs3 결과셋</h2>	
	<ul>
		<%
			for(HashMap<String, Object> m : list3){
		%>
			<li>
				<a href="">
					<%=(String)m.get("localName")%>(<%=(Integer)m.get("cnt")%>)
				</a>
			</li>
		<%
			}
		%>
	</ul>
		
</body>
</html>