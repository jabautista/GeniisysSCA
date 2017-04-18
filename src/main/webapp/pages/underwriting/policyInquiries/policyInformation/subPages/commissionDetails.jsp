<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %> 
<%
	response.setHeader("Cache-control", "No-Cache");
	response.setHeader("Pragma", "No-Cache");
%>
<div id="commissionDetails" class="sectionDiv" style="border: none;">
	<div id="policyCommissionDetails" class="sectionDiv" style="border: none; margin-top: 10px;">
				<div id=commissionDetailList class="sectionDiv" style="border: none; height: 200px; width: 800px; margin: auto; margin-bottom: 15px;"></div> 
				<div id=commissionTotals style="border: none; float: right; margin-right: 30px;">
				Total <input style="width: 175px; text-align: right; margin-top: 15px;" type="text" id="prntCommRtSum" name="prntCommRtSum" value="" readonly="readonly"/>
					  <input style="width: 175px; text-align: right; margin-top: 15px;" type="text" id="prntCommAmtSum" name="prntCommAmtSum" value="" readonly="readonly"/>
					  <input style="width: 175px; text-align: right; margin-top: 15px;" type="text" id="chldCommRtSum" name="chldCommRtSum" value="" readonly="readonly"/>
					  <input style="width: 175px; text-align: right; margin-top: 15px; margin-right: 5px;" type="text" id="chldCommAmtSum" name="chldCommAmtSum" value="" readonly="readonly"/>
			  </div>
	</div>
</div>
<script type="text/javascript"> //Rey
	setModuleId("GIPIS100");
	setDocumentTitle("View Policy Information");
	try{
		var commissionDetails = new Object();
		commissionDetails.commissionDetailsTableGrid = {};
		//commissionDetails.commissionDetailsTableGrid = JSON.parse('${commissionDetailsList}'.replace(/\\/g,'\\\\'));
        if('${commissionDetailsList}' != ''){ //Added by Jerome Bautista SR 21374 01.15.2016
        	commissionDetails.commissionDetailsTableGrid = JSON.parse('${commissionDetailsList}');
			commissionDetails.commissionDetails = commissionDetails.commissionDetailsTableGrid.rows || [];
		}
		var commissionDetailsTableModel ={	//gzelle 06.27.2013 added url //Commented out by Jerome Bautista SR 21374 01.15.2016
			/* url: contextPath+"/GIPIPolbasicController?action=showCommissionDetails&refresh=1&lineCd="+$F("txtLineCd")
							+"&issCd="+$F("txtIssCd")+"&premSeqNo="+$F("invDtlPremSeqNo")+"&intmNo="+$F("invDtlIntmNo")
							+"&perilCd="+$F("invDtlPerilCd"), */
			options: {
				title: '',
				width: '900px',
				prePager: function(){
					clearQuotationFields();
				}
			},
			columnModel: [
							{   id: 'recordStatus',
							    title: '',
							    width: '0',
							    visible: false,
							    editor: 'checkbox' 			
							},
							{	id: 'divCtrId',
								width: '0',
								visible: false
							},
							{	id: 'perilName',
								title: 'Peril',
								//sortable: false,		comment out --gzelle 06.27.2013
								width: '168px'
							},
							{	id: 'prntDetailRt',
								title: 'Parent Comm%',
								titleAlign: 'right',
								align: 'right',
								width: '180px',
								//sortable: false,		comment out --gzelle 06.27.2013
								rendere: function(value){
									return formatToNineDecimal(value);
								}
							},
							{	id: 'prntDetailAmt',
								title: 'Parent Comm Amt',
								titleAlign: 'right',
								align: 'right',
								//sortable: false,		comment out --gzelle 06.27.2013
								width: '180px',
								geniisysClass : 'money',     
							    geniisysMinValue: '-999999999999.99',     
							    geniisysMaxValue: '999,999,999,999.99'
							},
							{	id: 'childCommRt',
								title: 'Agent Comm%',
								width: '180px',
								//sortable: false,		comment out --gzelle 06.27.2013
								titleAlign: 'right',
								align: 'right',
								renderer: function(value){
									return formatToNineDecimal(value);
								}
							},
							{	id: 'childCommAmt',
								title: 'Agent Comm Amt',
								//sortable: false,		comment out --gzelle 06.27.2013
								titleAlign: 'right',
								align: 'right',
								width: '180px',
								geniisysClass : 'money',     
							    geniisysMinValue: '-999999999999.99',     
							    geniisysMaxValue: '999,999,999,999.99'
							}
			              ],
				rows: []
		};
		commissionTableGridListing = new MyTableGrid(commissionDetailsTableModel);
		commissionTableGridListing.pager = commissionDetails.commissionDetailsTableGrid;
		commissionTableGridListing.render('commissionDetailList');
	}
	catch(e){
		showErrorMessage("commissionDetails.jsp",e);
	}
	getTotalDetails();
