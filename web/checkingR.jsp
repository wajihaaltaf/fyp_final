<%-- 
    Document   : checkingR
    Created on : Jul 13, 2017, 8:33:02 PM
    Author     : User
--%>

<script src="//code.jquery.com/jquery-1.11.1.min.js"></script>
<script src="//cdn.opencpu.org/opencpu-0.4.js"></script>
<%@page import="org.rosuda.JRI.Rengine"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="org.rosuda.REngine.REXPMismatchException"%>
<%@page import="org.rosuda.REngine.Rserve.RConnection"%>
 <%@page import="org.rosuda.REngine.Rserve.RserveException"%>

 <%/*
     RConnection connection = null;
  try {
          
              connection = new RConnection();
              
             /*String vector = "c(1,2,3,4)";
             connection.eval("meanVal=mean(" + vector + ")");
             double mean = connection.eval("meanVal").asDouble();
           out.print("The mean of given vector is=" + mean);*/
//Process p = Runtime.getRuntime().exec("D:/Program Files/R/R-3.4.1/bin/i386/Rscript.exe C:/Users/User/Documents/ab.R");
    //int processComplete = p.waitFor();

              /*     if (processComplete == 0) {

                        //JOptionPane.showMessageDialog(null,"Process is completed");
                        out.println("successfull");
                   } else {
                       //JOptionPane.showMessageDialog(null,"You Have selected Wrong Input File");
                        out.println("Could not complete");
                   }
                
   
 
    
 //Runtime.getRuntime().exec("D:/Program Files/R/R-3.4.1/bin/i386/Rscript.exe C:/Users/User/Documents/g.R"); 
         } catch (RserveException e) {
             e.printStackTrace();
         } finally{
             connection.close();
         }
        */
     %>
     <html><head></head><body><iframe src="https://bisma.shinyapps.io/first/" style="border: none; width: 440px; height: 500px"></iframe></body></html>