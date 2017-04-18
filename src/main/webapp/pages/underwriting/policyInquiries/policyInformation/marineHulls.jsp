<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%
	response.setHeader("Cache-control", "No-Cache");
	response.setHeader("Pragma", "No-Cache");
%>
<div id="viewMarineHullsMainDiv" name="viewMarineHullsMainDiv" style="">

	<div id="regeneratePolicyDocumentsMenu">
		<div id="mainNav" name="mainNav">
			<div id="smoothmenu1" name="smoothmenu1" class="ddsmoothmenu">
				<ul>
					<li><a id="parExit">Exit</a></li>
				</ul>
			</div>
		</div>
	</div>
	
	<div class="sectionDiv" style="margin-bottom:50px;">
		<div id="marineHullsTableDiv"  style="height:305px;margin:10px auto 10px auto;"></div>
		
		<div style="text-align:center;margin:10px auto 10px auto">
			<input type="button" class="button" id="btnSummarizedInfo" name="btnSummarizedInfo" value="Summarized Information"/>
		</div>
	</div>
	
</div>

<script>

	getMarineHullsTable();
	$("parExit").observe("click", showViewPolicyInformationPage);

	function getMarineHullsTable(){

		new Ajax.Updater("marineHullsTableDiv","GIPIItemVesController?action=getMarineHullsTable",{
			method:"get",
			evalScripts: true
		});
	}

</script>