<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld" %>
<%
	response.setHeader("Cache-control", "no-cache");
	response.setHeader("Pragma", "no-cache");
%>
<div id="paytReqDtlMainDiv">
	<div id="paytReqDtlDiv" name="paytReqDtlDiv" class="sectionDiv" style="width: 99.5%; margin-top: 10px;">
		<div id="paytReqDtlTableGridDiv" name="paytReqDtlTableGridDiv" style="margin: 10px; margin-bottom: 27px;">
			<div id="paytReqDtlTableGrid" style="height: 180px;"></div>
		</div>
		<div style="float:left;">
			<table style="margin: 10px;">
				<tr>
					<td class="rightAligned">Particulars</td>
					<td class="leftAligned">
<%-- 						<span id="acctNameSpan" style="border: 1px solid gray; width: 635px; height: 21px; float: left;"> 
							<input type="text" id="txtParticulars" name="txtParticulars" style="border: none; float: left; width: 96%; background: transparent;" readonly="readonly" /> 
							<img src="${pageContext.request.contextPath}/images/misc/edit.png" id="btnParticulars" name="btnAcctName" alt="Go" style="background: transparent;"/>
						</span> --%>
						<textarea rows="7" cols="90" style="font-family: courier; resize: none;" id="txtParticulars" readonly="readonly"></textarea>
					</td>
				</tr>
			</table>
		</div>
	</div>
	<div align="center">
		<input type="button" class="button" id="btnReturn" value="Return" style="width: 80px;margin-top: 10px; margin-bottom: 10px;">
	</div>
</div>
<script type="text/javascript">
	$("btnReturn").observe("click", function(){
		delete objGIACPaytRequestDtls;
		delete tbgGIACPaytRequestDtls;
		overlayGIACPaytReqDtls.close();
		delete overlayGIACPaytReqDtls;
	});	
	
	var objGIACPaytRequestDtls = JSON.parse('${jsonPaytReqDetails}');
	var paytReqDtlsModel = {	
		url: contextPath+"/GIACPaytRequestDtlController?action=getGICLS032GIACPaytRequestDtlList&refresh=1&claimId="+objCLMGlobal.claimId+"&adviceId="+objGICLS032.objCurrGICLAdvice.adviceId,
		options:{
			hideColumnChildTitle: true,
			width: '725px',
			toolbar: {
				elements: [MyTableGrid.FILTER_BTN, MyTableGrid.REFRESH_BTN]
			},
			onCellFocus: function(element, value, x, y, id){
				var mtgId = tbgGIACPaytRequestDtls._mtgId;							
				if($('mtgRow'+mtgId+'_'+y).hasClassName("selectedRow")){
					$("txtParticulars").value = unescapeHTML2(tbgGIACPaytRequestDtls.geniisysRows[y].particulars);					
				}
				tbgGIACPaytRequestDtls.keys.removeFocus(tbgGIACPaytRequestDtls.keys._nCurrentFocus, true);
				tbgGIACPaytRequestDtls.keys.releaseKeys();
			},
			onRemoveRowFocus: function(element, value, x, y, id){
				$("txtParticulars").value = "";
			},
			onSort : function(){
				$("txtParticulars").value = "";
			},
			onRefresh:function(){
				$("txtParticulars").value = "";
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
			{	id: 'csrNo',
				title: 'CSR No.',
				width: '250px'				
			},
			{	id: 'payeeClassCd payeeCd payee',
				title: 'Payee',
				width: '290px',
				children : [
				            {
								id : "payeeClassCd",
								width: 30,
								align: 'right'
				            },
				            {
								id : "payeeCd",
								width: 60,
								align: 'right'
				            },
				            {
								id : "payee",
								width: 190
				            }
				            ]
			},
			{	id: 'paytAmt',
				title: 'Disbursement Amount',
				width: '160px',
				geniisysClass: 'money',
				align: 'right',
				titleAlign: 'right',
				filterOption: true,
				filterOptionType: 'number'
			}
		],
		rows: objGIACPaytRequestDtls.rows
	};
	
	tbgGIACPaytRequestDtls = new MyTableGrid(paytReqDtlsModel);
	tbgGIACPaytRequestDtls.pager = objGIACPaytRequestDtls;
	tbgGIACPaytRequestDtls.render('paytReqDtlTableGrid');
	
</script>