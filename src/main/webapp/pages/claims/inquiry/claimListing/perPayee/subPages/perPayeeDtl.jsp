<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld"%>
<%@ taglib prefix="fmt" uri="/WEB-INF/tld/fmt.tld"%>
<%
	response.setHeader("Cache-control", "No-Cache");
	response.setHeader("Pragma", "No-Cache");
%>
<div id="contentsDiv" >
	<div class="sectionDiv" align="center" style="width: 99.5%; margin-top: 2px;">
		<table align="center" style="padding: 15px 0 15px 0;">
			<tr>
				<td class="rightAligned">Claim No.</td>
				<td class="leftAligned" style="padding: 0 0 0 5px;"><input type="text" id="txtClaimNoDtl" name="txtClaimNoDtl" readonly="readonly" style="width: 250px" value="${claimNo}"/></td>
				<td class="rightAligned">Assured</td>
				<td class="leftAligned" style="padding: 0 0 0 5px;"><input type="text" id="txtAssuredDtl" name="txtAssuredDtl" readonly="readonly" style="width: 250px" value="${assured}"/></td>
			</tr>
			<tr>
				<td class="rightAligned" width="100px">Policy No.</td>
				<td class="leftAligned" style="padding: 0 0 0 5px;"><input type="text" id="txtPolicyNoDtl" name="txtPolicyNoDtl" readonly="readonly" style="width: 250px" value="${policyNo}"/></td>
				<td class="rightAligned" width="100px">Loss Date</td>
				<td class="leftAligned" style="padding: 0 0 0 5px;"><input type="text" id="txtLossDateDtl" name="txtLossDateDtl" readonly="readonly" style="width: 250px" value="${lossDate}"/></td>
			</tr>
		</table>
	</div>
	<div class="sectionDiv" style="width: 99.5%">
		<div id="perPayeeDtlTableDiv" style="padding: 10px 0 0 5px;">
			<div id="perPayeeDtlTable" style="height: 250px"></div>
		</div>
		<div style="float: left; width: 100%;">
			<table>
				<tr>
					<td class="rightAligned" style="padding: 0 0 0 5px;">Advice No.</td>
					<td class="leftAligned" style="padding: 0 0 0 5px;"><input type="text" id="txtAdviceNoDtl" name="txtAdviceNoDtl" readonly="readonly" style="width: 250px"/></td>
				</tr>			
			</table>
		</div>
		<div class="buttonDiv"align="center" style="padding: 40px 0 10px 0;">
			<input type="button" id="btnReturn" class="button" value="Return" style="width: 90px;"/>
		</div>
	</div>

