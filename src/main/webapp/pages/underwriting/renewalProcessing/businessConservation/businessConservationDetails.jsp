<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %> 

<%
	response.setHeader("Cache-control", "No-Cache");
	response.setHeader("Pragma", "No-Cache");
%>

<div id="lineDiv" name="lineDiv" class="sectionDiv" style="width: 812px; margin-top: 5px; margin-bottom: 5px;">
	<table style="text-align: center;" align="center">
		<tr>
			<td style="margin-left: 3px;"><label>Issource:</label></td>
			<td>
				<span class="lovSpan" style="width: 75px; margin-top: 2px;">
					<input type="text" id="issCd" name="issCd" readonly="readonly" style="width: 45px; border: none; float: left; height: 13px; margin: 0px;">
					<img src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="searchIssLOV" name="searchIssLOV" alt="Go" style="float: right;"/>
				</span>
			</td>
			<td><input type="text" id="issName" name="issName" readonly="readonly" style="width: 150px; height: 14px;"></td>
			<td style="width: 100px;"></td>
			<td><label>Line:</label></td>
			<td>
				<span class="lovSpan" style="width: 75px; margin-top: 2px;">
					<input type="text" id="lineCd" name="lineCd" readonly="readonly" style="width: 45px; border: none; float: left; height: 13px; margin: 0px;">
					<img src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="searchLineLOV" name="searchLineLOV" alt="Go" style="float: right;"/>
				</span>
			</td>
			<td style="margin-right: 3px;"><input type="text" id="lineName" name="lineName" readonly="readonly" style="width: 150px; height: 14px;"></td>
		</tr>
	</table>
</div>

<div id="busConDetailsSectionDiv" class="sectionDiv" style="height: 325x; width: 812px; border: none;">
	<div id="detailsTableGrid" style="height: 319px; width: 99%;"></div>
</div>

<div id="totalsDiv" name="totalsDiv" class="sectionDiv" style="width: 812px; margin-top: 14px;">
	<div id="totalsInnerDiv" name="totalsInnerDiv" style="float: right;">
		<label style="padding-top: 5px; padding-right: 10px;">Totals:</label>
		<input id="premTotal" name="premTotal" type="text" style="width: 87px; margin-left: 0px; float: left; text-align: right;"/>
		<input id="renewalCount" name="renewalCount" type="text" style="width: 125px; margin-left: 0px; float: left; border-left: 0px; text-align: right;"/>
		<input id="renewalTotal" name="renewalTotal" type="text" style="width: 76px; margin-left: 0px; float: left; border-left: 0px; text-align: right;"/>
	</div>
</div>

<div id="busConDetailsButtonsDiv" name="busConDetailsButtonsDiv" class="buttonsDiv" style="width: 99%; margin-bottom: 0px;">
	<table align="center">
		<tr>
			<td>
				<input type="button" class="button" style="width: 120px;" id="btnReturn" name="btnReturn" value="Return">
				<!-- <input type="button" class="button" style="width: 120px;" id="btnPrint" name="btnPrint" value="Print"> -->
				<input type="button" class="button" style="width: 120px;" id="btnPackDetails" name="btnPackDetails" value="Package Details">
			</td>
		</tr>
	</table>
</div>

