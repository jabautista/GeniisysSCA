<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json"%>
<%
	response.setHeader("Cache-Control", "no-cache");
	response.setHeader("Pragma","no-cache");
%>

<div id="basicInfoListingMainDiv" name="basicInfoListingMainDiv">
	<div id="basicInfoTableGridDiv" align="center">
		<div id="basicInfoGridDiv" style="height: 325px; margin: auto; margin-top: 5px;">
			<div id="basicInfoTableGrid" style="margin: auto; height: 306px; width: 560px;"></div>
		</div>
		<div class="buttonsDiv" align="center" style="margin-bottom: 5px;">
			<input type="button" id="btnOk" name="btnOk" style="width: 90px;" class="button hover"   value="Ok" />
			<input type="button" id="btnCancel" name="btnCancel" style="width: 90px;" class="button hover"   value="Cancel" />
		</div>
	</div>
</div>

<script type="text/javascript">
	try {
		//var objCLM = new Object();
		var id = null;
		var desc = null;
		var row = null;
		objCLM.objClaimListTableGrid = JSON.parse('${claimsListTableGrid}'.replace(/\\/g, '\\\\'));
		objCLM.objClaimList = objCLM.objClaimListTableGrid.rows || [];
		
		var claimsTableModel = {
				url: contextPath+"/GICLClaimsController?action=refreshBasicInfoPopupListing&lineCd=" + $F("txtClmLineCd") + "&polIssCd=" +$F("txtPolIssCd") + "&lovSelected=" + objCLM.lovSelected + "&provinceCd=" + nvl(objCLM.basicInfo.provinceCode,"") 
																								+ "&sublineCd=" + $F("txtSublineCd") + "&renewNo=" + $F("txtRenewNo") + "&issueYy=" + $F("txtIssueYy") + "&cityCd=" + $F("txtCityCd") + "&districtNo=" + $F("txtDistrictNo"),
				options:{
					title: '',
					width: '560px',
					onRowDoubleClick: function(y){
						row = claimsListTableGrid.geniisysRows[y];
						setSelectedRow(row);
					},
					onCellFocus: function(element, value, x, y, id){
						var mtgId = claimsListTableGrid._mtgId;
						row = claimsListTableGrid.geniisysRows[y];
					},
					onRemoveRowFocus: function ( x, y, element) {
						row = null;
					},
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
						id: 'id',
						title: objCLM.idText,
						width: '150px',
						sortable: false,
						align: 'left',
						visible: true
					},	

					{
						id: 'desc',
						title: objCLM.desc,
						width: '400px',
						sortable: false,
						align: 'left',
						visible: true
					},			
	
				],
				resetChangeTag: true,
				rows: objCLM.objClaimList
		};
	
		claimsListTableGrid = new MyTableGrid(claimsTableModel);
		claimsListTableGrid.pager = objCLM.objClaimListTableGrid;
		claimsListTableGrid.render('basicInfoTableGrid');
			
	} catch(e){
		showErrorMessage("claimListing.jsp", e);
	}

	function setSelectedRow(row){
		if (objCLM.lovSelected == "clmProcessorLov"){ $("txtClmProcessor").focus(); objCLM.basicInfo.inHouseAdjustment = row.id; $("txtClmProcessor").value = row.desc; objCLM.basicInfo.dspInHouAdjName= row.desc;}
		if (objCLM.lovSelected == "clmCatLov"){ $("txtCat").focus(); $("txtCat").value = row.desc; objCLM.basicInfo.dspCatDesc = row.desc; objCLM.basicInfo.catastrophicCode = row.id;}
		if (objCLM.lovSelected == "clmLossCatLov"){ $("txtLossDesc").focus(); $("txtLossId").value = row.id; $("txtLossDesc").value = row.desc; objCLM.basicInfo.lossCatCd = row.id; objCLM.basicInfo.dspLossCatDesc = row.desc;}
		if (objCLM.lovSelected == "clmProvinceLov"){ $("txtProvince").focus(); $("txtProvince").value = row.desc; objCLM.basicInfo.dspProvinceDesc = row.desc; objCLM.basicInfo.provinceCode = row.id;}
		if (objCLM.lovSelected == "clmCityLov"){$("txtCity").focus();  $("txtCityCd").value = row.id; $("txtCity").value = row.desc; if (nvl(objCLM.basicInfo.provinceCode,"") == ""){objCLM.basicInfo.provinceCode = row.provinceCd; $("txtProvince").value = row.provinceDesc; objCLM.basicInfo.dspProvinceDesc = row.provinceDesc;}}
		if (objCLM.lovSelected == "clmClmStatLov"){ $("txtClmStat").focus(); $("txtClmStatCd").value = row.id; $("txtClmStat").value = row.desc;}
		if (objCLM.lovSelected == "clmAssuredLov"){ $("txtAssuredName").focus(); $("txtAssuredNo").value = row.id; $("txtAssuredName").value = row.desc;}
		if (objCLM.lovSelected == "clmPlateNoLov"){ $("txtPlateNumber").focus(); $("txtPlateNumber").value = row.id; $("txtAssuredName").value = row.desc;}
		if (objCLM.lovSelected == "clmMotorNoLov"){ $("txtMotorNumber").focus(); $("txtMotorNumber").value = row.id; $("txtAssuredName").value = row.desc;}
		if (objCLM.lovSelected == "clmSerialNoLov"){ $("txtSerialNumber").focus(); $("txtSerialNumber").value = row.id; $("txtAssuredName").value = row.desc;}
		if (objCLM.lovSelected == "clmDistrictLov"){ $("txtDistrictNo").value = row.id; if (nvl(objCLM.basicInfo.provinceCode,"") == "") {objCLM.basicInfo.provinceCode = row.provinceCd; $("txtProvince").value = row.provinceDesc; objCLM.basicInfo.dspProvinceDesc = row.provinceDesc;} if ($F("txtCityCd") == "") {$("txtCityCd").value = row.cityCd; $("txtCity").value = row.cityDesc;}}
		if (objCLM.lovSelected == "clmBlockLov"){ $("txtBlockNo").value = row.id; if (nvl(objCLM.basicInfo.provinceCode,"") == "") {objCLM.basicInfo.provinceCode = row.provinceCd; $("txtProvince").value = row.provinceDesc; objCLM.basicInfo.dspProvinceDesc = row.provinceDesc;} if ($F("txtCityCd") == "") {$("txtCityCd").value = row.cityCd; $("txtCity").value = row.cityDesc;} if ($F("txtDistrictNo") == ""){$("txtDistrictNo").value = row.districtNo;}}
		if (objCLM.lovSelected == "clmPayee"){ $("txtAdjCompany").focus(); $("txtAdjCompany").value = row.desc; $("txtAdjCompanyCd").value = row.id;}
		if (objCLM.lovSelected == "clmPayee2"){ $("txtAdjuster").focus(); $("txtAdjuster").value = row.desc; $("txtPrivAdjCd").value = row.id;}
		Windows.close("modal_dialog_lov2");
	}
	
	$("btnCancel").observe("click", function (){
		if (objCLM.lovSelected == "clmProcessorLov"){  $("txtClmProcessor").focus();}
		if (objCLM.lovSelected == "clmCatLov"){ $("txtCat").focus();}
		if (objCLM.lovSelected == "clmLossCatLov"){ $("txtLossDesc").focus();}
		if (objCLM.lovSelected == "clmProvinceLov"){ $("txtProvince").focus();}
		if (objCLM.lovSelected == "clmCityLov"){ $("txtCity").focus();} 
		if (objCLM.lovSelected == "clmClmStatLov"){ $("txtClmStat").focus();}
		if (objCLM.lovSelected == "clmAssuredLov"){ $("txtAssuredName").focus();}
		if (objCLM.lovSelected == "clmPlateNoLov"){ $("txtPlateNumber").focus();}
		if (objCLM.lovSelected == "clmMotorNoLov"){ $("txtMotorNumber").focus();}
		if (objCLM.lovSelected == "clmSerialNoLov"){ $("txtSerialNumber").focus();}
		if (objCLM.lovSelected == "clmPayee"){ $("txtAdjCompany").focus();}
		if (objCLM.lovSelected == "clmPayee2"){ $("txtAdjuster").focus();}
		Windows.close("modal_dialog_lov2");
	});

	$("btnOk").observe("click", function () {
		setSelectedRow(row);
	});
	
	hideNotice("");
</script>