</div>
<script>
	initializeAll();
	try {
		var jsonPerPayeeDtl = JSON.parse('${jsonPerPayeeDtl}');
		perPayeeDtlTableModel = {
			url : contextPath+ "/GICLClaimListingInquiryController?action=showPerPayeeDtl&refresh=1&payeeClassCd=" + $F("hidPayeeClassCd") + "&payeeCd=" + $F("hidPayeeCd") + "&claimId=" + $F("hidClaimId"),
			options : {
				hideColumnChildTitle: true,
				width : '820px',
				height : '250px',
				pager : {},
				onCellFocus : function(element, value, x, y, id) {
					var obj = tbgPerPayeeDtl.geniisysRows[y];
					$("txtAdviceNoDtl").value = obj.nbtAdviceNo;
					tbgPerPayeeDtl.keys.releaseKeys();
				},
				prePager : function() {
					$("txtAdviceNoDtl").value = null;
					tbgPerPayeeDtl.keys.releaseKeys();
				},
				onRemoveRowFocus : function(element, value, x, y, id) {
					$("txtAdviceNoDtl").value = null;
					tbgPerPayeeDtl.keys.releaseKeys();
				},
				onSort : function(){
					$("txtAdviceNoDtl").value = null;
					tbgPerPayeeDtl.keys.releaseKeys();
				},
				toolbar : {
					elements : [ MyTableGrid.FILTER_BTN, MyTableGrid.REFRESH_BTN ],
					onFilter : function(){
						$("txtAdviceNoDtl").value = null;
						tbgPerPayeeDtl.keys.releaseKeys();
					},
					onRefresh : function(){
						$("txtAdviceNoDtl").value = null;
						tbgPerPayeeDtl.keys.releaseKeys();
					},
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
			    	id:'itemNo dspItem',
			    	title: 'Item',
			    	width: 150,
			    	titleAlign: 'left',
			    	children: [
			    	   	    {	id: 'itemNo',
						    	width: 20,
						    	align: 'right',
						    	title: 'Item - Item No.',
						    	filterOption: true,	
						    	renderer: function(value){
						    		return nvl(value,'') == '' ? '' :formatNumberDigits(nvl(value, 0),2);
						    	}
						    },
						    {	id: 'dspItem',
						    	width:145,
						    	title: 'Item - Item Description',
						    	filterOption: true,	
						    	align: 'left'
						    }
			    	          ]
			    },
				{
			    	id:'perilCd dspPeril',
			    	title: 'Peril',
			    	width: 150,
			    	titleAlign: 'left',
			    	children: [
			    	   	    {	id: 'perilCd',
						    	width: 20,
						    	align: 'right',
						    	title: 'Peril - Peril Code',
						    	filterOption: true,	
						    	renderer: function(value){
						    		return nvl(value,'') == '' ? '' :formatNumberDigits(nvl(value, 0),2);
						    	}
						    },
						    {	id: 'dspPeril',
						    	width: 145,
						    	title: 'Peril - Peril Description',
						    	filterOption: true,	
						    	align: 'left'
						    }
			    	          ]
			    },
			    {
			    	id:'histSeqNo',
			    	title: 'Hist Seq #',
			    	width: '66px',
			    	align: 'right',
			    	filterOption: true,	
			    	filterOptionType : 'number',
			    	renderer: function(value){
			    		return nvl(value,'') == '' ? '' :formatNumberDigits(nvl(value, 0),2);
			    	}
			    },
			    {
			    	id:'status',
			    	title: 'Status',
			    	width: '100px',
			    	filterOption: true,	
			    	align: 'left'
			    },
			    {
			    	id:'paidAmt',
			    	title: 'Paid Amt',
			    	width: '100px',
			    	align: 'right',
			    	titleAlign: 'right',
			    	filterOption: true,	
			    	filterOptionType : 'number',
			    	renderer: function(value){
			    		return nvl(value,'') == '' ? '0.00' : formatCurrency(nvl(value, 0));
			    	}
			    },
			    {
			    	id:'netAmt',
			    	title: 'Net Amt',
			    	width: '100px',
			    	align: 'right',
			    	titleAlign: 'right',
			    	filterOption: true,	
			    	filterOptionType : 'number',
			    	renderer: function(value){
			    		return nvl(value,'') == '' ? '0.00' : formatCurrency(nvl(value, 0));
			    	}
			    },
			    {
			    	id:'adviceAmt',
			    	title: 'Advice Amt',
			    	width: '100px',
			    	align: 'right',
			    	titleAlign: 'right',
			    	filterOption: true,	
			    	filterOptionType : 'number',
			    	renderer: function(value){
			    		return nvl(value,'') == '' ? '0.00' : formatCurrency(nvl(value, 0));
			    	}
			    }
			],
			rows : jsonPerPayeeDtl.rows
		};
		tbgPerPayeeDtl = new MyTableGrid(perPayeeDtlTableModel);
		tbgPerPayeeDtl.pager = jsonPerPayeeDtl;
		tbgPerPayeeDtl.render('perPayeeDtlTable');
	} catch (e) {
		showErrorMessage("perPayeeTableModel", e);
	}
	
	$("btnReturn").observe("click",function(){
		overlayPerPayeeDtl.close();
	});
</script>