<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%
	response.setHeader("Cache-control", "No-Cache");
	response.setHeader("Pragma", "No-Cache");
%>
<div id="lossDtlsMainDiv" name="lossDtlsMainDiv" style="padding-top: 10px; ">
	<div class="sectionDiv" style="width: 99.5%; padding-top: 10px; ">
		<div id="lossDtlsFieldDiv" align="left" style="margin-left: 10px;">
			<div id="lossDtlsFieldTableGrid"
				style="height:210px; width:795px;"></div>
		</div>
			<div style="padding-bottom: 5px;">
				<table cellpadding="0" align="right" style="width: 795px;">
					<tr id="trOne">
						<td style="width: 190px;"></td>
						<td class="rightAligned" style="width: 225px;">Total :</td>
						<td align="right" style="width: 122px;"><input style="width: 122px;"
							id="txtTotLossAmt" name="txtTotLossAmt" type="text"
							readOnly="readonly" class="money" /></td>
						<td align="left" style="width: 118px; margin-right: 20px;"><input style="width: 118px;"
							id="txtTotNetAmt" name="txtTotNetAmt" type="text"
							readOnly="readonly" class="money" /></td>
					</tr>
				</table>
			</div>
		</div>		
	</div>
	<center>	
		<input type="button" class="button" value="Return" id="btnReturn" style="width: 100px; margin-top: 20px" /> 
	</center>
</div>
<script>
try{
	var jsonLossDtlsField = JSON.parse('${jsonLossDtlsField}');
	lossDtlsFieldTableModel = {
		url : contextPath
				+ "/GICLClaimListingInquiryController?action=getLossDtlsField&refresh=1&claimId=${claimId}&clmLossId=${clmLossId}&lossExpCd=${lossExpCd}",
		options : {
			hideColumnChildTitle: true,
			width : '795px',
			height : '210px',
			pager : {},
			onCellFocus : function(element, value, x, y, id) {	
				tbgLossDtlsField.keys.removeFocus(
						tbgLossDtlsField.keys._nCurrentFocus, true);
				tbgLossDtlsField.keys.releaseKeys();				
			},
			onRemoveRowFocus : function(element, value, x, y, id) {						
				tbgLossDtlsField.keys.removeFocus(
						tbgLossDtlsField.keys._nCurrentFocus, true);
				tbgLossDtlsField.keys.releaseKeys(); 		
			}
		},
		columnModel : [ {
			id : 'recordStatus',
			title : '',
			width : '0',
			visible : false
		}, {
			id : 'divCtrId',
			width : '0',
			visible : false
		}, {
			id : "lossExpCd dspExpDesc",
			title : "Loss",
			width : '670px',		
			children : [{
			                id : 'lossExpCd',
			                title:'Loss Exp Cd',
			                width: 80,
			                filterOption: true
			            },{
			                id : 'dspExpDesc',
			                title: 'DSP Exp Desc',
			                width: 220,
			                filterOption: true
			            }]
		}, {
			id : "noOfUnits",
			title : "Unit(s)",
			width : '70px',
			align : "right",
			titleAlign : "right",
			filterOption : true
		}, {
			id : "nbtBaseAmt",
			title : "Base Amount",
			width : '130px',
			align : "right",
			filterOption : true,
			titleAlign : 'right',
			filterOptionType : 'number',
			geniisysClass : 'money'
		}, {
			id : "dtlAmt",
			title : "Loss Amount",
			width : '130px',
			align : "right",
			filterOption : true,
			titleAlign : 'right',
			filterOptionType : 'number',
			geniisysClass : 'money'
		}, {
			id : "nbtNetAmt",
			title : "Amt. Less Deductibles",
			width : '130px',
			align : "right",
			filterOption : true,
			titleAlign : 'right',
			filterOptionType : 'number',
			geniisysClass : 'money'
		}],
		rows : jsonLossDtlsField.rows
	};

	tbgLossDtlsField = new MyTableGrid(lossDtlsFieldTableModel);
	tbgLossDtlsField.pager = jsonLossDtlsField;
	tbgLossDtlsField.render('lossDtlsFieldTableGrid');
	tbgLossDtlsField.afterRender = function(){
		var rec = tbgLossDtlsField.geniisysRows[0];
		$("txtTotLossAmt").value = formatCurrency(rec.totDtlAmt);
		$("txtTotNetAmt").value = formatCurrency(rec.totNetAmt);
	};
	 
	$("btnReturn").observe("click", function(){
		overlayLossDtls.close();
	});	
} catch (e) {
	showErrorMessage("Error : " , e.message);
} 
</script>