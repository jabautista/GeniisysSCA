<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld" %>
<%
	response.setHeader("Cache-control", "No-Cache");
	response.setHeader("Pragma", "No-Cache");
%>

<div id="disbReqListDiv" name="disbReqListDiv" class="sectionDiv" style="height: 425px;">
	<div id="outerDiv" name="outerDiv">
		<div id="innerDiv" name="innerDiv">
			<label>Disbursement Request Listing</label>
		</div>
	</div>
	<div id="disbReqListTGDiv" name="disbReqListTGDiv" style="height: 420px; margin-top: 30px;">
		<div style="height: 30px; padding: 10px 5px 0px 5px;">
			<table align="center"">
				<tr>
					<c:forEach items="${paytReqFlagList}" var="paytReqFlag">
						<c:if test="${paytReqFlag.rvLowValue eq 'N' && paytReqFlag.rvLowValue ne 'P'}"> <!-- June Mark SR5838 [11.15.16] -->
							<td id="paytReqFlag${paytReqFlag.rvLowValue}TD">
								<input type="radio" name="paytReqFlagRG" id="paytReqFlag${paytReqFlag.rvLowValue}" value="${paytReqFlag.rvLowValue}" style="margin: 0 0 0 5px; float: left;" checked="checked"/>
								<label style="margin: 0 25px 0 5px;" for="paytReqFlag${paytReqFlag.rvLowValue}">${paytReqFlag.rvMeaning}</label>
							</td>
						</c:if>
						<c:if test="${paytReqFlag.rvLowValue ne 'N' && paytReqFlag.rvLowValue ne 'P'}"> <!-- June Mark SR5838 [11.15.16] -->
							<c:if test="${disbursement eq 'CR' and paytReqFlag.rvLowValue ne 'X' or disbursement ne 'CR'}">									
								<td id="paytReqFlag${paytReqFlag.rvLowValue}TD">
									<input type="radio" name="paytReqFlagRG" id="paytReqFlag${paytReqFlag.rvLowValue}" value="${paytReqFlag.rvLowValue}" style="margin: 0 0 0 5px; float: left;"/>
									<label style="margin: 0 25px 0 5px;" for="paytReqFlag${paytReqFlag.rvLowValue}">${paytReqFlag.rvMeaning}</label>
								</td>
							</c:if>
						</c:if>
					</c:forEach>
				</tr>
			</table>
		</div>
		<div id="disbReqListTG" name="disbReqListTG" style="height: 200px; padding: 5px 0 0 10px;"></div>
	</div>
	<div id="particularsDiv" name="particularsDiv">
		<table align="center">
			<tr>
				<td><label>Particulars</label></td>
				<td>
					<div style="border: 1px solid gray; height: 20px; width: 500px;">
						<textarea id="txtParticulars" name="txtParticulars" style="width: 470px; border: none; height: 13px; margin: 0px; resize: none;" maxlength="2000" readonly="readonly"/></textarea>
						<img src="${pageContext.request.contextPath}/images/misc/edit.png" style="width: 14px; height: 14px; margin: 3px; float: right;" alt="Edit" id="viewParticulars" />
					</div>
				</td>
			</tr>
		</table>
	</div>
