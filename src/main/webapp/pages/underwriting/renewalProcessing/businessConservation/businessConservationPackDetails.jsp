<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %> 
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json" %>

<%
	response.setHeader("Cache-control", "No-Cache");
	response.setHeader("Pragma", "No-Cache");
%>

<div id="packPolNoDiv" name="packPolNoDiv" class="sectionDiv" style="width: 812px; margin-top: 5px; margin-bottom: 5px;">
	<table style="margin-left: 5px;">
		<tr>
			<td style="margin-left: 3px;"><label>Package Policy Number: </label></td>
			<td><input type="text" id="packPolNo" name="packPolNo" readonly="readonly" style="width: 150px;" value="${policyNo}"></td>
		</tr>
	</table>
</div>

<div id="busConPackDetailsSectionDiv" class="sectionDiv" style="height: 325x; width: 812px; border: none;">
	<div id="packDetailsTableGrid" style="height: 319px; width: 99%;"></div>
</div>

<div id="totalsDiv" name="totalsDiv" class="sectionDiv" style="width: 812px; margin-top: 14px;">
	<div id="totalsInnerDiv" name="totalsInnerDiv" style="float: right;">
		<label style="padding-top: 5px; padding-right: 10px;">Totals:</label>
		<input id="premTotal" name="premTotal" type="text" style="width: 87px; margin-left: 0px; float: left; text-align: right;"/>
		<input id="renewalCount" name="renewalCount" type="text" style="width: 125px; margin-left: 0px; float: left; border-left: 0px; text-align: right;"/>
		<input id="renewalTotal" name="renewalTotal" type="text" style="width: 76px; margin-left: 0px; float: left; border-left: 0px; text-align: right;"/>
	</div>
</div>

<div id="busConPackDetailsButtonsDiv" name="busConPackDetailsButtonsDiv" class="buttonsDiv" style="width: 99%; margin-bottom: 0px;">
	<table align="center">
		<tr>
			<td>
				<input type="button" class="button" style="width: 120px;" id="btnReturn" name="btnReturn" value="Return">
			</td>
		</tr>
	</table>
</div>

<script type="text/javascript">
	initializeMenu();
	setModuleId("GIEXS006");
	setDocumentTitle("Business Conservation Pack Details");
	var selectedIndex = -1;
	var arrGIEX009Buttons = [MyTableGrid.REFRESH_BTN, MyTableGrid.FILTER_BTN];
	
	var objBusConPackDetails = JSON.parse('${giexBusConPackListTableGrid}'.replace(/\\/g,'\\\\'));
	try{
	    var busConPackDetailsModel = {
	    	url: contextPath+"/GIEXBusinessConservationController?action=getBusConservationPackDetails&refresh=1&packPolId=${packPolId}",
	      	options:{
	            title: '',
	            height: '306px',
	          	width: '813px',
          		onCellFocus: function(element, value, x, y, id){
	          		var mtgId = packDetailsTableGrid._mtgId;
                	selectedIndex = -1;
                	if($('mtgRow'+mtgId+'_'+y).hasClassName("selectedRow")){
                		selectedIndex = y;
                		selectedExpiryListingIndex = y;
                	}
                },
                onRemoveRowFocus: function(){
                	packDetailsTableGrid.keys.removeFocus(packDetailsTableGrid.keys._nCurrentFocus, true);
            		packDetailsTableGrid.keys.releaseKeys();
                	selectedExpiryListingIndex = -1;
                },
                toolbar: {
                	elements: (arrGIEX009Buttons)
                }
      	    },
			columnModel:[
						{   
							id: 'recordStatus',
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
					rows: objBusConPackDetails.rows
		  		};
	    packDetailsTableGrid = new MyTableGrid(busConPackDetailsModel);
		packDetailsTableGrid.pager = objBusConPackDetails;
		packDetailsTableGrid.render('packDetailsTableGrid');
		packDetailsTableGrid.afterRender = function(){
			if(packDetailsTableGrid.rows.length > 0){
			      $("premTotal").value = packDetailsTableGrid.geniisysRows[0].premTotal;
			      $("renewalCount").value = packDetailsTableGrid.geniisysRows[0].renewalCount;
			      $("renewalTotal").value = packDetailsTableGrid.geniisysRows[0].premRenewTotal;
		      }else{
		    	  clearTotals();
		      }
		   };
	}catch(e){
		showMessageBox("Error in Business Conservation Details: " + e, imgMessage.ERROR);		
	}
	
	function clearTotals(){
        $("premTotal").value = "0.00";
        $("renewalCount").value = "0";
    	$("renewalTotal").value = "0.00";
	}

	$("btnReturn").observe("click", function(){
		packDetailsTableGrid.keys.removeFocus(packDetailsTableGrid.keys._nCurrentFocus, true);
		packDetailsTableGrid.keys.releaseKeys();
		busConPackDetails.close();
	});
</script>