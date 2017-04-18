 <%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="ajax" uri="http://ajaxtags.org/tags/ajax" %>
<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %> 
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json" %>
<%
	response.setHeader("Cache-control", "No-Cache");
	response.setHeader("Pragma", "No-Cache");
%>

<div id="mortgageeMainDiv" name="mortgageeMainDiv">
	<div id="mortgageeTableGridDiv" align="center">
		<div id="mortgageeGridDiv" style="height: 330px; margin-top: 5px;">
			<div id="mortgageeTableGrid" style="height: 306px; width: 580px;"></div>
		</div>
		<div class="buttonsDiv" align="center" style="margin-bottom: 5px;">
			<input type="button" id="btnOk" name="btnOk" style="width: 120px;" class="button hover" value="Return" />
		</div>
	</div>
</div>

<script type="text/javascript">
	try {
		objCLM.objClaimListTableGrid = JSON.parse('${giclMortgagee}'.replace(/\\/g, '\\\\'));
		objCLM.objClaimList = objCLM.objClaimListTableGrid.rows || [];
 
		var claimsTableModel = {
				url: contextPath+"/GICLMortgageeController?action=getMortgageeGrid2&itemNo=0&claimId=" + objCLMGlobal.claimId +"&refresh=1",
				options:{
					title: '',
					width: '580px',
					toolbar: {
						
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
							
					{
						id: 'mortgCd',
						title: 'Code',
						width: '120px',
						sortable: true,
						align: 'left',
						visible: true
					},	
	
					{
						id: 'nbtMortgNm',
						title: 'Mortgagee',
						width: '310px',
						sortable: true,
						align: 'left',
						visible: true
					},	
							
					{
						id: 'amount',
						title: 'Amount',
						width: '138px',
						sortable: true,
						align: 'right',
						geniisysClass: "money",
						visible: true
					},
				],
				resetChangeTag: true,
				rows: objCLM.objClaimList
		};
	
		claimsListTableGrid = new MyTableGrid(claimsTableModel);
		claimsListTableGrid.pager = objCLM.objClaimListTableGrid;
		claimsListTableGrid.render('mortgageeTableGrid');
			
	} catch(e){
		showErrorMessage("mortgageeInfo.jsp", e);
	}

	$("btnOk").observe("click", function(){
		Windows.close("modal_dialog_lov");
	});
		
</script>