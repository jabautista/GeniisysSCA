<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>

<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld"%>
<%
	response.setHeader("Cache-control", "No-Cache");
	response.setHeader("Pragma", "No-Cache");
%>
<c:forEach var="peril" items="${defaultPerils}">
	<div id="perilDiv${peril.perilCd}" name="row3">
		<input type="hidden" id="defaultPerilCd${peril.perilCd}" 	name="defaultPerilCd${peril.perilCd}" 	value="${peril.perilCd}"/>
		<input type="hidden" id="defaultPerilName${peril.perilCd}" 	name="defaultPerilName${peril.perilCd}" value="${peril.perilName}"/>
		<input type="hidden" id="defaultLineCd${peril.perilCd}" 	name="defaultLineCd${peril.perilCd}" 	value="${peril.lineCd}"/>
		<input type="hidden" id="defaultTsi${peril.perilCd}" 		name="defaultTsi${peril.perilCd}" 		value="${peril.defaultTsi}"/>
		<input type="hidden" id="defaultRate${peril.perilCd}" 		name="defaultRate${peril.perilCd}" 		value="${peril.defaultRate}"/>
		<input type="hidden" id="defaultPerilType${peril.perilCd}" 	name="defaultPerilType${peril.perilCd}" value="${peril.perilType}"/>
	</div>
</c:forEach>

<script type="text/javaScript">
initializeAccordion();
addStyleToInputs();
initializeAll();
initializeAllMoneyFields();
deleteItemPerilsForItemNo($F("itemNo"));

/*$$("div#itemPerilMotherDiv"+$F("itemNo")+" div[name='row2']").each(function(row){
	$("perilCd").value = row.getAttribute("peril");
	Effect.Fade(row, {
		duration: .001,
		afterFinish: function (){
			prepareItemPerilforDelete(1);
			row.remove();
			clearItemPerilFields();
			checkPerilTableIfEmpty("row2", "itemPerilMotherDiv"+$F("itemNo"), "itemPerilMainDiv");
			checkIfToResizePerilTable("itemPerilMainDiv", "itemPerilMotherDiv"+$F("itemNo"), "row2");
			hideAllItemPerilOptions();
			selectItemPerilOptionsToShow();
			hideExistingItemPerilOptions();
			getTotalAmounts();
			$("deleteTag").value = "N";
		}
	});
});*/

$("itemPerilMotherDiv"+$F("itemNo")).innerHTML = "";