<script type="text/javascript">
	initializeMenu();
	initializeAccordion();
	setModuleId("GIEXS006");
	setDocumentTitle("Business Conservation Details");
	var selectedIndex = -1;
	var selectedExpiryListingIndex = -1;
	var arrGIEX009Buttons = [MyTableGrid.REFRESH_BTN, MyTableGrid.FILTER_BTN];

	var objTGBusConDetails = JSON.parse('${giexBusConListTableGrid}'.replace(/\\/g,'\\\\'));
	try{
		var busConDetailsModel = {
			url: contextPath+"/GIEXBusinessConservationController?action=getBusConservationDetails&refresh=1&mode=1",
			options: {
				title: '',
              	height: '306px',
	          	width: '813px',
	          	onCellFocus: function(element, value, x, y, id){
	          		var mtgId = detailsTableGrid._mtgId;
                	selectedIndex = -1;
                	if($('mtgRow'+mtgId+'_'+y).hasClassName("selectedRow")){
                		selectedIndex = y;
                		selectedExpiryListingIndex = y;
                	}
                	$("issCd").value = detailsTableGrid.geniisysRows[y].issCd;
                	$("issName").value = detailsTableGrid.geniisysRows[y].issName; 
                	$("lineCd").value = detailsTableGrid.geniisysRows[y].lineCd;
                	$("lineName").value = detailsTableGrid.geniisysRows[y].lineName;
                },
                onRemoveRowFocus: function(){
                	detailsTableGrid.keys.removeFocus(detailsTableGrid.keys._nCurrentFocus, true);
                	detailsTableGrid.keys.releaseKeys();
                	selectedExpiryListingIndex = -1;
                },
                toolbar: {
                	elements: (arrGIEX009Buttons)
                }
			},
			columnModel:[
						{   id: 'recordStatus',
						    width: '0px',
						    visible: false,
						    editor: 'checkbox' 			
						},
						{	id: 'divCtrId',
							width: '0px',
							visible: false
						},
						{
							id: 'rowCount',
							width: '0px',
							visible: false
						},
						{
							id: 'premTotal',
							width: '0px',
							visible: false
						},
						{
							id: 'premRenewTotal',
							width: '0px',
							visible: false
						},
						{
							id: 'renewalCount',
							width: '0px',
							visible: false
						},
			            {
			            	id: 'policyId',
			            	width: '0px',
			            	visible: false
			            },
			            {
			            	id: "packPolicyId",
			            	width: "0px",
			            	visible: false
			            },
			        	{
			            	id: "lineCd",
			            	width: "0px",
			            	visible: false
			            },
			         	{
			            	id: "issCd",
			            	width: "0px",
			            	visible: false
			            },
			         	{
			            	id: "lineName",
			            	width: "0px",
			            	visible: false
			            },
			         	{
			            	id: "issName",
			            	width: "0px",
			            	visible: false
			            },
						{
							id: "intmNum",
							title: "Intm No",
							width: "54px"
						},
						{
							id: "assdName",
							title: "Assured Name",
							width: "198px",
							filterOption: true
						},
						{
							id: "expDate",
							title: "Expiry Date",
							width: "75px",
							align: "center"
						},
						{
							id: "policyNo",
							title: "Policy Number",
							width: "150px",
							filterOption: true
						},
						{
							id: "fmPremAmt",
							title: "Premium",
							width: "89px",
							align: "right"
						},
						{
							id: 'renewalId',
							title: 'Renewal Number',
							width: '125px',
							filterOption: true
						},
						{
							id: 'fmPremRenewAmt',
							title: 'Premium',
							width: '78px',
							align: 'right'
						},
						{
							id: 'premAmt',
							title: 'Premium Amount',
							width: '0px',
							visible: false,
							type: "number",
							filterOption: true
						},
						{
							id: 'premRenewAmt',
							title: 'Renewal Premium',
							width: '0px',
							visible: false,
							type: "number",
							filterOption: true
						},
  					],
  				rows: objTGBusConDetails.rows
		};
		detailsTableGrid = new MyTableGrid(busConDetailsModel);
		detailsTableGrid.pager = objTGBusConDetails;
		detailsTableGrid.render('detailsTableGrid');
		detailsTableGrid.afterRender = function(){
		      if(detailsTableGrid.rows.length > 0){
			      $("premTotal").value = detailsTableGrid.geniisysRows[0].premTotal;
			      $("renewalCount").value = detailsTableGrid.geniisysRows[0].renewalCount;
			      $("renewalTotal").value = detailsTableGrid.geniisysRows[0].premRenewTotal;
		      }else{
		    	  clearTotals();
		      }
		   };
	}catch(e){
		showMessageBox("Error in Business Conservation Details: " + e, imgMessage.ERROR);		
	}

	function getTotals(){
		var premTotal = 0;
		var renewalCount = 0;
		var renewalTotal = 0;
		for(i = 0; i < detailsTableGrid.rows.length; i++){
			premTotal = premTotal + Number(detailsTableGrid.geniisysRows[i].premAmt);
			renewalTotal = renewalTotal + Number(detailsTableGrid.geniisysRows[i].premRenewAmt);
			if(detailsTableGrid.geniisysRows[i].renewalId != null){
				renewalCount = renewalCount + 1;
			}
		}
		$("premTotal").value = formatCurrency(premTotal);
		$("renewalTotal").value = formatCurrency(renewalTotal);
		$("renewalCount").value = renewalCount;
	}
	
	function clearTotals(){
        $("premTotal").value = "0.00";
        $("renewalCount").value = "0";
    	$("renewalTotal").value = "0.00";
	}
	
	if(busConDetailsModel.rows == ""){
		clearHeaderFields();
	}else{
		$("lineCd").value = detailsTableGrid.geniisysRows[0].lineCd;
		$("lineName").value = detailsTableGrid.geniisysRows[0].lineName;
		$("issCd").value = detailsTableGrid.geniisysRows[0].issCd;
		$("issName").value = detailsTableGrid.geniisysRows[0].issName;
	}

	$("btnReturn").observe("click", function(){
		detailsTableGrid.keys.removeFocus(detailsTableGrid.keys._nCurrentFocus, true);
    	detailsTableGrid.keys.releaseKeys();
		busConservationDetails.close();
	});
	
	/* $("btnPrint").observe("click", function(){
		detailsTableGrid.keys.removeFocus(detailsTableGrid.keys._nCurrentFocus, true);
    	detailsTableGrid.keys.releaseKeys();
		showGenericPrintDialog("Print Detail Report", "");
	}); */
	
	$("btnPackDetails").observe("click", function(){
		detailsTableGrid.keys.removeFocus(detailsTableGrid.keys._nCurrentFocus, true);
    	detailsTableGrid.keys.releaseKeys();
		viewPackDetails();
	});
	
	function viewPackDetails(){
		if(selectedExpiryListingIndex < 0){
			showMessageBox("Please select a policy.", imgMessage.ERROR);
		}else{
			if(detailsTableGrid.geniisysRows[selectedIndex].packPolicyId == 0){
				showMessageBox("There is no package detail for this policy.");
			}else{
				showBusConPackDetails(detailsTableGrid.geniisysRows[selectedIndex].packPolicyId,
									  detailsTableGrid.geniisysRows[selectedIndex].policyNo);
			}	
		}
	}

	function showBusConPackDetails(packPolId, policyNo){
		busConPackDetails = Overlay.show(contextPath+"/GIEXBusinessConservationController", {
			urlContent : true,
			draggable: true,
			urlParameters: {action: "getBusConservationPackDetails",	//showBusConPackDetails
							packPolId: packPolId,
							policyNo: policyNo},
		    title: "Package Details",
		    height: 450,
		    width: 815
		});
	}
	
	function clearHeaderFields(){
		$("issCd").value = "";
    	$("issName").value = ""; 
    	$("lineCd").value = "";
    	$("lineName").value = "";
	}
	
	$("searchLineLOV").observe("click", function(){
		detailsTableGrid.keys.removeFocus(detailsTableGrid.keys._nCurrentFocus, true);
    	detailsTableGrid.keys.releaseKeys();
		searchLineDetails();
	});
	
	function searchLineDetails(){
		LOV.show({
			controller: "UnderwritingLOVController",
			urlParameters: {action: "getBusDetailLineLOV"},
			title: "Line",
			width: 405,
			height: 386,
			columnModel:[
			             	{	id : "lineCd",
								title: "Line Code",
								width: '80px',
								type: 'number'
							},
							{	id : "lineName",
								title: "Line Name",
								width: '310px'
							}
						],
			draggable: true,
			onSelect : function(row){
				detailsTableGrid.url = contextPath + "/GIEXBusinessConservationController?action=getBusConservationDetails&refresh=1&lineCd="+row.lineCd+"&issCd="+$("issCd").value+"&mode=2"
												   + "&lineName="+row.lineName+"&issName="+$("issName").value;
				detailsTableGrid._refreshList();
				$("lineCd").value = row.lineCd;
				$("lineName").value = row.lineName;
			}
		});
	}
	
	$("searchIssLOV").observe("click", function(){
		detailsTableGrid.keys.removeFocus(detailsTableGrid.keys._nCurrentFocus, true);
    	detailsTableGrid.keys.releaseKeys();
		searchIssDetails();
	});
	
	function searchIssDetails(){
		LOV.show({
			controller: "UnderwritingLOVController",
			urlParameters: {action: "getBusDetailIssLOV"},
			title: "Issuing Source",
			width: 405,
			height: 386,
			columnModel:[
			             	{	id : "issCd",
								title: "Issue Code",
								width: '80px',
								type: 'number'
							},
							{	id : "issName",
								title: "Issue Name",
								width: '310px'
							}
						],
			draggable: true,
			onSelect : function(row){
				detailsTableGrid.url = contextPath + "/GIEXBusinessConservationController?action=getBusConservationDetails&refresh=1&lineCd="+$("lineCd").value+"&issCd="+row.issCd+"&mode=2"
												   + "&lineName="+$("lineName").value+"&issName="+row.issName;
				detailsTableGrid._refreshList();
				$("issCd").value = unescapeHTML2(row.issCd);
				$("issName").value = unescapeHTML2(row.issName);
			}
		});
	}
</script>