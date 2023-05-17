<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="vo.*" %>

<%
	A a = new A();
	String name = a.getFullName();
	System.out.println(name);
	
	/* String fname = a.getFirstName();
	System.out.println(fname);
	String sname = a.getSecondName();
	System.out.println(sname); */
%>