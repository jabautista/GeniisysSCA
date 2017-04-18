<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %> 
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json" %>
<%@ taglib uri="http://ajaxtags.org/tags/ajax" prefix="ajax" %>
<%
	response.setHeader("Cache-control", "No-Cache");
	response.setHeader("Pragma", "No-Cache");
%>
<div id="renewalHistoryMainDiv" class="sectionDiv" style="height: 281px; width: 463px;">
	<div id="renewalHistoryTGDiv" style="margin-left: 10px; margin-top: 10px; width: 443px; height: 238px; float: left;">
	
	</div>
	<div style="text-align: center;">
		<input type="button" class="button" id="btnOk" value="Ok" />
	</div>
</div>
<script type="text/JavaScript">
try{
	try{
		var objRenHist = new Object();
		
		objRenHist.objRenewalHistoryTableGrid = JSON.parse('${json}');
		objRenHist.objRenewalHistory = objRenHist.objRenewalHistoryTableGrid.rows || []; 
		
		var renewalHistoryModel = {
			url:contextPath+"/GIEXExpiriesVController?action=showRenewalHistory&refresh=1&policyId="+$F("hidPolicyId"),
			options:{
				width: '443px',
				height: '206px',
				onCellFocus: function(element, value, x, y, id){
					renewalHistoryTableGrid.keys.removeFocus(renewalHistoryTableGrid.keys._nCurrentFocus, true);
					renewalHistoryTableGrid.keys.releaseKeys();
				},
				onRemoveRowFocus: function(){
					renewalHistoryTableGrid.keys.removeFocus(renewalHistoryTableGrid.keys._nCurrentFocus, true);
					renewalHistoryTableGrid.keys.releaseKeys();
				},
				toolbar:{
					elements: [MyTableGrid.REFRESH_BTN, MyTableGrid.FILTER_BTN],
					onRefresh: function() {
						renewalHistoryTableGrid.keys.removeFocus(renewalHistoryTableGrid.keys._nCurrentFocus, true);
						renewalHistoryTableGrid.keys.releaseKeys();
					}
				}
			},
			columnModel:[
		 		{   id: 'recordStatus',
				    width: '0',
				    visible: false,
				    editor: 'checkbox' 			
				},
				{	id: 'divCtrId',
					width: '0px',
					visible: false
				},
				{	id: 'policyNumber',
					title: 'Policy Number',
					width: '200px',
					visible: true,
					filterOption : true
				},
			],
			rows: objRenHist.objRenewalHistory
		};
		renewalHistoryTableGrid = new MyTableGrid(renewalHistoryModel);
		renewalHistoryTableGrid.pager = objRenHist.objRenewalHistoryTableGrid;
		renewalHistoryTableGrid.render('renewalHistoryTGDiv');
		renewalHistoryTableGrid.afterRender = function(){
			try{
				
			}catch(e){
				showErrorMessage("renewalHistoryTableGrid.afterRender", e);
			}
		};
	}catch(e){
		showErrorMessage("renewalHistoryTableGrid",e);
	}
	
	$("btnOk").observe("click", function(){
		overlayRenewalHistoryDialog.close();
	});
}catch(e){
	showErrorMessage("renewalHistory.jsp", e);
}
</script>