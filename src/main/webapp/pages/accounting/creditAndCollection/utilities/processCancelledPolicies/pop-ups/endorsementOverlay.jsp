<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld"%>
<%@ taglib prefix="fmt" uri="/WEB-INF/tld/fmt.tld"%>
<%
	response.setHeader("Cache-control", "No-Cache");
	response.setHeader("Pragma", "No-Cache");
%>
<div id="contentsDiv" >
	<div class="sectionDiv" align="center" style="width: 99.5%;">
		<table align="center" style="padding: 10px 0 10px 0;">
			<tr>
				<td class="rightAligned">Policy</td>
				<td class="leftAligned" style="padding: 0 0 0 5px;"><input type="text" id="txtPolicyNo" name="txtPolicyNo" readonly="readonly" style="width: 350px" value=""/></td>
			</tr>
		</table>
		
	</div>
	<div class="sectionDiv" style="width: 99.5%; margin: 2px 0 15px 0; padding-bottom: 10px;";>
		<div id="endorsementTableDiv" style="padding: 10px 0 0 10px;">
			<div id="endorsementTable" style="height: 260px"></div>
		</div>
	</div>
	<div class="buttonDiv"align="center" style="margin: 8px 0 0 0;">
		<input type="button" id="btnReturn" class="button" value="Return" style="width: 120px;"/>
	</div>
</div>
<script>
	initializeAll();
	$("txtPolicyNo").value = objACGlobal.hidGIACS412Obj.policyNo;
	
	try {
		var jsonEndorsement = JSON.parse('${jsonEndorsement}');
		endorsementTableModel = {
			url : contextPath+ "/GIACCreditAndCollectionUtilitiesController?action=showEndorsement&refresh=1&lineCd=" + objACGlobal.hidGIACS412Obj.lineCd 
																									     + "&sublineCd=" + objACGlobal.hidGIACS412Obj.sublineCd
																									     + "&issCd=" + objACGlobal.hidGIACS412Obj.issCd
																										 + "&issueYy=" + objACGlobal.hidGIACS412Obj.issueYy 
																										 + "&polSeqNo=" + objACGlobal.hidGIACS412Obj.polSeqNo
																										 + "&renewNo=" + objACGlobal.hidGIACS412Obj.renewNo,
			options : {
				width : '810px',
				height : '260px',
				pager : {},
				onCellFocus : function(element, value, x, y, id) {
					tbgEndorsement.keys.releaseKeys();
				},
				prePager : function() {
					tbgEndorsement.keys.releaseKeys();
				},
				onRemoveRowFocus : function(element, value, x, y, id) {
					tbgEndorsement.keys.releaseKeys();
				},
				onSort : function(){
					tbgEndorsement.keys.releaseKeys();
				},
				toolbar : {
					elements : [ MyTableGrid.FILTER_BTN, MyTableGrid.REFRESH_BTN ],
					onFilter : function() {
						tbgEndorsement.keys.releaseKeys();
					},
					onRefresh : function(){
						tbgEndorsement.keys.releaseKeys();
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
			    	id:'endtNo',
			    	title: 'Endorsement No.',
			    	width : '150px',
					filterOption: true
			    	
			    },
				{
			    	id : "effDate",
					title : "Effectivity",
					width : '120px',
					titleAlign : 'center',
					align : 'center',
					filterOption: true,
					filterOptionType : 'formattedDate',
					renderer: function(value){
						return dateFormat(value, "mm-dd-yyyy");
					}
			    },
			    {
			    	id : "endtExpiryDate",
					title : "Expiry",
					width : '120px',
					titleAlign : 'center',
					align : 'center',
					filterOption: true,
					filterOptionType : 'formattedDate',
					renderer: function(value){
						return dateFormat(value, "mm-dd-yyyy");
					}
			    },
			    {
			    	id : "issueDate",
					title : "Issue Date",
					width : '120px',
					titleAlign : 'center',
					align : 'center',
					filterOption: true,
					filterOptionType : 'formattedDate',
					renderer: function(value){
						return dateFormat(value, "mm-dd-yyyy");
					}
			    },
			    {
					id : "tsiAmt",
					title : "TSI Amount",
					titleAlign : 'right',
					align : 'right',
					filterOptionType : 'number',
					width : '140px',
					geniisysClass: 'money',
					filterOption: true
				},
				{
					id : "premAmt",
					title : "Premium Amount",
					titleAlign : 'right',
					align : 'right',
					filterOptionType : 'number',
					width : '140px',
					geniisysClass: 'money',
					filterOption: true
				}
			],
			rows : jsonEndorsement.rows
		};
		tbgEndorsement = new MyTableGrid(endorsementTableModel);
		tbgEndorsement.pager = jsonEndorsement;
		tbgEndorsement.render('endorsementTable');
	} catch (e) {
		showErrorMessage("endorsementTableModel", e);
	}
	
	$("btnReturn").observe("click",function(){
		overlayEndorsement.close();
	});
</script>