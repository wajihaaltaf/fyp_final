<%-- 
    Document   : process
    Created on : Jul 13, 2017, 6:52:54 PM
    Author     : User
--%>



<%@page import="java.text.SimpleDateFormat"%>
<%@page import="java.text.DateFormat"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%> 
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.io.*"%>
<%@ page import ="java.sql.*" %>
<%@page import="org.apache.poi.hssf.usermodel.HSSFSheet"%>
<%@page import="org.apache.poi.hssf.usermodel.HSSFWorkbook"%>
<%@page import="org.apache.poi.hssf.usermodel.HSSFRow"%>
<%@page import="org.apache.poi.hssf.usermodel.HSSFCell"%>
<%@ page import ="java.util.Calendar" %>

<% String username = (String)request.getSession().getAttribute("userid"); 
String text = request.getParameter("text"); 
 try { 
                    FileReader fw = new FileReader("D:\\output.csv");
                      BufferedReader br = new BufferedReader(fw); 
                      String s; String[] str2; String max_cid=null;  String max_thread=null;  
                      while((s = br.readLine()) != null) { 
                      if(s.indexOf(text) != -1){ 
                      str2 = s.split(",");
                         max_cid=str2[12]; max_thread=str2[7];
                      }
                      } 
                      response.sendRedirect("querypage.jsp?max_thread=" + max_thread+"&max_cid="+max_cid);
                      fw.close();

} catch (Exception e) {
e.printStackTrace();
}
    %>
%>
