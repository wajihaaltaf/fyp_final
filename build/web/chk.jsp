<%  String STUDENT_ID,BOARD_EQ_NAME,Board,GROUP_NAME,DOMICILE,max_thread,max_cid;
   Class.forName("com.mysql.jdbc.Driver");
    Connection con = DriverManager.getConnection("jdbc:mysql://localhost:3306/fyp",
            "root", "");
   Statement st = con.createStatement();
  ResultSet rs;
  rs = st.executeQuery("select * from login_info where LOGIN_ID='" + username+"'");
 
    if (rs.next()) {
       STUDENT_ID=(String)rs.getString("STUDENT_ID");
       BOARD_EQ_NAME=(String)rs.getString("BOARD_EQ_NAME");
       BOARD_EQ_NAME= '"'+BOARD_EQ_NAME+'"';
       Board=(String)rs.getString("Board");
       GROUP_NAME=(String)rs.getString("GROUP_NAME");
       DOMICILE=(String)rs.getString("DOMICILE");
       max_thread=(String)rs.getString("max_thread");
       int foo = Integer.parseInt(max_thread);
       foo= foo+1;
       max_thread=String.valueOf(foo);
       PreparedStatement stx = con.prepareStatement("UPDATE login_info set max_thread='" + max_thread+"'");
       stx.executeUpdate();
       max_cid=(String)rs.getString("max_cid");
       foo = Integer.parseInt(max_cid);
       foo= foo+1;
       max_cid=String.valueOf(foo);
       stx = con.prepareStatement("UPDATE login_info set max_cid='" + max_cid+"'");
       stx.executeUpdate();
       String value1=request.getParameter("textarea");
       value1= '"'+value1+'"';
       Calendar cal = Calendar.getInstance();
       cal.add(Calendar.DATE, 1);
       SimpleDateFormat format1 = new SimpleDateFormat("dd/MM/yyyy HH:mm");
       String formatted = format1.format(cal.getTime());
       cal = Calendar.getInstance();
       cal.add(Calendar.DATE, 1);
       format1 = new SimpleDateFormat("HH:mm");
       String time = format1.format(cal.getTime());
try
{
FileWriter fw = new FileWriter("D:\\output.csv",true);

fw.append(STUDENT_ID);
fw.append(',');
fw.append(username);
fw.append(',');
fw.append(BOARD_EQ_NAME);
fw.append(',');
fw.append(Board);
fw.append(',');
fw.append(GROUP_NAME);
fw.append(',');
fw.append(DOMICILE);
fw.append(',');
fw.append(max_thread);
fw.append(',');
fw.append(value1);
fw.append(',');
fw.append(',');
fw.append(formatted);
fw.append(',');
fw.append(time);
fw.append(',');
fw.append(max_cid);
fw.append('\n');

fw.flush();
fw.close();
response.sendRedirect("querypage.jsp?max_thread=" + max_thread + "&max_cid="+max_cid);
} catch (Exception e) {
e.printStackTrace();
}
    } else {
        out.println("Error in fetching data");
    }

%>
<%
       RCaller caller = new RCaller(); 
        RCode code = new RCode(); 
code.addRCode("source('E:/xampp/htdocs/FYP/web/firststep.R')"); 
caller.setRCode(code); 
caller.setRscriptExecutable("D:/Program Files/R/R-3.4.1/bin/Rscript.exe");
  caller.runOnly();
%> 
<% ArrayList numbers = new ArrayList();
ArrayList numberss = new ArrayList();
ArrayList forusers = new ArrayList();
ArrayList forcid = new ArrayList();
    try
{
FileReader fw = new FileReader("E:\\xampp\\htdocs\\FYP\\web\\datac.csv");
BufferedReader br = new BufferedReader(fw); 
String s; String[] str2; 
while((s = br.readLine()) != null) { 
        str2 = s.split(",");
        numbers.add(str2[1]);
          numbers.add(str2[2]); 
} 
                      fw.close();
                      } catch (Exception e) {
                      e.printStackTrace();
                      }
    try
{
    int position = -1;
 FileReader fw = new FileReader("D:\\output.csv");
BufferedReader br = new BufferedReader(fw); 
String s; String[] str2; 
while((s = br.readLine()) != null) { 
      str2 = s.split(",");
      str2[8]='"'+str2[8]+'"';
     if(numbers.contains(str2[8]))
    {    
       position = numbers.indexOf(str2[8]);
       position=position-1;
       numberss.add(numbers.get(position));
       forusers.add(str2[1]);
       forcid.add(str2[12]);
    }     

} 
                      fw.close();
                      } catch (Exception e) {
                      e.printStackTrace();
                      }
    //out.println(numbers); out.println(numberss); out.println(forcid); out.println(forusers);