$$("div[name='row3']").each(function(a){
	var itemNoOfPeril 	= $F("itemNo");
	var perilCd 		= a.getAttribute("id").substring(8);
	var lineCd 			= $F("defaultLineCd"+perilCd);
	var perilName 		= $F("defaultPerilName"+perilCd);
	var perilRate 		= formatToNineDecimal(parseFloat($F("defaultRate"+perilCd)));
	var tsiAmt 			= formatCurrency($F("defaultTsi"+perilCd));
	var prorateFlag 	= parseFloat($F("prorateFlag"));
	var premAmt 		= 0;
	var perilType		= $F("defaultPerilType"+perilCd);
	

	switch (prorateFlag) {
	case 1: 
		var diff = subtractDatesAddTwelve();
		premAmt = formatCurrency((parseInt($F("days"))/diff) * ((parseFloat(perilRate)/100) * parseFloat(tsiAmt)));
		break;
	case 2:
		premAmt = formatCurrency(parseFloat(tsiAmt) * (parseFloat(perilRate)/100));
		break;
	case 3:
		premAmt = formatCurrency(parseFloat(tsiAmt) * (parseFloat(perilRate)/100) * parseFloat($F("shortRatePercent")));
		break;
	default:
		premAmt = formatCurrency(parseFloat(tsiAmt) * (parseFloat(perilRate)/100));
	}
	var compRem = "---";

	var itemPerilTable = $("parItemPerilTable");
	var itemPerilMotherDiv = $("itemPerilMotherDiv"+itemNoOfPeril);
	var isNew = false;
	if (itemPerilMotherDiv == undefined)	{
		isNew = true;
		itemPerilMotherDiv = new Element("div");
		itemPerilMotherDiv.setAttribute("id", "itemPerilMotherDiv"+itemNoOfPeril);
		itemPerilMotherDiv.setAttribute("name", "itemPerilMotherDiv");
	}

	var newDiv = new Element("div");
	newDiv.setAttribute("id", "rowPeril"+itemNoOfPeril+perilCd);
	newDiv.setAttribute("name", "row2");
	newDiv.setAttribute("item", itemNoOfPeril);
	newDiv.setAttribute("peril", perilCd);
	newDiv.addClassName("tableRow");
	newDiv.setStyle("display: none;");
	newDiv.update(
			'<label name="text" style="width: 5%; text-align: right; margin-right: 5px;" labelName="itemNo">'+itemNoOfPeril+'</label>'+
			'<label name="text" style="width: 20%; text-align: left; margin-left: 5px;">'+perilName+'</label>'+
			'<label name="text" style="width: 15%; text-align: right;" class="moneyRate">'+perilRate+'</label>'+
			'<label name="text" style="width: 15%; text-align: right; margin-left: 5px;" class="money">'+tsiAmt+'</label>'+
			'<label name="text" style="width: 15%; text-align: right; margin-left: 5px;" class="money">'+premAmt+'</label>'+
			'<label name="text" style="width: 15%; text-align: left; margin-left: 10px;margin-right: 10px;">'+compRem+'</label>'+
			'<label style="width: 3%; text-align: right;"><span style="float: right; width: 10px; height: 10px;">-</span>'+ "</label>" +
			'<label style="width: 3%; text-align: right;"><span style="float: right; width: 10px; height: 10px;">-</span>'+ "</label>" +
			'<label style="width: 3%; text-align: right;"><span style="float: right; width: 10px; height: 10px;">-</span>'+ "</label>" +
			'<input type="hidden" name="perilItemNos"		value="'+itemNoOfPeril+'" />'+
			'<input type="hidden" name="perilLineCds"		value="'+lineCd+'" />'+
			'<input type="hidden" name="perilPerilNames" 	value="'+perilName+'" />'+
			'<input type="hidden" name="perilPerilCds" 		value="'+perilCd+'" />'+
			'<input type="hidden" name="perilPremRts" 		class="moneyRate" 	value="'+perilRate+'" />'+
			'<input type="hidden" name="perilTsiAmts" 		class="money" 		value="'+tsiAmt+'" />'+
			'<input type="hidden" name="perilPremAmts" 		class="money" 		value="'+premAmt+'" />'+
			'<input type="hidden" name="perilCompRems" 		value="'+compRem+'" />'+
			'<input type="hidden" name="perilPerilTypes"	value="'+perilType+'" />'+
			'<input type="hidden" name="perilWcSws"			value="" />'+
			'<input type="hidden" name="perilTarfCds" 		value="" />'+
			'<input type="hidden" name="perilAnnTsiAmts" 	value="" />'+
			'<input type="hidden" name="perilAnnPremAmts" 	value="" />'+
			'<input type="hidden" name="perilPrtFlags" 		value="" />'+
			'<input type="hidden" name="perilRiCommRates" 	value="" />'+
			'<input type="hidden" name="perilRiCommAmts" 	value="" />'+
			'<input type="hidden" name="perilSurchargeSws" 	value="" />'+
			'<input type="hidden" name="perilBaseAmts" 		value="" />'+
			'<input type="hidden" name="perilAggregateSws" 	value="" />'+
			'<input type="hidden" name="perilDiscountSws" 	value="" />'+
			'<input type="hidden" name="perilBascPerlCds" 	value="" />'+
			'<input type="hidden" name="perilBaseAmts" 		value="" />'+
			'<input type="hidden" name="perilNoOfDayss" 	value="" />'
		);
	itemPerilMotherDiv.insert({bottom: newDiv});

	if (isNew)	{
		itemPerilTable.insert({bottom: itemPerilMotherDiv});
	}
	initializePerilRow(newDiv);
	Effect.Appear("rowPeril"+itemNoOfPeril+perilCd, {
		duration: .2,
		afterFinish: function () {
			hideAllItemPerilOptions();
			selectItemPerilOptionsToShow();
			hideExistingItemPerilOptions();
			clearItemPerilFields();
			checkIfToResizePerilTable("itemPerilMainDiv", "itemPerilMotherDiv"+$F("itemNo"), "row2");
			getTotalAmounts();
		}
	});
});

getTotalAmounts();

$("tempPerilItemNos").value = updateTempStorage($F("tempPerilItemNos").blank() ? "" :  $F("tempPerilItemNos"), $F("itemNo"));
//saveWItemPerilPageChanges(1);
showMessageBox("CREATING PERILS SUCCESSFUL.", "info");
</script>