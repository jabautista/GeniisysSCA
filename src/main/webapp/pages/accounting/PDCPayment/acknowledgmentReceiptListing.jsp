<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>

<%
	response.setHeader("Cache-control", "No-Cache");
	response.setHeader("Pragma", "No-Cache");
%>
<div id="acknowledgementReceiptMainDiv" style="margin-bottom: 50px; float: left; width: 100%;">
	<div id="acknowledgementReceiptDiv">
		<div id="outerDiv" name="outerDiv">
			<div id="innerDiv" name="innerDiv">
		   		<label>Acknowledgement Receipt Listing</label>
		   	</div>
		</div>
		<div class="sectionDiv" id="acknowledgementReceiptSectionDiv">
			<!-- benjo 11.08.2016 SR-5802 -->
			<div id="apdcFlagDiv" style="margin: 15px 10px 35px 350px;">
				<input title="New" type="radio" id="newRB" name="apdcFlag" value="N" style="margin: 0 5px 0 5px; float: left;" checked="true"><label for="newRB">New</label>
				<input title="Printed" type="radio" id="printedRB" name="apdcFlag" value="P" style="margin: 0 5px 0 30px; float: left;"><label for="printedRB">Printed</label>
				<input title="Cancelled" type="radio" id="cancelledRB" name="apdcFlag" value="C" style="margin: 0 5px 0 30px; float: left;"><label for="cancelledRB">Cancelled</label>
			</div>
			
			<div id="acknowledgementReceiptTableDiv" style="padding: 10px;">
				<div id="acknowledgementReceiptTable" style="height: 325px"></div>
			</div>
	   	</div>
	</div>
