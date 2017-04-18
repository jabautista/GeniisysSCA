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
<div id="mainNav" name="mainNav">
	<div id="smoothmenu1" name="smoothmenu1" class="ddsmoothmenu">
		<ul>
			<li><a id="btnExit">Exit</a></li>
		</ul>
	</div>
</div>
<div id="outerDiv" name="outerDiv">
	<div id="innerDiv" name="innerDiv">
		<label>View Renewal</label>
		<span class="refreshers" style="margin-top: 0;">
	 		<label id="reloadForm" name="reloadForm">Reload Form</label> 
		</span>
	</div>
</div>
<div id="viewRenewalMainDiv" style="margin-bottom: 15px; height: 440px; width: 100%; border: 1px solid #E0E0E0; float: left;">
	<div id="viewRenewalTGDiv" style="margin: 10px 0px 0px 10px; width: 900px; height: 329px;">
	
	</div>
	<div id="buttonsDiv" style="margin-top: 10px; text-align: center;">
		<input type="button" class="button" id="renewalHistory" value="Renewal History" style="width: 150px;"/>
	</div>
</div>
<div>
	<input type="hidden" id="hidPolicyId" />
</div>
<script type="text/JavaScript">
try{
	setModuleId("GIPIS179");
	setDocumentTitle("View Renewal");
	
	try{
		var objGIPIS179 = new Object();
		
		objGIPIS179.objViewRenewalTableGrid = JSON.parse('${json}');
		objGIPIS179.objViewRenewal = objGIPIS179.objViewRenewalTableGrid.rows || []; 
		
		var viewRenewalModel = {
			url:contextPath+"/GIEXExpiriesVController?action=showViewRenewal&refresh=1",
			options:{
				width: '900px',
				height: '306px',
				onCellFocus: function(element, value, x, y, id){
					var withRenewal = viewRenewalTableGrid.geniisysRows[y].withRenewal;
					
					if(withRenewal == "Y"){
						enableButton("renewalHistory");
					}else{
						disableButton("renewalHistory");
					}
					
					$("hidPolicyId").value = viewRenewalTableGrid.geniisysRows[y].policyId;
					
					viewRenewalTableGrid.keys.removeFocus(viewRenewalTableGrid.keys._nCurrentFocus, true);
					viewRenewalTableGrid.keys.releaseKeys();
				},
				onRemoveRowFocus: function(){
					disableButton("renewalHistory");
					
					viewRenewalTableGrid.keys.removeFocus(viewRenewalTableGrid.keys._nCurrentFocus, true);
					viewRenewalTableGrid.keys.releaseKeys();
				},
				toolbar:{
					elements: [MyTableGrid.REFRESH_BTN, MyTableGrid.FILTER_BTN],
					onRefresh: function() {
						disableButton("renewalHistory");
						
						viewRenewalTableGrid.keys.removeFocus(viewRenewalTableGrid.keys._nCurrentFocus, true);
						viewRenewalTableGrid.keys.releaseKeys();
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
				{	id: 'withRenewal',
					sortable: false,
					align: 'center',
					title: '&#160;&#160;R',
					width: '25px',
					editable: false,
					hideSelectAllBox: true,
					editor: new MyTableGrid.CellCheckbox({
			            getValueOf: function(value){
		            		if (value){
								return "Y";
		            		}else{
								return "N";	
		            		}	
		            	},
		            })
				},
				{	id: 'policyNumber',
					title: 'Policy Number',
					width: '180px',
					visible: true,
					filterOption : true
				},
				{	id: 'assured',
					title: 'Assured',
					width: '469px',
					visible: true,
					filterOption : true
				},
				{	id: 'renewalNo',
					title: 'Renewal No.',
					width: '120px',
					visible: true,
					filterOption : true
				},
				{	id: 'userId',
					title: 'User ID',
					width: '90px',
					visible: true,
					filterOption : true
				},
			],
			rows: objGIPIS179.objViewRenewal
		};
		viewRenewalTableGrid = new MyTableGrid(viewRenewalModel);
		viewRenewalTableGrid.pager = objGIPIS179.objViewRenewalTableGrid;
		viewRenewalTableGrid.render('viewRenewalTGDiv');
		viewRenewalTableGrid.afterRender = function(){
			try{
				
			}catch(e){
				showErrorMessage("ViewRenewalTableGrid.afterRender", e);
			}
		};
	}catch(e){
		showErrorMessage("viewRenewalTableGrid",e);
	}
	
	function showRenewalHistoryDialog(){
		overlayRenewalHistoryDialog = Overlay.show(contextPath+"/GIEXExpiriesVController", {
			urlContent : true,
			urlParameters: {
				action : "showRenewalHistory",
				policyId : $F("hidPolicyId")	
			},
		    title: "Renewal History",
		    height: 298,
		    width: 465,
		    draggable: true
		});
	}
	
	$("renewalHistory").observe("click", showRenewalHistoryDialog);
	
	disableButton("renewalHistory");
	observeReloadForm("reloadForm", showViewRenewal);
	
	$("btnExit").observe("click", function(){
		if(objUWGlobal.callingForm == "GIEXS006"){
			showPrintExpiryReportRenewalsPage("");
		} else {
			goToModule("/GIISUserController?action=goToUnderwriting", "Underwriting Main", null);	
		}
	});
}catch(e){
	showErrorMessage("viewRenewal.jsp", e);
}
</script>