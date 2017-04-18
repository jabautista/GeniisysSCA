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

<jsp:include page="/pages/common/utils/overlayTitleHeader.jsp"></jsp:include>
<div id="cargoClassDiv" style="margin: 10px;">
	<form id="selectCargoClassForm" name="selectCargoClassForm">
		<div style="width: 100%;">
			<div class="toolbar" style="margin-top: 22px;" id="toolbar" name="toolbar">
				<span style="display: none;">
				<!-- <label style="float: right; margin-right: 2px;" id="okSelected" name="okSelected">Ok</label>  -->
				</span>
			</div>
		</div>   
		<div id="cargoClassListDiv" style="overflow-x: scroll; margin-left: 5px; min-height: 240px; max-height: 240px;">
			<div id="cargoTableHeader" class="tableHeader" style="min-width: 100%;">
				<label style="text-align: left; margin-left: 3px;" name="lblHeader">CargoClass</label>
			</div>
			<div id="cargoTableDiv" name="cargoTableDiv" style="white-space: nowrap;" class="tableContainer"></div>
		</div>
	</form>
	<div class="buttonsDiv" style="margin-top: 4px; margin-bottom: 10px;">
		<input type="button" class="button" id="okSelected" name="okSelected" value="OK" style="width: 80px;" />
	</div>
</div>

<script type="text/javascript">
	var cargoObjArr = JSON.parse('${classes}'.replace(/\\/g, '\\\\'));
	var cargoCd = "";
	var cargoDesc = "";

	for(var i=0; i<cargoObjArr.length; i++) {
		var exists = false;
		$$("div#cargoClassDiv div[name='rowCargo']").each(function(row){
			if(row.down("input", 0).value == cargoObjArr[i].cargoClassCd) {
				exists = true;
			}
		});
		if(!exists) {
			var content = prepareCargoList(cargoObjArr[i]);
			
			var newRow = new Element("div");
			newRow.setAttribute("id", 	"cargoRow" + cargoObjArr[i].cargoClassCd);
			newRow.setAttribute("name", "cargoRow");
			newRow.setAttribute("class","tableRow");
			newRow.setStyle("overflow", "visible");
			newRow.setStyle({fontSize: '9px'});
	
			newRow.update(content);
			$("cargoTableDiv").insert({bottom:newRow});
	
			checkIfToResizeTable("cargoClassListDiv", "cargoRow");
			checkTableIfEmpty("cargoRow", "cargoClassListDiv");
			setCargoTableWidth();
		}
	}

	function setCargoTableWidth() {
		var maxWidth = 100;
		$$("div[name='cargoRow']").each(function(row) {
			var curRow = document.getElementById("cargoLbl"+row.down("input", 0).value).offsetWidth;
			if(maxWidth < curRow) {
				maxWidth = parseInt(curRow);
			}
		});
		if(600 > maxWidth) {
			maxWidth = 600;
		}
		$("cargoTableHeader").style.width = maxWidth + "px";
		$("cargoTableDiv").style.width = maxWidth + "px";
	}	

	function prepareCargoList(obj) {
		var content = 	'<input type="hidden" id="cargoCd"'+ obj.cargoClassCd +' name="cargoClasscd" value='+ obj.cargoClassCd +'>' + 
						'<label style="text-align: left;" id="cargoLbl'+ obj.cargoClassCd +'" name="cargoLbl">'+ obj.cargoClassDesc +'</label>';
		return content;
	}

	$$("div[name='cargoRow']").each(function (row) {
		row.observe("mouseover", function ()	{
			row.addClassName("lightblue");
		});
		
		row.observe("mouseout", function ()	{
			row.removeClassName("lightblue");
		});

		row.observe("dblclick", function() {
			loadSelectedCargo();
		});

		row.observe("click", function () {
			row.toggleClassName("selectedRow");
			if (row.hasClassName("selectedRow"))	{
				$$("div[name='cargoRow']").each(function (r)	{
					if (row.getAttribute("id") != r.getAttribute("id"))	{
						r.removeClassName("selectedRow");
						itemSelected = 0;
					}
				});
			}
			var temp = row.down("input", 0).value;
			for(var i=0; i<cargoObjArr.length; i++) {
				if(temp == cargoObjArr[i].cargoClassCd) {
					cargoCd = cargoObjArr[i].cargoClassCd;
					cargoDesc = cargoObjArr[i].cargoClassDesc;
				}
			}
		});
	});

	$("okSelected").observe("click", function() {
		loadSelectedCargo();
	});

	function loadSelectedCargo() {
		//$("inputCargoClass").value = changeSingleAndDoubleQuotes(cargoDesc).escapeHTML();
		$("inputCargoClass").value = unescapeHTML2(cargoDesc);
		$("inputCargoCd").value = cargoCd;
		hideOverlay();
	}
	
</script>