</div>
<script type="text/javascript">
	setModuleId(null);
	initializeAll();
	setDocumentTitle("Accounting - Acknowledgement Receipt");	
	initializeAccordion();
	var selectedIndex = null;
	objGIACApdcPayt = null;
	var cashierCd = "${cashierCd}";
	var apdcFlagRB = "N"; //benjo 11.08.2016 SR-5802
	
	function deleteApdcPayt(){
		new Ajax.Request(contextPath+"/GIACAcknowledgmentReceiptsController", {
			parameters: {
				action: "delApdcPayt",
				apdcId : objGIACApdcPayt.apdcId
			},
			onCreate: showNotice("Deleting Acknowledgement Receipt, please wait..."),
			onComplete: function(response){
				hideNotice();
				if(checkErrorOnResponse(response)){
					objGIACApdcPayt = null;
					tbgAcknowledgementReceipt.refresh();
				}
			}
		});
	}	
	
	var objTGAcknowledgmentReceipt = JSON.parse('${apdcTableGrid}'.replace(/\\/g, "\\\\"));
	var acknowledgementReceiptTable = {
			url: contextPath+"/GIACAcknowledgmentReceiptsController?action=getApdcPaytList&refresh=1&branchCd=${branchCd}&apdcFlag="+apdcFlagRB, //benjo 11.08.2016 SR-5802
			options: {
				width: '900px',
				hideColumnChildTitle: true,
				pager: {
				},
				toolbar: {//remove delete button kenneth 12.02.2015 SR
					elements: [MyTableGrid.ADD_BTN, MyTableGrid.EDIT_BTN,/*  MyTableGrid.DEL_BTN, */ MyTableGrid.REFRESH_BTN, MyTableGrid.FILTER_BTN],
					onAdd : function(){
						if(cashierCd == ""){
							showMessageBox("You are not authorized to create records for this Company/Branch.", imgMessage.ERROR);
							return false;
						} else {
							objGIACApdcPayt = null;
							tbgAcknowledgementReceipt.keys.removeFocus(tbgAcknowledgementReceipt.keys._nCurrentFocus, true);
							tbgAcknowledgementReceipt.keys.releaseKeys();
							showAcknowledgementReceipt("${branchCd}", "${moduleId}");
						}
					},
					onEdit : function(){
						if(cashierCd == ""){
							showMessageBox("You are not authorized to modify records for this Company/Branch.", imgMessage.ERROR);
							return false;
						} else {
							if(objGIACApdcPayt == null){
								showMessageBox("Please select a record.", imgMessage.INFO);
							} else {							
								tbgAcknowledgementReceipt.keys.removeFocus(tbgAcknowledgementReceipt.keys._nCurrentFocus, true);
								tbgAcknowledgementReceipt.keys.releaseKeys();
								showAcknowledgementReceipt("${branchCd}", "${moduleId}");
							}
						}
					}/* , //remove delete function kenneth 12.02.2015 SR
					onDelete : function(){
						if(cashierCd == ""){
							showMessageBox("You are not authorized to delete records for this Company/Branch.", imgMessage.ERROR);
							return false;
						} else {
							if(objGIACApdcPayt == null){
								showMessageBox("Please select a record.", imgMessage.INFO);
							} else {							
								showConfirmBox("Confirmation", "Please confirm deletion of acknowledgement receipt. Continue?", "Yes", "No", 
									function(){									
										deleteApdcPayt();
										tbgAcknowledgementReceipt.keys.removeFocus(tbgAcknowledgementReceipt.keys._nCurrentFocus, true);
										tbgAcknowledgementReceipt.keys.releaseKeys();
									},
									"");
							}
						}
					} */
				},
				onCellFocus : function(element, value, x, y, id) {
					var mtgId = tbgAcknowledgementReceipt._mtgId;					
					if($('mtgRow'+mtgId+'_'+y).hasClassName("selectedRow")){						
						selectedIndex = y;
						objGIACApdcPayt = tbgAcknowledgementReceipt.geniisysRows[y];					
					}
				},
				onRemoveRowFocus : function(){
					tbgAcknowledgementReceipt.keys.removeFocus(tbgAcknowledgementReceipt.keys._nCurrentFocus, true);
					tbgAcknowledgementReceipt.keys.releaseKeys();
					objGIACApdcPayt = null;
				},
				onRowDoubleClick : function(y){
					if(cashierCd == ""){
						showMessageBox("You are not authorized to modify records for this Company/Branch.", imgMessage.ERROR);
						return;
					} else {
						objGIACApdcPayt = tbgAcknowledgementReceipt.geniisysRows[y];
						tbgAcknowledgementReceipt.keys.removeFocus(tbgAcknowledgementReceipt.keys._nCurrentFocus, true);
						tbgAcknowledgementReceipt.keys.releaseKeys();
						showAcknowledgementReceipt("${branchCd}", "${moduleId}");
					}
				}
			},							
			columnModel: [
				{
				    id: 'recordStatus',
				    title: '',
				    width: '0',
				    visible: false
				},
				{
					id: 'divCtrId',
					width: '0',
					visible: false 
				},
				{	id: 'apdcPref apdcNo',
					title: 'APDC No.',
					width : '130px',	                
					children : [
			            {	id : 'apdcPref',
			                width : 60,
			                editable: false
			            },
			            {	id : 'apdcNo',
			            	title : "APDC No.",
			                width : 90,
			                editable: false,
			                filterOption: true,
			                renderer: function(value) {
								return nvl(value, "") == '' ? '' : formatNumberDigits(nvl(value, 0),10);
			    			}
			            }
					]
				},				
				{
					id : "apdcDate",
					title: "APDC Date",
					width: '100px',
					titleAlign : 'center',
					align: 'center',
					filterOption: true,
					filterOptionType: 'date',
					renderer: function(value) {
						return nvl(value, "") == '' ? '' : dateFormat(value, 'mm-dd-yyyy');
	    			}
				},
				{
					id : "payor",
					title: "Payor",
					width: '240px',
					filterOption: true
				},
				{
					id : "particulars",
					title: "Particulars",
					width: '280px',
					filterOption: true
				},
				/* {
					id : "refApdcNo",
					title: "Ref APDC No.",
					width: '90px',
					filterOption: true
				}, */
				{
					id : "apdcFlagMeaning",
					title: "Status",
					width: '90px',
					filterOption: true
				},
				{
					id : "apdcFlag",
					width: '0',
					visible: false
				}
			],
			rows: objTGAcknowledgmentReceipt.rows
		};

	tbgAcknowledgementReceipt = new MyTableGrid(acknowledgementReceiptTable);
	tbgAcknowledgementReceipt.pager = objTGAcknowledgmentReceipt;
	tbgAcknowledgementReceipt.render('acknowledgementReceiptTable');
	changeTag = 0;
	
	if("${moduleId}" == "GIACS156") {
		$("acExit").stopObserving("click");
		$("acExit").observe("click", function(){
			showBranchOR("APDC");
			$("acExit").stopObserving("click");
			$("acExit").observe("click", function(){
				goToModule("/GIISUserController?action=goToAccounting", "Accounting Main", null);
			});
		});
	}
	
	/* benjo 11.08.2016 SR-5802 */
	$$("input[name='apdcFlag']").each(function(r){
		$(r).observe("click", function(){
			apdcFlagRB = r.value;
			tbgAcknowledgementReceipt.url = contextPath+"/GIACAcknowledgmentReceiptsController?action=getApdcPaytList&refresh=1&branchCd=${branchCd}&apdcFlag="+apdcFlagRB;
			tbgAcknowledgementReceipt._refreshList();
		});
	});
</script>