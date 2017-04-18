<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="ajax" uri="http://ajaxtags.org/tags/ajax" %>
<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %> 
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json" %>
<%
	response.setHeader("Cache-control", "No-Cache");
	response.setHeader("Pragma", "No-Cache");
%>

<div id="branchORMainDiv" name="branchORMainDiv" class="sectionDiv" style="border-top: none; padding-bottom: 40px;">
	<input type="hidden" id="branchAccessed" value="${branchAccess}" />
	<div id="gridContainerDiv" style="width: 60%; margin-top: 20px; margin-left: 20%;">
		<div id="branchORTable" style="position:relative; height: 308px; margin-left: 10px; margin-top: 0px;"></div>
	</div>
</div>
<div class="buttonsDiv">
	<input type="button" class="button" id="btnCancel" name="btnCancel" value="Cancel" />
	<input type="button" class="button" id="btnProceed" name="btnProceed" value="Ok" />
</div>

<script type="text/javascript">

	var objBranchOR = new Object();
	objBranchOR.branchORTableGrid = JSON.parse('${branchORTableGrid}'.replace(/\\/g, '\\\\'));
	objBranchOR.branchOR = objBranchOR.branchORTableGrid.rows || [];
	var fundCd = null;
	var branchCd = null;
	var selectedRow = null;
	
	setModuleId("GIACS156");
	setDocumentTitle("Branch O.R.");
	initializeAll();
	addStyleToInputs();
	hideNotice();

	var isValid = null;
	var userMesg = null;

	function clearBranchVariables() {
		fundCd = "";
		branchCd = "";
	}
	
	try {
		var tableModel = {
				url: contextPath + "/GIACOtherBranchORController?action=showBranchOR&refresh=1&moduleId=GIACS156", //pol cruz, 10.14.2013
				//url: contextPath + "/GIACOtherBranchORController?action=refreshBranchOR",
				options: {
					toolbar: {
						elements: [MyTableGrid.FILTER_BTN, MyTableGrid.REFRESH_BTN]
					},
					width: 542,
					height: 306,
					hideColumnChildTitle: true,
					onCellFocus: function(element, value, x, y, id) {
						selectedRow = tableGrid.geniisysRows[y];
						fundCd = selectedRow.gfunFundCd;
						branchCd = selectedRow.branchCd;
					},
					onRemoveRowFocus : function(element, value, x, y, id) {
						selectedRow = null;
						fundCd = null;
						branchCd = null;
					},
					onRowDoubleClick: function(y) {
						fundCd = tableGrid.getValueAt(tableGrid.getColumnIndex('gfunFundCd'), y);
						branchCd = tableGrid.getValueAt(tableGrid.getColumnIndex('branchCd'), y);
						if((fundCd == null && branchCd == null) || (fundCd == "" && branchCd == "")) {
							showMessageBox("Please select a company and branch first.");
						} else {
							validateUserBranch();	
						}
					}
				},
				columnModel: [
				    { 								
					    id: 'recordStatus',
					    width: '0',
					    visible: false
					},
					{
						id: 'divCtrId',
						width: '0',
					    visible: false
					},
					{
						id: 'gfunFundCd',
						title: 'Company',
						width: 120,
						filterOption: true
					},
					{
						id: "branchCd branchName",
						title: "Branch",
						children: [
							{
								id: 'branchCd',
								title: 'Branch Code',
								width: 80,
								filterOption: true
							},
							{
								id: 'branchName',
								title: 'Branch Name',
								width: 330,
								filterOption: true
							}          
			           ]
					}
					
				],
				requiredColumns: 'branchCd branchName gfunFundCd',
				rows: objBranchOR.branchOR
			};
		
			tableGrid = new MyTableGrid(tableModel);
			tableGrid.pager = objBranchOR.branchORTableGrid;
			tableGrid.render('branchORTable');

	} catch(e) {
		showErrorMessage("branchORTableGrid", e);
	}
	
		
	$("btnProceed").observe("click", function() {
		if((fundCd == null && branchCd == null) || (fundCd == "" && branchCd == "")) {
			showMessageBox("Please select a  company and branch first.");
		} else {
			validateUserBranch();	
		}
	});	

	$("acExit").stopObserving();
	$("acExit").observe("click", function(){
		goToModule("/GIISUserController?action=goToAccounting", "Accounting Main", null);
	});
	
	$("btnCancel").observe("click", function() {
		goToModule("/GIISUserController?action=goToAccounting", "Accounting Main", null);
	});	
	
	function validateUserBranch() {
		new Ajax.Request(contextPath+"/GIACOtherBranchORController?action=validateBranchOR", {
			method: "GET",
			parameters: {selFundCd: fundCd,
						 selBranchCd: branchCd,
						 orCancellation: objACGlobal.orCancellation,
						 orTag: objACGlobal.orTag},
			asynchronous: true,
			evalScripts: true,
			onCreate: function() {
				showNotice("Validating user...");
			},
			onComplete: function(response) {
				hideNotice();
				var paramMap = JSON.parse(response.responseText);
				if(paramMap.validity == "Y") {
					if(paramMap.module == "GIACS090") {
						showAcknowledgementReceiptListing(branchCd, "GIACS156");
					} else {
						objAC.otherORBranchCd = branchCd;
						if($F("branchAccessed") == "CANCEL") {
							updateMainContentsDiv("/GIACOrderOfPaymentController?action=showORListing&cancelOR=Y"+
									"&selFundCd="+fundCd+"&selBranch="+branchCd,
							"Retrieving OR data, please wait...");
							objAC.butLabel = "Cancel OR"; 
							$("acExit").show(); 
						} else if($F("branchAccessed") == "MANUAL") {
							/* objACGlobal.orTag = '*'; 
							objACGlobal.callingForm = "GIACS156"; 
							objAC.butLabel = "Spoil OR"; 
							createORInformation(branchCd); */
							objAC.createORTag = "M";
							objACGlobal.callingForm = "GIACS156"; 
							updateMainContentsDiv("/GIACOrderOfPaymentController?action=showORListing"+
									"&selFundCd="+fundCd+"&selBranch="+branchCd+"&orTag=M",
							"Retrieving OR data, please wait...");
							objAC.butLabel = "Spoil OR";	
							$("acExit").show(); 
						} else {
							objAC.createORTag = "G";
							updateMainContentsDiv("/GIACOrderOfPaymentController?action=showORListing&selFundCd="+fundCd+
									"&selBranch="+branchCd+"&orTag=G", 
							  "Retrieving OR data, please wait...");
							objAC.butLabel = "Spoil OR";	
							$("acExit").show();
						}
					}
				} else {
					showMessageBox(paramMap.message);
				}
			}
		});
	}
</script>