<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json" %>
<%
    response.setHeader("Cache-control", "No-Cache");
    response.setHeader("Pragma", "No-Cache");
%>

<div id="itemInformation" name="itemInformationMainDiv" style="width: 100%;">
	<div style="margin: 10px;" id="itemTable" name="itemTable">
    	<div class="tableHeader">
              <label style="width: 40px; text-align: right; margin-right: 10px;">No.</label>
              <label style="width: 200px; text-align: left;">Item Title</label>
              <label style="width: 190px; text-align: left;">Description 1</label>
              <label style="width: 190px; text-align: left;">Description 2</label>
              <label style="width: 120px; text-align: left;">Currency</label>
              <label style="width: 100px; text-align: right; margin-right: 10px;">Rate</label>
        </div>
        <input type="hidden" name="itemCount" id="itemCount" value="${itemCount}">
        <div id="parItemTableContainer" class="tableContainer">
		</div>
	</div>       
</div>

<script type="text/javascript">
/*
    $$("label[name='textItem']").each(function (label)    {
        if ((label.innerHTML).length > 15)    {
            label.update((label.innerHTML).truncate(15, "..."));
        }
    });

   

    $$("div[name='row']").each(function (div)    {        
        if ((div.down("label", 1).innerHTML).length > 30)    {
            div.down("label", 1).update((div.down("label", 1).innerHTML).truncate(30, "..."));
        }
    });
    */
</script>