%>
<% 
String adminname = (String)request.getSession().getAttribute("userid"); 
for(int j=2;j<forusers.size();j++){ 
   Class.forName("com.mysql.jdbc.Driver");
    
  rs = st.executeQuery("select * from login_info where LOGIN_ID='" + forusers.get(j)+"'");

    if (rs.next()) { 
       STUDENT_ID=(String)rs.getString("STUDENT_ID");
       BOARD_EQ_NAME=(String)rs.getString("BOARD_EQ_NAME");
       BOARD_EQ_NAME= '"'+BOARD_EQ_NAME+'"';
       Board=(String)rs.getString("Board");
       GROUP_NAME=(String)rs.getString("GROUP_NAME");
       DOMICILE=(String)rs.getString("DOMICILE");
       max_thread=(String)rs.getString("max_thread");
       int foo = Integer.parseInt(max_thread);
       foo= foo+1;
       max_thread=String.valueOf(foo);
       PreparedStatement stx = con.prepareStatement("UPDATE login_info set max_thread='" + max_thread+"'");
       stx.executeUpdate();
       Calendar cal = Calendar.getInstance();
       cal.add(Calendar.DATE, 1);
       SimpleDateFormat format1 = new SimpleDateFormat("dd/MM/yyyy HH:mm");
       String formatted = format1.format(cal.getTime());
       cal = Calendar.getInstance();
       cal.add(Calendar.DATE, 1);
       format1 = new SimpleDateFormat("HH:mm");
       String time = format1.format(cal.getTime()); 
try
{
FileWriter fw = new FileWriter("D:\\output.csv",true);
fw.append(STUDENT_ID);
fw.append(',');
fw.append((String)forusers.get(j));
fw.append(',');
fw.append(BOARD_EQ_NAME);
fw.append(',');
fw.append(Board);
fw.append(',');
fw.append(GROUP_NAME);
fw.append(',');
fw.append(DOMICILE);
fw.append(',');
fw.append(max_thread);
fw.append(',');
fw.append((String)numberss.get(j));
fw.append(',');
fw.append(adminname);
fw.append(',');
fw.append(formatted);
fw.append(',');
fw.append(time);
fw.append(',');
fw.append((String)forcid.get(j));
fw.append('\n');
fw.flush();
fw.close();
//response.sendRedirect("userqueries.jsp");
} catch (Exception e) {
e.printStackTrace();
} 
    } else {
        out.println("Error in fetching data");
    }
} 

try{

    		File file = new File("E:\\xampp\\htdocs\\FYP\\web\\datac.csv");

    		if(file.delete()){
    			out.println(file.getName() + " is deleted!");
    		}else{
    			out.println("Delete operation is failed.");
    		}

    	}catch(Exception e){

    		e.printStackTrace();

    	}
try{

    		File file = new File("E:\\xampp\\htdocs\\FYP\\web\\testing.csv");

    		if(file.delete()){
    			out.println(file.getName() + " is deleted!");
    		}else{
    			out.println("Delete operation is failed.");
    		}

    	}catch(Exception e){

    		e.printStackTrace();

    	}

try
{
FileWriter fw = new FileWriter("C:\\Users\\User\\Documents\\testing.csv",true);
fw.append("Tweet");
fw.append('\n');
fw.flush();
fw.close();
response.sendRedirect("userqueries.jsp");
} catch (Exception e) {
e.printStackTrace();
} 
    
*/
%>
