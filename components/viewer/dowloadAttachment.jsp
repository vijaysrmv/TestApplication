<%@page import="com.newgen.iforms.util.IFormUtility"%>
<%
String 	sSessionId="",docId="";	
		try
			{
			
				sSessionId = IFormUtility.forHtml(IFormUtility.escapeHtml4(request.getParameter("Userdbid")));
                               docId = IFormUtility.forHtml(IFormUtility.escapeHtml4(request.getParameter("docID")));     
				
			}
			catch(Exception ignore)
			{
			
			}
%>

<!DOCTYPE html>
<html lang="en">
<head>
<title></title>    
<meta http-equiv="Content-Type" content="text/html;charset=UTF-8">
<script>
    
    
function submitform()
{ 
		document.getElementById('myForm').submit(); 
}
function openDocView()
{ window.open("","newWin","location=no,menubar=no,resizable=yes,scrollbars=yes,status=no,toolbar=no,left=100,top=20,width=600,height=600"); }
</script>
</head>
<body>
<form id="myForm" method="POST" onsubmit="openDocView();"  action="/omnidocs/integration/foldView/viewFoldList.jsp" target="newWin">
<input type="hidden" name="Application" value="DocView">
<input type="hidden" name="cabinetName" value="ibpscab13nov">
<input type="hidden" name="S" value="S"/>

UserDbId&nbsp;&nbsp;<input type="text" name="Userdbid" value="<%= IFormUtility.forHtml(sSessionId)%>">
&nbsp;&nbsp;Document Index&nbsp;&nbsp;<input type="text" name="DocId" value="<%= IFormUtility.forHtml(docId)%>">
<input type="hidden" name="sessionIndexSet" value="false">
<input type="submit" value="Search" onclick="openDocView();">
</form>
</body>
</html>