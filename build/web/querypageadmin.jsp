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
<% String username = (String)request.getSession().getAttribute("userid"); %>
<% 
 String max_th = request.getParameter("max_thread");
   Class.forName("com.mysql.jdbc.Driver");
    Connection con = DriverManager.getConnection("jdbc:mysql://localhost:3306/fyp",
            "root", "");
   Statement st = con.createStatement();
  ResultSet rs;
  rs = st.executeQuery("select * from login_info where LOGIN_ID='" + username+"'");
 String STUDENT_ID=null,BOARD_EQ_NAME=null,Board=null,GROUP_NAME=null,DOMICILE=null;
 
    if (rs.next()) {
        
       STUDENT_ID=(String)rs.getString("STUDENT_ID");
       BOARD_EQ_NAME=(String)rs.getString("BOARD_EQ_NAME");
       BOARD_EQ_NAME= '"'+BOARD_EQ_NAME+'"';
       Board=(String)rs.getString("Board");
       GROUP_NAME=(String)rs.getString("GROUP_NAME");
       DOMICILE=(String)rs.getString("DOMICILE");
    }
    String abc=STUDENT_ID+","+username+","+BOARD_EQ_NAME+","+Board+","+GROUP_NAME+","+DOMICILE+","+max_th+",";
    int len=abc.length();
%>
<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8">
        <title>NED ADMISSION QUERY PORTAL | Query Page</title>
        <meta content='width=device-width, initial-scale=1, maximum-scale=1, user-scalable=no' name='viewport'>
        <!-- Bootstrap 3.3.2 -->
        <link href="bootstrap/css/bootstrap.min.css" rel="stylesheet" type="text/css" />    
        <!-- FontAwesome 4.3.0 -->
        <link href="https://maxcdn.bootstrapcdn.com/font-awesome/4.3.0/css/font-awesome.min.css" rel="stylesheet" type="text/css" />
        <!-- Ionicons 2.0.0 -->
        <link href="http://code.ionicframework.com/ionicons/2.0.0/css/ionicons.min.css" rel="stylesheet" type="text/css" />    
        <!-- Theme style -->
        <link href="dist/css/AdminLTE.min.css" rel="stylesheet" type="text/css" />
        <!-- AdminLTE Skins. Choose a skin from the css/skins 
             folder instead of downloading all of them to reduce the load. -->
        <link href="dist/css/skins/_all-skins.min.css" rel="stylesheet" type="text/css" />
        <!-- iCheck -->
        <link href="plugins/iCheck/flat/blue.css" rel="stylesheet" type="text/css" />
        <!-- Morris chart -->
        <link href="plugins/morris/morris.css" rel="stylesheet" type="text/css" />
        <!-- jvectormap -->
        <link href="plugins/jvectormap/jquery-jvectormap-1.2.2.css" rel="stylesheet" type="text/css" />
        <!-- Date Picker -->
        <link href="css/postbx.css" rel="stylesheet" type="text/css" />
        <link href="plugins/datepicker/datepicker3.css" rel="stylesheet" type="text/css" />
        <!-- Daterange picker -->
        <link href="plugins/daterangepicker/daterangepicker-bs3.css" rel="stylesheet" type="text/css" />
        <!-- bootstrap wysihtml5 - text editor -->
        <link href="plugins/bootstrap-wysihtml5/bootstrap3-wysihtml5.min.css" rel="stylesheet" type="text/css" />

        <!-- HTML5 Shim and Respond.js IE8 support of HTML5 elements and media queries -->
        <!-- WARNING: Respond.js doesn't work if you view the page via file:// -->
        <!--[if lt IE 9]>
            <script src="https://oss.maxcdn.com/libs/html5shiv/3.7.0/html5shiv.js"></script>
            <script src="https://oss.maxcdn.com/libs/respond.js/1.3.0/respond.min.js"></script>
        <![endif]-->
    </head>
    <body class="skin-blue">
        <div class="wrapper">

            <header class="main-header">
                <!-- Logo -->
                <a href="index2.html" class="logo"><b>NED</b> Query Portal</a>
                <!-- Header Navbar: style can be found in header.less -->
                <nav class="navbar navbar-static-top" role="navigation">
                    <!-- Sidebar toggle button-->

                </nav>
            </header>
            <!-- Left side column. contains the logo and sidebar -->
            <aside class="main-sidebar">
                <!-- sidebar: style can be found in sidebar.less -->
                <section class="sidebar">
                    <!-- Sidebar user panel -->
                    <div class="user-panel">

                        <div class="pull-left info">
                            <p><% username = (String)request.getSession().getAttribute("userid"); out.println(username); %>
                            </p>

                            <a href="#"><i class="fa fa-circle text-success"></i> Online</a>
                        </div>
                    </div>
                    <!-- search form -->

                    <!-- /.search form -->
                    <!-- sidebar menu: : style can be found in sidebar.less -->
                    <ul class="sidebar-menu">
                       <ul class="sidebar-menu">
                        <li class="header">MAIN NAVIGATION</li>
                        <li class="active treeview">
                            <a href="admin.jsp">
                                <i class="fa fa-dashboard"></i> <span>Home</span> <i class="fa fa-angle-left pull-right"></i>
                            </a>
                        </li>
                        <li class="treeview">
                            <a href="userqueries.jsp">
                                <i class="fa fa-files-o"></i>
                                <span>User Queries</span>
                            </a>
                        </li>
                       
                </section>
                <!-- /.sidebar -->
            </aside>

            <!-- Right side column. Contains the navbar and content of the page -->
            <div class="content-wrapper">
                <!-- Content Header (Page header) -->
                <section class="content-header">
                    <h1>
                        Query Page
                        <small>Query</small>
                    </h1>
                    <ol class="breadcrumb">
                        <li><a href="faq.jsp"><i class="fa fa-dashboard"></i> Home</a></li>
                        <li class="active">Query Page</li>
                    </ol>
                    <div class="container">
                        <br>
                        <p class="abc"><% String max_thread = request.getParameter("max_thread");
                        String max_cid = request.getParameter("max_cid");
                      String[] str2;
                      try
                      {
                      FileReader fw = new FileReader("D:\\output.csv");
                      BufferedReader br = new BufferedReader(fw); 
                      String s; 
                      while((s = br.readLine()) != null) { 
                      if(s.indexOf(max_thread) != -1){ 
                      str2 = s.split(",");
                          out.println(str2[8]);
                     }
                      } 
                      fw.close();
                      } catch (Exception e) {
                      e.printStackTrace();
                      }
 
                            %></p>



                        <p style="background-color:#F0F8FF; margin-bottom: 0; width: 85%;padding-top: 10px; padding-bottom: 10px; padding-left: 20px;"><br></p>
                            <%
                                     max_thread = request.getParameter("max_thread");
                                 max_cid = request.getParameter("max_cid");
  
                               try
                               { 
                                   String s; 
                               FileReader fws = new FileReader("D:\\output.csv");
                               BufferedReader brs = new BufferedReader(fws); 
                               String[] str=null; String t; String l;
                              while((s = brs.readLine()) != null) {
                                  str = s.split(",");
                                   for(int k=0;k<str.length;k++)
                                   {if(str[k].equals(max_cid)) { %>
                             <p style="background-color:#F0F8FF; margin-bottom: 0; width: 85%;padding-top: 10px; padding-bottom: 10px; padding-left: 20px;">  
                                   <%    
                                       out.print(str[8]);}
                                   %> </p> <% }
                       
                               } 
                    
                     
                               fws.close();
                               } 
                               catch (Exception e) {
                               e.printStackTrace();
                               }
 
                %>
                        <form method="post" action="processcomment.jsp">
                            <p style="background-color:#F0F8FF; margin-bottom: 0;width: 85%; padding-top: 10px; padding-bottom: 10px; padding-left: 20px;">
                                <textarea rows="4" cols="155" name="textarea"></textarea>
                                <input type="hidden" name="max_cid" value='<%= request.getParameter("max_cid") %>' >
                                <input type="hidden" name="max_thread" value='<%=request.getParameter("max_thread")%>'>
                                <input type="submit" class="btn btn-info" value="Post Comment">
                            </p></form>
                    </div>
                </section>
            
                <!-- Main content -->

            </div><!-- /.row (main row) -->

        </section><!-- /.content -->

    </div><!-- /.content-wrapper -->

    <footer class="main-footer">

        <div class="pull-right hidden-xs">
            <b>Version</b> 2.0
        </div>
        <strong>Copyright &copy; 2014-2015 <a href="http://almsaeedstudio.com">Almsaeed Studio</a>.</strong> All rights reserved.
    </footer>