function getTotalDetails(){
	var totalPrntComm = 0;
	for(var i = 0; i<commissionTableGridListing.rows.length; i++){ //Modified by Jerome Bautista SR 2174 01.15.2016
		var val = commissionTableGridListing.rows[i][commissionTableGridListing.getColumnIndex('prntDetailRt')] == null || commissionTableGridListing.rows[i][commissionTableGridListing.getColumnIndex('prntDetailRt')] == "" ? 0 : commissionTableGridListing.rows[i][commissionTableGridListing.getColumnIndex('prntDetailRt')];
		totalPrntComm = parseFloat(totalPrntComm) + parseFloat(val);
	}
	var frmTotalPrntComm = formatToNineDecimal(totalPrntComm);
	$("prntCommRtSum").value       = (nvl(frmTotalPrntComm, ""));
	
	var totalPrntCommAmt = 0;
	for(var i = 0; i<commissionTableGridListing.rows.length; i++){ //Modified by Jerome Bautista SR 2174 01.15.2016
		var val = commissionTableGridListing.rows[i][commissionTableGridListing.getColumnIndex('prntDetailAmt')] == null || commissionTableGridListing.rows[i][commissionTableGridListing.getColumnIndex('prntDetailAmt')] == "" ? 0 : commissionTableGridListing.rows[i][commissionTableGridListing.getColumnIndex('prntDetailAmt')];
		totalPrntCommAmt = parseFloat(totalPrntCommAmt) + parseFloat(val);
	}
	var frmTotalCommAmt = formatCurrency(totalPrntCommAmt);
	$("prntCommAmtSum").value       = (nvl(frmTotalCommAmt, ""));
	
	var totalAgentComm = 0;
	for(var i = 0; i<commissionTableGridListing.rows.length; i++){ //Modified by Jerome Bautista SR 2174 01.15.2016
		var val = commissionTableGridListing.rows[i][commissionTableGridListing.getColumnIndex('childCommRt')] == null || commissionTableGridListing.rows[i][commissionTableGridListing.getColumnIndex('childCommRt')] == "" ? 0 : commissionTableGridListing.rows[i][commissionTableGridListing.getColumnIndex('childCommRt')];
		totalAgentComm = parseFloat(totalAgentComm) + parseFloat(val);
	}
	var frmTotalAgentComm = formatToNineDecimal(totalAgentComm);
	$("chldCommRtSum").value       = (nvl(frmTotalAgentComm, ""));
	
	var totalAgentCommAmt = 0;
	for(var i = 0; i<commissionTableGridListing.rows.length; i++){ //Modified by Jerome Bautista SR 2174 01.15.2016
		var val = commissionTableGridListing.rows[i][commissionTableGridListing.getColumnIndex('childCommAmt')] == null || commissionTableGridListing.rows[i][commissionTableGridListing.getColumnIndex('childCommAmt')] == "" ? 0 : commissionTableGridListing.rows[i][commissionTableGridListing.getColumnIndex('childCommAmt')];
		totalAgentCommAmt = parseFloat(totalAgentCommAmt) + parseFloat(val);
	}
	var frmTotalAgentCommAmt = formatCurrency(totalAgentCommAmt);
	$("chldCommAmtSum").value       = (nvl(frmTotalAgentCommAmt, ""));
	
	
}
</script>