</div>
<script type="text/javascript">
	objAC.paytReqStatTag = null;	//Gzelle 04.08.2013 - for Payment Request Status
	var paytReqFlagRB = "N";
	var disbursement = ('${disbursement}');
	var selectedIndex = -1;
	var otherBranch = '${otherBranch}';
	var objDR = new Object();
	objDR.disbRequestTableGrid = JSON.parse('${disbRequestsJSON}');
	objDR.disbRequestRows = objDR.disbRequestTableGrid.rows || [];
	try{
		var disbRequestTableModel = {
			url: contextPath+"/GIACPaytRequestsController?action=showDisbursementRequests&refresh=1&disbursement=${disbursement}&branchCd="+nvl(otherBranch,"") //marco - 05.04.2013 - added branchCd param
				 + "&paytReqFlag="+paytReqFlagRB,	// added by shan 11.04.2014
			options: {
				title: '',
	          	height: '306px',
	          	width: '900px',
	          	onCellFocus: function(element, value, x, y, id){
	          		var mtgId = disbRequestTableGrid._mtgId;
	            	if($('mtgRow'+mtgId+'_'+y).hasClassName("selectedRow")){
	            		selectedIndex = y;
	            		$("txtParticulars").value = unescapeHTML2(disbRequestTableGrid.geniisysRows[y].particulars);
	            	}
	            },
				onRowDoubleClick: function(y){
					var row = disbRequestTableGrid.geniisysRows[y];
					showDisbursementMainPage(disbursement, row.refId,otherBranch);
				},
	            onRemoveRowFocus: function(){
	            	selectedIndex = -1;
	            	$("txtParticulars").value = "";
	            },
	            toolbar: {
	            	elements: (objCLMGlobal.fromMenu == "cancelRequest" ? [MyTableGrid.VIEW_BTN, MyTableGrid.FILTER_BTN, MyTableGrid.REFRESH_BTN] : [MyTableGrid.ADD_BTN, MyTableGrid.EDIT_BTN, MyTableGrid.FILTER_BTN, MyTableGrid.REFRESH_BTN]),
	            	onAdd: function(){
	            		if (disbursement == "CR"){
	            			showMessageBox("Cannot create request in Cancel Request Menu.", "I");
	            			return false;
	            		}	
	            		showDisbursementMainPage(disbursement, "",otherBranch);
	            		disbRequestTableGrid.keys.removeFocus(disbRequestTableGrid.keys._nCurrentFocus, true);
						disbRequestTableGrid.keys.releaseKeys();
	            		return false;
	            	},
	            	onEdit: function(){
	            		showDisbursementMainPage(disbursement, disbRequestTableGrid.geniisysRows[selectedIndex].refId,otherBranch);
	            		disbRequestTableGrid.keys.removeFocus(disbRequestTableGrid.keys._nCurrentFocus, true);
						disbRequestTableGrid.keys.releaseKeys();
	            	},
	            	onView: function(){ // andrew	
						if (selectedIndex == -1 ) {
							showMessageBox("Please select a record first.", imgMessage.ERROR);
							return false;
						} else {
							var row = disbRequestTableGrid.geniisysRows[selectedIndex];
							showDisbursementMainPage(disbursement, row.refId,otherBranch);
							disbRequestTableGrid.keys.removeFocus(disbRequestTableGrid.keys._nCurrentFocus, true);
							disbRequestTableGrid.keys.releaseKeys();
						}
					}
	            }
			},
			columnModel:[
						{
							id: 'recordStatus',
						    width: '0px',
						    visible: false,
						    editor: 'checkbox' 			
						},
						{
							id: 'divCtrId',
							width: '0px',
							visible: false
						},
						{
							id: 'refId',
							width: '0px',
							visible: false
						},
						{
							id: 'requestNo',
							title: 'Request No.',
							titleAlign: 'left',
							width: '175px',
							filterOption: true
						},
						{
							id: 'oucName',
							title: 'Department',
							titleAlign: 'left',
							width: '150px',
							filterOption: false
						},
						{
							id: 'requestDate',
							title: 'Date',
							titleAlign: 'center',
							width: '100px',
							align: 'center',
							type: 'date',
							format: 'mm-dd-yyyy',
							filterOption: true,
							filterOptionType: 'formattedDate'
						},
						{
							id: 'payee',
							title: 'Payee',
							titleAlign: 'left',
							width: '253px',
							filterOption: true
						},
						{
							id: 'createBy',
							title: 'Created by',
							titleAlign: 'left',
							width: '100px',
							filterOption: true
						},
						{
							id: 'status',
							title: 'Status',
							titleAlign: 'left',
							width: '100px',
							filterOption: true
						},
						{
							id: 'particulars',
							title: 'Particulars',
							width: '0px',
							filterOption: true,
							visible: false
						}
  					],
  				rows: objDR.disbRequestRows
		};
		disbRequestTableGrid = new MyTableGrid(disbRequestTableModel);
		disbRequestTableGrid.pager = objDR.disbRequestTableGrid;
		disbRequestTableGrid.render("disbReqListTG");
		disbRequestTableGrid.afterRender = function(){
        	$("txtParticulars").value = "";
		};
	}catch(e){
		showMessageBox("Error in Disbursement Request Listing: " + e, imgMessage.ERROR);		
	}
	
	$("viewParticulars").observe("click", function(){
		disbRequestTableGrid.keys.removeFocus(disbRequestTableGrid.keys._nCurrentFocus, true);
		disbRequestTableGrid.keys.releaseKeys();
		showEditor("txtParticulars", 2000, 'true');
	});

	function executeQuery(){
		disbRequestTableGrid.url = contextPath+"/GIACPaytRequestsController?action=showDisbursementRequests&refresh=1&disbursement=${disbursement}&branchCd="+nvl(otherBranch,"") //marco - 05.04.2013 - added branchCd param
		 							+ "&paytReqFlag="+paytReqFlagRB;
		disbRequestTableGrid._refreshList();
	}
	
	$$("input[name='paytReqFlagRG']").each(function(rb){
		rb.observe("click", function(){
			paytReqFlagRB = rb.value;
			executeQuery();
		});
	});
	
 	$("acExit").stopObserving("click");
	$("acExit").observe("click", function(){
		if(objACGlobal.previousModule == "GIACS070"){	//added by shan 08.27.2013
			showGIACS070Page();
			objACGlobal.previousModule = null;
		}else if(objACGlobal.callingModule == "GIACS000"){
			goToModule("/GIISUserController?action=goToAccounting", "Accounting Main", null);			
		} else if(objACGlobal.callingModule == "GIACS055") {
			showOtherBranchRequests(objACGlobal.disbursementCd);
		}

// 		if(objCLMGlobal.fromMenu == "cancelRequest"){ move to otherBranchTableGridListing.jsp by steven 06.05.2013 
// 			objCLMGlobal.fromMenu = "";
// 		}
		objACGlobal.callingModule = "";
	});

	setModuleId(null);
</script>