</div><!-- ./wrapper -->

<!-- jQuery 2.1.3 -->
<script src="plugins/jQuery/jQuery-2.1.3.min.js"></script>
<!-- jQuery UI 1.11.2 -->
<script src="http://code.jquery.com/ui/1.11.2/jquery-ui.min.js" type="text/javascript"></script>
<!-- Resolve conflict in jQuery UI tooltip with Bootstrap tooltip -->
<script>
    $.widget.bridge('uibutton', $.ui.button);
</script>
<!-- Bootstrap 3.3.2 JS -->
<script src="bootstrap/js/bootstrap.min.js" type="text/javascript"></script>    
<!-- Morris.js charts -->
<script src="http://cdnjs.cloudflare.com/ajax/libs/raphael/2.1.0/raphael-min.js"></script>
<script src="plugins/morris/morris.min.js" type="text/javascript"></script>
<!-- Sparkline -->
<script src="plugins/sparkline/jquery.sparkline.min.js" type="text/javascript"></script>
<!-- jvectormap -->
<script src="plugins/jvectormap/jquery-jvectormap-1.2.2.min.js" type="text/javascript"></script>
<script src="plugins/jvectormap/jquery-jvectormap-world-mill-en.js" type="text/javascript"></script>
<!-- jQuery Knob Chart -->
<script src="plugins/knob/jquery.knob.js" type="text/javascript"></script>
<!-- daterangepicker -->
<script src="plugins/daterangepicker/daterangepicker.js" type="text/javascript"></script>
<!-- datepicker -->
<script src="plugins/datepicker/bootstrap-datepicker.js" type="text/javascript"></script>
<!-- Bootstrap WYSIHTML5 -->
<script src="plugins/bootstrap-wysihtml5/bootstrap3-wysihtml5.all.min.js" type="text/javascript"></script>
<!-- iCheck -->
<script src="plugins/iCheck/icheck.min.js" type="text/javascript"></script>
<!-- Slimscroll -->
<script src="plugins/slimScroll/jquery.slimscroll.min.js" type="text/javascript"></script>
<!-- FastClick -->
<script src='plugins/fastclick/fastclick.min.js'></script>
<!-- AdminLTE App -->
<script src="dist/js/app.min.js" type="text/javascript"></script>

<!-- AdminLTE dashboard demo (This is only for demo purposes) -->
<script src="dist/js/pages/dashboard.js" type="text/javascript"></script>

<!-- AdminLTE for demo purposes -->
<script src="dist/js/demo.js" type="text/javascript"></script>
</body>
</html>