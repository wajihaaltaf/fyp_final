<%@ page import ="java.sql.*" %>
<%
    String userid = request.getParameter("uname");    
   String pwd = request.getParameter("pass"); int chk=0;
    Class.forName("com.mysql.jdbc.Driver");
    Connection con = DriverManager.getConnection("jdbc:mysql://localhost:3306/fyp",
            "root", "");
  Statement st = con.createStatement();
  ResultSet rs;
 rs = st.executeQuery("select * from login_info where LOGIN_ID='" + userid + "' and password='" + pwd + "'");
    if (rs.next()) {
        session.setAttribute("userid", userid);
        response.sendRedirect("faq.jsp");
    } 
    if(chk == 0){
rs = st.executeQuery("select * from admin_info where admin_email='" + userid + "' and admin_password='" + pwd + "'");
    if (rs.next()) {
        session.setAttribute("userid", userid);
        response.sendRedirect("adminprocess.jsp");
    } 
    } 
     else
        {out.println("Invalid password <a href='index.jsp'>try again</a>");}
    
%>