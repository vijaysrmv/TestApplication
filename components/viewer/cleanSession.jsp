<%@page import="com.newgen.iforms.util.IFormUtility"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%-- 
    Document   : cleanSession
    Created on : Nov 14, 2018, 5:13:11 PM
    Author     : g.sharma
--%>
<%--
29/03/2019  Aman Khan   Bug 83852 - we have open the worlitem by hyperlink.while closing the hyperlink worlitem customsession bean becomes blank.i.e.session become blank.
--%>


<%
HttpSession session1=request.getSession(false);
String pid=IFormUtility.escapeHtml4(request.getParameter("pid"));
String wid=IFormUtility.escapeHtml4(request.getParameter("wid"));
String taskid=IFormUtility.escapeHtml4(request.getParameter("taskid"));
if (session1 != null) {
    if("Y".equals(IFormUtility.escapeHtml4(request.getParameter("ps")))){
    if(session1.getAttribute("iFormWorkitemCount")!=null){
        int updatedWICount = Integer.parseInt(session.getAttribute("iFormWorkitemCount").toString())-1;
        session1.setAttribute("iFormWorkitemCount", updatedWICount);
        if(updatedWICount==-1){
            session1.removeAttribute("iFormWorkitemCount");
            session1.invalidate();
        }
		String tempFid="_"+pid+"_"+wid;
        if(taskid!=null && !taskid.isEmpty())
            tempFid+="_"+taskid;
        session1.removeAttribute("iForm"+tempFid+"Session");
		session1.removeAttribute("iTemplateTaskForm"+tempFid+"Session");
        session1.removeAttribute("iDataTemplateTaskForm"+tempFid+"Session");
        session1.removeAttribute("objForm"+tempFid+"Viewer");
        session1.removeAttribute("objTemplateTaskForm"+tempFid+"Viewer");
        session1.removeAttribute("objDataTemplateTaskForm"+tempFid+"Viewer");
    }    
    }
    else{
        String tempFid="_"+pid+"_"+wid;
        if(taskid!=null && !taskid.isEmpty())
            tempFid+="_"+taskid;
        session1.removeAttribute("iForm"+tempFid+"Session");
        session1.removeAttribute("iTemplateTaskForm"+tempFid+"Session");
        session1.removeAttribute("iDataTemplateTaskForm"+tempFid+"Session");
        session1.removeAttribute("objForm"+tempFid+"Viewer");
        session1.removeAttribute("objTemplateTaskForm"+tempFid+"Viewer");
        session1.removeAttribute("objDataTemplateTaskForm"+tempFid+"Viewer");
        session1.removeAttribute("hmAOC");
    }
} 

%>
