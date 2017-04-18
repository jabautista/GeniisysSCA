<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld"%>
<%@ taglib prefix="fmt" uri="/WEB-INF/tld/fmt.tld"%>
<%
	response.setHeader("Cache-control", "No-Cache");
	response.setHeader("Pragma", "No-Cache");
%>
<div id="contentsDiv" class="sectionDiv" style="width: 600px">
		<div id="riLossTableDiv" style="padding: 5px 5px 5px 5px;">
			<div id="riLossTable" style="height: 190px"></div>
		</div>
		<div style="float: right; width: 100%;">
			<table align="right">
				<tr>
					<td class="rightAligned" style="padding-right: 5px;">Total</td>
					<td class="leftAligned" style="padding-right: 5px;"><input class="rightAligned" type="text" id="txtTotal" name="txtTotal" readonly="readonly" style="width: 140px" value="0.00"/></td>
				</tr>			
			</table>
		</div>
		<div style="float: right; width: 100%;">
			<table align="right">
				<tr>
					<td class="rightAligned" style="padding-right: 5px;">Balance</td>
					<td class="leftAligned" style="padding-right: 5px;"><input class="rightAligned" type="text" id="txtBalance" name="txtBalance" readonly="readonly" style="width: 140px" value="0.00"/></td>
				</tr>			
			</table>
		</div>
	<input type="hidden" id="hidLineCd2" name="hidLineCd2"/> 
	<input type="hidden" id="hidLaYy" name="hidLaYy"/> 
	<input type="hidden" id="hidFlaSeqNo" name="hidFlaSeqNo"/> 
</div>
<div class="buttonDiv sectionDiv" align="center" style="margin-top: 20px; border: none;">
	<input type="button" id="btnReturn" class="button" value="Return" style="width: 90px;"/>
</div>
<script>
initializeAll();
	try {
		var jsonRiOverlay = JSON.parse('${jsonRiOverlay}');
		$("hidLineCd2").value =  jsonRiOverlay.lineCd2 == null ? "" :  jsonRiOverlay.lineCd2;
		$("hidLaYy").value =  jsonRiOverlay.laYy == null ? "" :     jsonRiOverlay.laYy;
		$("hidFlaSeqNo").value =  jsonRiOverlay.flaSeqNo == null ? "" :   jsonRiOverlay.flaSeqNo;
		$("hidMainPageAmt").value = jsonRiOverlay.mainPageAmt == null ? "" :  jsonRiOverlay.mainPageAmt;
		
		OverlayTableModel = {
			url : contextPath+ "/GIACReinsuranceInquiryController?action=showRiLossOverlay&refresh=1" 
			+ "&lineCd2=" + $F("hidLineCd2") + "&laYy=" + $F("hidLaYy") + "&flaSeqNo=" + $F("hidFlaSeqNo") 
			+ "&mainPageAmt="   +  $F("hidMainPageAmt")
			,
			options : {
				width : '587px',
				height : '190px',
				pager : {},
				
				toolbar : {
					
					onRefresh : function(){
						tbgOverlay.keys.releaseKeys();
					},
				}, 
				onSort : function() {
					tbgOverlay.keys.removeFocus(tbgOverlay.keys._nCurrentFocus, true);
					tbgOverlay.keys.releaseKeys();
				}
			},
			columnModel : [ 
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
			    {
			    	id:'tranDate',
			    	title: 'Date',
			    	width: '70px',
			    	align: 'right',
			    	titleAlign: 'center',
			    	filterOption : true
			    },
			    {
			    	id:'refNo',
			    	title: 'Reference Number',
			    	width: '360px',
			    	align: 'left',
			    	filterOption : true
			    },
			    {
			    	id:'collectionAmt',
			    	title: 'Amount',
			    	geniisysClass: 'money',
			    	width: '125px',
			    	align: 'right',
			    	titleAlign: 'right',
			    	filterOption : true
			    }
			    
			],
			rows : jsonRiOverlay.rows
		};
		
		function getTotal() {
			try {
				var rec = tbgOverlay.geniisysRows[0];
				$("txtTotal").value = rec == null ? "" : formatCurrency(rec.totalCollectionAmt);
			} catch (e) {
				showErrorMessage("getTotal", e);
			}
		 }; 
		 
		  function getBalance() {
				try {
					var rec = tbgOverlay.geniisysRows[0];
					var balance;
					if (rec == null){
						balance = "";
					}else{
						balance = jsonRiOverlay.mainPageAmt - rec.totalCollectionAmt ;
					}
					$("txtBalance").value = jsonRiOverlay.mainPageAmt == null ? "" : formatCurrency(balance) ;
				
				} catch (e) {
					showErrorMessage("getBalance", e);
				}
		};  
		
		tbgOverlay = new MyTableGrid(OverlayTableModel);
		tbgOverlay.pager = jsonRiOverlay;
		tbgOverlay.render('riLossTable');
		getTotal();
		getBalance();
		
	} catch (e) {
		showErrorMessage("premiumTableModel", e);
	}
	
	$("btnReturn").observe("click",function(){
		overlayPremiumInfo.close();
	});
	</script>	