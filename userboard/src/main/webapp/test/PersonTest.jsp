<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import = "vo.*"%>
<%
	Person kyh = new Person();
	kyh.setBirth(1995);
	//System.out.println(kyh.birth);
	System.out.println(kyh.getAge());
%>