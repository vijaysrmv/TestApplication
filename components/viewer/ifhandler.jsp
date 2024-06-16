<%@page import="com.newgen.iforms.util.CommonUtility"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%-- 
    Document   : initv
    Created on : Nov 20, 2015, 4:18:01 PM
    Author     : puneet.pahuja
--%>

<%@page import="java.net.URLDecoder"%>
<%@page import="java.util.HashMap"%>
<%@page import="com.newgen.iforms.util.IFormUtility"%>
<%@page import="com.newgen.iforms.viewer.IFormViewer"%>
<%@page import="java.util.LinkedHashMap"%>
<%@page import="com.newgen.iforms.viewer.IFormHandler"%>
<%@page import="org.json.simple.JSONArray"%>
<%@page import="java.net.URLEncoder"%>
<%
    request.setCharacterEncoding("UTF-8");
    
    

    String sid = (String) IFormUtility.escapeHtml4(request.getParameter("WD_SID"));
    String rid_IfHandler = IFormUtility.generateTokens(request,request.getRequestURI());
    response.setHeader("WD_RID", IFormUtility.forJava(IFormUtility.removeSpecial(rid_IfHandler)));

    
    IFormViewer formviewer = (IFormViewer) session.getAttribute(IFormUtility.getIFormVSessionUID(request));
    
    IFormHandler iFormHandler = new IFormHandler(request,response,formviewer);
    
    if (IFormUtility.escapeHtml4(request.getParameter("op")) != null) {
        int op = Integer.parseInt(IFormUtility.escapeHtml4(request.getParameter("op")));
        String mobileMode=IFormUtility.escapeHtml4(request.getParameter("mobileMode"));
        if(mobileMode==null)
            mobileMode="Y";
        switch (op) {
            case 1:
                // Update attribute value
                iFormHandler.updateAttributeValue();
                break;
            case 2:
                // Save form data
                if( IFormUtility.escapeHtml4(request.getParameter("Mode")) != null ){
                     iFormHandler.saveFormAttributes();
                }
                else{
                    if( IFormUtility.escapeHtml4(request.getParameter("CalledFor")) != null ){
                        iFormHandler.customServerValidation(formviewer.getM_objFormDef(),op);
                    }else
                    {
                         iFormHandler.saveForm(mobileMode);
                    }
                }
                break;
            case 3:
                // Introduce workitem
                if( IFormUtility.escapeHtml4(request.getParameter("CalledFor")) != null ){
                    iFormHandler.customServerValidation(formviewer.getM_objFormDef(),op);
                }else
                {
                    iFormHandler.introduceWorkitem(mobileMode);
                }
                break;
            case 4:
                // Done workitem
                if( IFormUtility.escapeHtml4(request.getParameter("CalledFor")) != null ){
                        iFormHandler.customServerValidation(formviewer.getM_objFormDef(),op);
                }else
                {    
                    iFormHandler.doneWorkitem(mobileMode);
                }
                break; 
            case 5:
                // Update attribute value
                String attribXML=IFormUtility.removeSpecial(URLDecoder.decode((request.getParameter("AttribXML")),"UTF-8"));               
                iFormHandler.updateAOC(attribXML, (HashMap)session.getAttribute("hmAOC"));
                break;    
            case 6:               
                String richTextDataArray=iFormHandler.fetchRichTextEditorData();
                richTextDataArray=IFormUtility.TO_SANITIZE_STRING(richTextDataArray,true);
                richTextDataArray=URLEncoder.encode(richTextDataArray,"UTF-8").replaceAll("\\+", "%20");
                out.print(richTextDataArray);
                break;  
            case 7:               
                String jsonResponse=iFormHandler.saveRichTextEditor(formviewer.getM_objFormDef()); 
                out.print(jsonResponse);                              
                break;
            case 8:
                iFormHandler.executeUpdateTableData();
                break;  
            case 9:
                iFormHandler.initiateTaskForm();
            break;
            case 10:
                iFormHandler.printLog(request);
                break;
                
            default:
                break;
        }
    }

%>