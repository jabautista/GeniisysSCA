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
<div id="enItemLocationDiv" style="margin-top: 50px;" >
	<form id="locationForm" name="locationForm">
		<div id="locationInfoDiv" style="width: 90%, margin: 10px 0px 5px 0px;">
			<table align="center" width="80%">
				<tr>
					<td class="rightAligned">Region</td>
					<td class="leftAligned">
						<select id="inputRegion" name="inputRegion" style="width: 80%;">
						</select>
					</td>
				</tr>
				<tr>
					<td class="rightAligned">Province</td>
					<td class="leftAligned">
						<select id="inputProvince" name="inputProvince" style="width: 80%;">
						</select>
					</td>
				</tr>
			</table>
		</div>
		<div class="buttonsDiv" id="locationButtonsDiv" style="margin-bottom: 5px; margin-top: 20px;">
			<input type="button" class="button" style="width: 120px;" id="btnAddLocation" name="btnAddLocation" value="Assign Location" />
			<input type="button" class="button" style="width: 120px;" id="btnCancelLocation" name="btnCancelLocation" value="Cancel" />
		</div>
	</form>
</div>

<script type="text/javascript">
	var locType = '${locType}';
	var objRegions = JSON.parse('${regions}'.replace(/\\/g, '\\\\'));
	var objProvinces = JSON.parse('${provinces}'.replace(/\\/g, '\\\\'));

	setRegionListing();
	setProvinceListing();
	
	function setRegionListing() {
		$("inputRegion").update('<option value=""></option>');
		var options= "";
		for(var i=0; i<objRegions.length; i++) {
			options = '<option value="'+ objRegions[i].regionCd +'" >'+ objRegions[i].regionDesc +'</option>';
			$("inputRegion").insert({bottom: options});
		}
		$("inputRegion").selectedIndex = 0;
	}

	function setProvinceListing() {
		$("inputProvince").update('<option value="" regionCd="0"></option>');
		var options = "";
		if($("inputRegion").selectedIndex == 0 || $("inputRegion").value == null) {
			for(var i=0; i<objProvinces.length; i++) {
				options = '<option value="'+ objProvinces[i].provinceCd +'" regionCd="'+ objProvinces[i].regionCd +'">'+ objProvinces[i].provinceDesc +'</option>';
				$("inputProvince").insert({bottom: options});
			}
			$("inputProvince").selectedIndex = 0;
		} else {
			var regCd = $("inputRegion").value;
			for(var i=0; i<objProvinces.length; i++) {
				if(regCd == objProvinces[i].regionCd) {
					options = '<option value="'+ objProvinces[i].provinceCd +'" regionCd="'+ objProvinces[i].regionCd +'">'+ objProvinces[i].provinceDesc +'</option>';
					$("inputProvince").insert({bottom: options});
				}
			}
			$("inputProvince").selectedIndex = 0;
		}
	}

	function setRegionSelected() {
		if ($("inputProvince").selectedIndex > 0 || $F("inputProvince") != null ){
			var provRegion = $("inputProvince").options[$("inputProvince").selectedIndex].getAttribute("regionCd");
			for(var i=0; i<objRegions.length; i++) {
				if(objRegions[i].regionCd == provRegion) {
					$("inputRegion").value = objRegions[i].regionCd;
					$("inputRegion").selectedIndex = i+1;
				}
			}
		} else {
			$("inputRegion").selectedIndex = 0;
		}	
	}

	$("inputRegion").observe("change", function() {
		$("inputProvince").selectedIndex = 0;
		setProvinceListing();
	});

	$("inputProvince").observe("change", function() {
		if($("inputRegion").selectedIndex == 0) {
			setRegionSelected();
		}
	});

	$("btnCancelLocation").observe("click", function() {
		hideOverlay();
	});

	$("btnAddLocation").observe("click", function() {
		try {
			if ($F("inputRegion") == null || $F("inputRegion") == "") {
				showMessageBox("Cannot proceed, please enter region.", imgMessage.ERROR);
			} else if ($F("inputProvince") == null || $F("inputProvince") == "") {
				showMessageBox("Cannot proceed, please enter province.", imgMessage.ERROR);
			} else {
				var itemNum = 0;
				var region = $F("inputRegion");
				var province = $F("inputProvince");
				if (locType == 2) {
					$$("div[name='rowItem']").each(function(item) {
						itemNum = item.down("input", 1).value;
						updateLocInsertDivs(itemNum, region, province);
					});	
				} else if(locType == 1) {
					itemNum = $F("itemNo");  //temporary
					updateLocInsertDivs(itemNum, region, province);
				}
			}
			hideOverlay();
		} catch (e) {
			showErrorMessage("enItemLocation.jsp - btnAddLocation", e);
			//showMessageBox("click AddLocation: " + e.message, imgMessage.ERROR);
		}
	});

	function updateLocInsertDivs(itemNum, region, province) {
		var content = '<input type="hidden" id="locItemNo'+itemNum+'" 	name="locItemNo" 	value="'+itemNum+'"/>' +
					  '<input type="hidden" id="locRegion'+itemNum+'" 	name="locRegion" 	value="'+region+'"/>' +
					  '<input type="hidden" id="locProvince'+itemNum+'" name="locProvince"	value="'+province+'"/>';
		var newDiv = new Element("div");
		newDiv.setAttribute("id", "insLoc"+itemNum);
		newDiv.setAttribute("name", "insLoc");
		newDiv.update(content);

		$("insertLocations").insert({bottom: newDiv});
	}

</script>