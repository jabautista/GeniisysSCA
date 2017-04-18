// used to handle IE6
function initializeAll()	{
	$$("input[type='text'], input[type='password'], textarea, select").each(
		function (obj)	{
			obj.observe("focus", function () {
				if (obj.next() != null && obj.next().hasAttribute("id") && obj.next().hasAttribute("alt") && (obj.next().readAttribute("id").toUpperCase().match("DATE") || obj.next().readAttribute("id").toUpperCase().match("GO") || obj.next().readAttribute("alt").toUpperCase().match("GO") || obj.next().readAttribute("alt").toUpperCase().match("EDIT"))) {
					obj.up().setStyle("border: 1px solid silver;");
					if (obj.hasClassName("required")) {
						obj.up().setStyle("background-color: cornsilk;");
					}					
					if(obj.up().readAttribute("removeStyle") == "true"){
						obj.up().setStyle("border: 0;");
					}					
				} else if (obj.getAttribute("removeStyle") != "true" ) { //added by steven 10/01/2012
					obj.setStyle("border: 1px solid silver;");
				}
				hideCalendar(obj.id);
			});
			
			obj.observe("blur", function ()	{
				if (obj.next() != null && obj.next().hasAttribute("id") && obj.next().hasAttribute("alt") && (obj.next().readAttribute("id").toUpperCase().match("DATE") || obj.next().readAttribute("id").toUpperCase().match("GO") || obj.next().readAttribute("alt").toUpperCase().match("GO") || obj.next().readAttribute("alt").toUpperCase().match("EDIT"))) {
					obj.up().setStyle("border: 1px solid gray;");
					if (obj.hasClassName("required")) {
						obj.up().setStyle("background-color: cornsilk;");
					}
					if(obj.up().readAttribute("removeStyle") == "true"){
						obj.up().setStyle("border: 0;");
					}
				} else if (obj.getAttribute("removeStyle") != "true" ) { //added by steven 10/01/2012
					obj.setStyle("border: 1px solid gray;");
				}
			});
			
			// mark jm 04.09.2011
			// clear the field with delete key
			obj.observe("keyup", function(event){
				if(obj.next() != null && obj.next().hasAttribute("id") && obj.next().hasAttribute("alt") && (obj.next().readAttribute("id").toUpperCase().match("DATE") || obj.next().readAttribute("id").toUpperCase().match("GO") || obj.next().readAttribute("alt").toUpperCase().match("GO") || obj.next().readAttribute("alt").toUpperCase().match("EDIT"))){
					if(event.keyCode == 46){
						if(obj.hasAttribute("ignoreDelKey")) //pol cruz 9.4.2013. ignores del key to avoid clearing of fields
							return;
						obj.value = "";
					}
				}
			});
		}
	);
	
	/// for whole numbers, automatically deletes all characters. Automatically puts comma on input. does not allow negative and decimal value 
	$$("input[type='text'].wholeNumber, input[type='hidden'].wholeNumber").each(function (m) {
		m.observe("focus", function ()	{
			m.select();
			m.value = (m.value).replace(/,/g, "");
		});

		m.observe("blur", function ()	{
			if (isNaN(m.value.replace(/,/g, "")) || m.value.blank() ){ //|| formatCurrency(m.value) < 0) { //nok - comment ko ito..nag e-error hindi na nya mabasa ung ibang trigger kasi dito palang naka blank na.tanong nyo sakin kung ibabalik nio
				m.value = "";
			}
			m.value = (m.value == 0 ? "" :formatNumber(m.value));
			
		});
		
		m.observe("keyup", function () {
			m.value = m.value.strip();
			m.value = (m.value == 0 ? "" :formatNumber(m.value));
		});
	
		m.value = (m.value == 0 ? "" :formatNumber(m.value));
	});
	
	/**
	 * for whole positive/negative numbers, automatically deletes all invalid characters. 
	 * Automatically format the number on blur
	 * Does not allow decimal value
	 * Display Error Message if error occur, just create an attribute named 'errorMsg' (optional)
	 * Ex. <input type="text" class="integer" errorMsg="Input value is invalid!." />
	 * @author Jerome Orio
	 */
	$$("input[type='text'].integer, input[type='hidden'].integer").each(function (m) {
		m.setStyle("text-align:"+m.getStyle("text-align")=="" || m.getStyle("text-align") == null ? "right" :m.getStyle("text-align")+";");
		m.observe("focus", function ()	{
			m.select();
			m.value = (m.value).replace(/,/g, "");
		});
		
		m.observe("keyup", function (e)	{
			m.value = m.value.strip();
			var error = false;
			for(i=0;i<1;){
				if (m.value.indexOf(",,") == -1){
					i++;
				} else{
					m.value = m.value.substring(m.value.indexOf(",,"),"");
					error = true;
				}	
			}
			for(i=0;i<1;){
				if (m.value.indexOf(".") == -1){
					i++;
				} else{
					m.value = m.value.substring(m.value.indexOf("."),"");
					error = true;
				}	
			}
			if (e.keyCode == 109 && m.value.length == 1){
				return true;
			} else{	
				for(i=0;i<1;){
					if (isNaN(parseInt(m.value.replace(/,/g, "") * 1))) {
						m.value = m.value.substring(m.value.length-1,"");
						error = true;
					}else{
						i++;
					}	
				}
			}
			if (error){
				if (m.getAttribute("errorMsg")){
					m.blur();
					showMessageBox(m.getAttribute("errorMsg"), imgMessage.ERROR);
				}
			}
		});
		m.observe("blur", function (e)	{
			if (isNaN(parseInt(m.value.replace(/,/g, "") * 1))) {
				m.value = "";
				if (m.getAttribute("errorMsg")){
					showMessageBox(m.getAttribute("errorMsg"), imgMessage.ERROR);
				}
			}else{
				m.value = (m.value == "" ? "" :formatNumber(m.value.replace(/,/g, "")*1));
			}	
		});
	});
	
	
	/**
	 * for whole positive numbers, automatically deletes all invalid characters. 
	 * Automatically format the number on blur
	 * Does not allow decimal value and negative value
	 * Display Error Message if error occur, just create an attribute named 'errorMsg' (optional)
	 * Ex. <input type="text" class="integerNoNegative" errorMsg="Input value is invalid!." />
	 * @author Jerome Orio
	 */
	$$("input[type='text'].integerNoNegative, input[type='hidden'].integerNoNegative").each(function (m) {
		m.setStyle("text-align:"+m.getStyle("text-align")=="" || m.getStyle("text-align") == null ? "right" :m.getStyle("text-align")+";");
		m.observe("focus", function ()	{
			m.select();
			m.value = (m.value).replace(/,/g, "");
		});
		
		m.observe("keyup", function (e)	{
			m.value = m.value.strip();
			var error = false;
			for(i=0;i<1;){
				if (m.value.indexOf(",,") == -1){
					i++;
				} else{
					m.value = m.value.substring(m.value.indexOf(",,"),"");
					error = true;
				}	
			}
			for(i=0;i<1;){
				if (m.value.indexOf(".") == -1){
					i++;
				} else{
					m.value = m.value.substring(m.value.indexOf("."),"");
					error = true;
				}	
			}
			for(i=0;i<1;){
				if (isNaN(parseInt(m.value.replace(/,/g, "") * 1))) {
					m.value = m.value.substring(m.value.length-1,"");
					error = true;
				} else{
					i++;
				}	
			}
			for(i=0;i<1;){
				if (m.value.indexOf("-") == -1){
					i++;
				} else{
					m.value = m.value.substring(m.value.indexOf("-"),"");
					error = true;
				}	
			}
			if (error){
				if (m.getAttribute("errorMsg")){
					m.blur();
					showMessageBox(m.getAttribute("errorMsg"), imgMessage.ERROR);
				}
			}	
		});
		m.observe("blur", function (e)	{
			if (isNaN(parseInt(m.value.replace(/,/g, "") * 1))) {
				m.value = "";
				if (m.getAttribute("errorMsg")){
					showMessageBox(m.getAttribute("errorMsg"), imgMessage.ERROR);
				}
			} else if (m.value.indexOf("-") != -1){
				m.value = "";
				if (m.getAttribute("errorMsg")){
					showMessageBox(m.getAttribute("errorMsg"), imgMessage.ERROR);
				}
			}else{
				m.value = (m.value == "" ? "" :formatNumber(m.value.replace(/,/g, "")*1));
				if(m.getAttribute("lpad")){ //added by steven 03.13.2014; if you want to use lpad.
					m.value = m.value.trim() == "" ? "" : lpad(m.value,parseInt(m.getAttribute("lpad")),'0');
				}
			}	
		});	
	});
	
	/**
	 * for whole positive/negative numbers, automatically deletes all invalid characters. 
	 * With no format on blur
	 * Does not allow decimal value
	 * Display Error Message if error occur, just create an attribute named 'errorMsg' (optional)
	 * Ex. <input type="text" class="integerUnformatted" errorMsg="Input value is invalid!." />
	 * @author Jerome Orio
	 */
	$$("input[type='text'].integerUnformatted, input[type='hidden'].integerUnformatted").each(function (m) {
		m.setStyle("text-align:"+m.getStyle("text-align")=="" || m.getStyle("text-align") == null ? "right" :m.getStyle("text-align")+";");
		m.observe("focus", function ()	{
			m.select();
			m.value = (m.value).replace(/,/g, "");
		});
		
		m.observe("keyup", function (e)	{
			m.value = m.value.strip();
			var error = false;
			for(i=0;i<1;){
				if (m.value.indexOf(",,") == -1){
					i++;
				} else{
					m.value = m.value.substring(m.value.indexOf(",,"),"");
					error = true;
				}	
			}
			for(i=0;i<1;){
				if (m.value.indexOf(".") == -1){
					i++;
				} else{
					m.value = m.value.substring(m.value.indexOf("."),"");
					error = true;
				}	
			}
			if (e.keyCode == 109 && m.value.length == 1){
				return true;
			} else{	
				for(i=0;i<1;){
					if (isNaN(parseInt(m.value.replace(/,/g, "") * 1))) {
						m.value = m.value.substring(m.value.length-1,"");
						error = true;
					} else{
						i++;
					}	
				}
			}
			if (error){
				if (m.getAttribute("errorMsg")){
					m.blur();
					showMessageBox(m.getAttribute("errorMsg"), imgMessage.ERROR);
				}
			}
		});
		m.observe("blur", function (e)	{
			if (isNaN(parseInt(m.value.replace(/,/g, "") * 1))) {
				m.value = "";
				if (m.getAttribute("errorMsg")){
					showMessageBox(m.getAttribute("errorMsg"), imgMessage.ERROR);
				}
			}else{				
				m.value = m.value.replace(/,/g, "");	
				if(m.getAttribute("lpad")){ //added by steven 05.03.2013; if you want to use lpad.
					m.value = m.value.trim() == "" ? "" : lpad(m.value,parseInt(m.getAttribute("lpad")),'0');
				}
			}	
		});
	});
	
	/*	Created by	: mark jm 10.14.2010
	 * 	Description	: Allows only positive and negative numbers without comma and decimal point
	 * 				: Removes regular and special characters
	 * 				: Prompt message on blur
	 */
	$$("input[type='text'].integerUnformattedOnBlur").each(function(m){
		m.setStyle("text-align: " + 
			(m.getStyle("text-align") == "" || m.getStyle("text-align") == null) ? "right" : m.getStyle("text-align") + ";");
		
		m.observe("focus", function(){
			m.select();
			m.value = (m.value).replace(/,/g, "");
		});
		
		m.observe("keyup", function(e){
			var key = String.fromCharCode(e.which); 
			if(isNaN(key) || key == " "){				
				var val = m.value.strip();
				var temp = "";
				
				for(var i=0, length=(m.value).length; i < length; i++){
					if(!(isNaN(val[i]))){
						temp += val[i];
					}else if(i == 0 && val[i] == "-"){
						temp += val[i];
					}
				}				
				m.value = temp;										
			}			
		});
		
		m.observe("blur", function(e){
			if(!((m.value).empty())){
				if(isNaN(parseInt((m.value).replace(/,/g, "")))){
					m.value = "";
					customShowMessageBox(m.getAttribute("errorMsg"), imgMessage.ERROR, m.id);
				}else{
					if(parseInt(m.value) < parseInt(m.getAttribute("min"))){
						customShowMessageBox(m.getAttribute("errorMsg"), imgMessage.ERROR, m.id);
					}else if(parseInt(m.value) > parseInt(m.getAttribute("max"))){
						customShowMessageBox(m.getAttribute("errorMsg"), imgMessage.ERROR, m.id);
					}else{
						m.value = removeLeadingZero((m.value).replace(/,/g, ""));
					}
				}
			}			
		});
	});
	
	/**
	 * for whole positive numbers, automatically deletes all invalid characters. 
	 * With no format on blur
	 * Does not allow decimal value and negative value
	 * Display Error Message if error occur, just create an attribute named 'errorMsg' (optional)
	 * Ex. <input type="text" class="integerNoNegativeUnformatted" errorMsg="Input value is invalid!." />
	 * @author Jerome Orio
	 */
	$$("input[type='text'].integerNoNegativeUnformatted, input[type='hidden'].integerNoNegativeUnformatted").each(function (m) {
		m.setStyle("text-align:"+m.getStyle("text-align")=="" || m.getStyle("text-align") == null ? "right" :m.getStyle("text-align")+";");
		m.observe("focus", function ()	{
			m.select();
			m.value = (m.value).replace(/,/g, "");
		});
		
		m.observe("keyup", function (e)	{
			m.value = m.value.strip();
			var error = false;
			for(i=0;i<1;){
				if (m.value.indexOf(",,") == -1){
					i++;
				} else{
					m.value = m.value.substring(m.value.indexOf(",,"),"");
					error = true;
				}	
			}
			for(i=0;i<1;){
				if (m.value.indexOf(".") == -1){
					i++;
				} else{
					m.value = m.value.substring(m.value.indexOf("."),"");
					error = true;
				}	
			}
			for(i=0;i<1;){
				if (isNaN(parseInt(m.value.replace(/,/g, "") * 1))) {
					m.value = m.value.substring(m.value.length-1,"");
					error = true;
				} else{
					i++;
				}	
			}
			for(i=0;i<1;){
				if (m.value.indexOf("-") == -1){
					i++;
				} else{
					m.value = m.value.substring(m.value.indexOf("-"),"");
					error = true;
				}	
			}
			if (error){
				if (m.getAttribute("errorMsg")){
					m.blur();
					showMessageBox(m.getAttribute("errorMsg"), imgMessage.ERROR);
				}
			}	
		});
		m.observe("blur", function (e)	{
			if (isNaN(parseInt(m.value.replace(/,/g, "") * 1))) {
				m.value = "";
				if (m.getAttribute("errorMsg")){
					showMessageBox(m.getAttribute("errorMsg"), imgMessage.ERROR);
				}
			} else if (m.value.indexOf("-") != -1){
				m.value = "";
				if (m.getAttribute("errorMsg")){
					showMessageBox(m.getAttribute("errorMsg"), imgMessage.ERROR);
				}
			}else{
				m.value = m.value.replace(/,/g, "");
			}	
		});	
	});
	
	/**
	 * for whole positive/negative numbers, automatically deletes all invalid characters. 
	 * With no format on blur
	 * Does not accept a comma input, throws an error message
	 * Does not allow decimal value
	 * Display Error Message if error occur, just create an attribute named 'errorMsg' (optional)
	 * Ex. <input type="text" class="integerUnformattedNoComma" errorMsg="Input value is invalid!." />
	 * @author Jerome Orio
	 */
	$$("input[type='text'].integerUnformattedNoComma, input[type='hidden'].integerUnformattedNoComma").each(function (m) {
		m.setStyle("text-align:"+m.getStyle("text-align")=="" || m.getStyle("text-align") == null ? "right" :m.getStyle("text-align")+";");
		m.observe("focus", function ()	{
			m.select();
			m.value = (m.value).replace(/,/g, "");
		});
		
		m.observe("keyup", function (e)	{
			m.value = m.value.strip();
			var error = false;
			for(i=0;i<1;){
				if (m.value.indexOf(".") == -1){
					i++;
				} else{
					m.value = m.value.substring(m.value.indexOf("."),"");
					error = true;
				}	
			}
			if (e.keyCode == 109 && m.value.length == 1){
				return true;
			} else{	
				for(i=0;i<1;){
					if (isNaN(parseInt(m.value * 1))) {
						m.value = m.value.substring(m.value.length-1,"");
						error = true;
					} else{
						i++;
					}	
				}
			}
			if (error){
				if (m.getAttribute("errorMsg")){
					if (m.hasClassName("deleteInvalidInput")){
						m.value = "";
					}
					m.blur();
					showMessageBox(m.getAttribute("errorMsg"), imgMessage.ERROR);
				}
			}
		});
		m.observe("blur", function (e)	{
			if (isNaN(parseInt(m.value * 1))) {
				m.value = "";
				if (m.getAttribute("errorMsg")){
					showMessageBox(m.getAttribute("errorMsg"), imgMessage.ERROR);
				}
			}else{
				m.value = m.value;
			}	
		});
	});
	
	/**
	 * for whole positive numbers, automatically deletes all invalid characters. 
	 * With no format on blur
	 * Does not accept a comma input, throws an error message
	 * Does not allow decimal value and negative value
	 * Display Error Message if error occur, just create an attribute named 'errorMsg' (optional)
	 * Ex. <input type="text" class="integerNoNegativeUnformattedNoComma" errorMsg="Input value is invalid!." />
	 * @author Jerome Orio
	 */
	$$("input[type='text'].integerNoNegativeUnformattedNoComma, input[type='hidden'].integerNoNegativeUnformattedNoComma").each(function (m) {
		m.setStyle("text-align:"+m.getStyle("text-align")=="" || m.getStyle("text-align") == null ? "right" :m.getStyle("text-align")+";");
		m.observe("focus", function ()	{
			m.select();
			m.value = (m.value).replace(/,/g, "");
		});
		
		m.observe("keyup", function (e)	{
			m.value = m.value.strip();
			var error = false;
			for(i=0;i<1;){
				if (m.value.indexOf(".") == -1){
					i++;
				} else{
					m.value = m.value.substring(m.value.indexOf("."),"");
					error = true;
				}	
			}
			for(i=0;i<1;){
				if (isNaN(parseInt(m.value * 1))) {
					m.value = m.value.substring(m.value.length-1,"");
					error = true;
				} else{
					i++;
				}	
			}
			for(i=0;i<1;){
				if (m.value.indexOf("-") == -1){
					i++;
				} else{
					m.value = m.value.substring(m.value.indexOf("-"),"");
					error = true;
				}	
			}
			if (error){
				if (m.getAttribute("errorMsg")){
					if (m.hasClassName("deleteInvalidInput")){
						m.value = "";
					}
					m.blur();
					if(m.getAttribute("lastValidValue")){ //added by steven 11.06.2013; if you want to show the last valid value.
						m.value = m.getAttribute("lastValidValue");
					}
					showMessageBox(m.getAttribute("errorMsg"), imgMessage.ERROR);
				}
			}	
		});
		m.observe("blur", function (e)	{
			if (isNaN(parseInt(m.value * 1))) {
				m.value = "";
				if (m.getAttribute("errorMsg")){
					showMessageBox(m.getAttribute("errorMsg"), imgMessage.ERROR);
				}
			} else if (m.value.indexOf("-") != -1){
				m.value = "";
				if (m.getAttribute("errorMsg")){
					showMessageBox(m.getAttribute("errorMsg"), imgMessage.ERROR);
				}
			}else{
				m.value = m.value;
				if(m.getAttribute("lpad")){ //added by steven 12.12.2013; if you want to use lpad.
					m.value = m.value.trim() == "" ? "" : lpad(m.value,parseInt(m.getAttribute("lpad")),'0');
				}
			}	
		});	
	});	
	
	/*	Date		Author			Description
	 * 	==========	===============	==============================
	 * 	09.14.2011	mark jm			Allow only integer numbers, disregard non-digit characters except "-"
	 */
	$$("input[type='text'].integerNumbersOnly, input[type='hidden'].integerNumbersOnly").each(function(m){
		m.setStyle("text-align: " + 
				(m.getStyle("text-align") == "" || m.getStyle("text-align") == null) ? "right" : m.getStyle("text-align") + ";");
			
		m.observe("focus", function(){
			m.select();
			m.value = (m.value).replace(/,/g, "");
		});
		
		m.observe("keyup", function(){			
			var regEx = /(^-*\d+$)/;
			
			if(!(regEx.test(m.value))){
				if(m.value.indexOf("-") == 0){					
					m.value = "-" + (m.value).match(/\d+/g);					
				}else{
					m.value = (m.value).match(/\d+/g);
				}					
			}
		});
		
		m.observe("blur", function(){
			var input = m.value.replace(/,/g, "");
			var regEx = /(^-*\d+$)/;
			
			if(m.value != ""){
				if(regEx.test(input)){
					if(parseInt(m.value) < parseInt(m.getAttribute("min"))){
						customShowMessageBox(m.getAttribute("errorMsg"), imgMessage.ERROR, m.id);
					}else if(parseInt(m.value) > parseInt(m.getAttribute("max"))){
						customShowMessageBox(m.getAttribute("errorMsg"), imgMessage.ERROR, m.id);
					}else{
						m.value = removeLeadingZero((m.value).replace(/,/g, ""));
					}
				}else{			
					customShowMessageBox(m.getAttribute("errorMsg"), imgMessage.ERROR, m.id);			
					return false;
				}	
			}							
		});
	});	
	
	$$("label").each(function (lbl) {
		lbl.writeAttribute("title", lbl.innerHTML);
	});
	
	$$("input[type='text'].integerAcceptsZero, input[type='hidden'].integerAcceptsZero").each(function (m) {
		m.observe("blur", function (e)	{
			m.value = m.value.replace(/^\s+/,"");
			m.value = m.value.replace(/^0+/,"");
		});
	});
	
	//capitalized all alphabets BRYAN 12.14.2010
	$$("input[type='text'].allCaps, textarea.allCaps").each(function (m) {
		m.observe("keyup", function (e)	{
			$(m.getAttribute("id")).value = $F(m.getAttribute("id")).toUpperCase();
		});
		
		// mark jm 12.08.2011
		m.observe("blur", function (e)	{
			$(m.getAttribute("id")).value = $F(m.getAttribute("id")).toUpperCase();
		});
	});
	
	// mark jm 11.11.2011 mark jm set textarea to not be resize
	$$("textarea").each(function(t){
		t.style.resize = "none";
	});
	
	/*$$("input[type='text'].lov").each(function(lov){
		lov.observe("keyup", function(event) {
			if(event.keyCode == 120){
				//lov.next("img", 0).click();
			}
		});
	});*/
	
	/*	Date		Author			Description
	 * 	==========	===============	==============================
	 * 	11.23.2011	mark jm			Allow only integer numbers, disregard non-digit characters (positive/negative)
	 */
	$$("input[type='text'].applyWholeNosRegExp").each(function(m){
		m.setStyle("text-align: right");
		
		m.observe("focus", function(){
			m.select();
			m.value = (m.value).replace(/,/g, "");
			m.setAttribute("lastValidValue", this.value);
		});
		//added by d.alcantara, 10.30.2012
		var hasCustomLabel = m.getAttribute("customLabel") == null ? "N" : "Y";
		
		// if element has own keyup observer, kindly add the attribute "hasOwnKeyUp"
		// to that element and set it to "Y". then be sure that its own observer
		// is already set before calling this function
		if(m.getAttribute("hasOwnKeyUp") != "Y"){
			m.observe("keyup", function(e){
				var pattern = m.getAttribute("regExpPatt"); 
				if(pattern.substr(0,1) == "p"){
					if(this.value.include("-")){
						m.setAttribute("executeOnBlur", "N");
						showWaitingMessageBox(getNumberFieldErrMsg(m, false, hasCustomLabel), imgMessage.ERROR, function(){
							m.value = m.getAttribute("lastValidValue");
							m.focus();
						});
						return false;
					}else{
						this.value = (this.value).match(RegExWholeNumber[pattern])[0];
						m.setAttribute("executeOnBlur", "Y");
					}		 
				}else{
					this.value = (this.value).match(RegExWholeNumber[pattern])[0];
					m.setAttribute("executeOnBlur", "Y");
				}			   						
			});
		}		
		
		// if element has own blur observer, kindly add the attribute "hasOwnBlur"
		// to that element and set it to "Y". then be sure that its own observer
		// is already set before calling this function
		if(m.getAttribute("hasOwnBlur") != "Y"){
			m.observe("blur", function(e){
				if(!((m.value).empty()) && m.getAttribute("executeOnBlur") != "N"){
					if(isNaN(parseInt((m.value).replace(/,/g, "")))){
						m.value = "";
						customShowMessageBox(getNumberFieldErrMsg(m, false, hasCustomLabel), imgMessage.ERROR, m.id);
					}else{
						if(parseInt(m.value) < parseInt(m.getAttribute("min"))){
							showWaitingMessageBox(getNumberFieldErrMsg(m, false, hasCustomLabel), imgMessage.ERROR, function(){
								m.value = m.getAttribute("lastValidValue");
								m.focus();
							});
							return false;
						}else if(parseInt(m.value) > parseInt(m.getAttribute("max"))){
							showWaitingMessageBox(getNumberFieldErrMsg(m, false, hasCustomLabel), imgMessage.ERROR, function(){
								m.value = m.getAttribute("lastValidValue");
								m.focus();
							});
							return false;
						}else{
							m.value = removeLeadingZero((m.value).replace(/,/g, ""));
							m.setAttribute("lastValidValue", m.value);
						}
					}
				}			
			});
		}
		
		// if element has own change observer, kindly add the attribute "hasOwnChange"
		// to that element and set it to "Y". then be sure that its own observer
		// is already set before calling this function
		if(m.getAttribute("hasOwnChange") != "Y"){
			m.observe("change", function(){
				if(!((m.value).empty()) && m.getAttribute("executeOnBlur") != "N"){
					if(isNaN(parseInt((m.value).replace(/,/g, "")))){
						m.value = "";
						customShowMessageBox(getNumberFieldErrMsg(m, false, hasCustomLabel), imgMessage.ERROR, m.id);
					}else{
						if(parseInt(m.value) < parseInt(m.getAttribute("min"))){							
							showWaitingMessageBox(getNumberFieldErrMsg(m, false, hasCustomLabel), imgMessage.ERROR, function(){
								m.value = m.getAttribute("lastValidValue");
								m.focus();
							});
							return false;
						}else if(parseInt(m.value) > parseInt(m.getAttribute("max"))){
							showWaitingMessageBox(getNumberFieldErrMsg(m, false, hasCustomLabel), imgMessage.ERROR, function(){
								m.value = m.getAttribute("lastValidValue");
								m.focus();
							});
							return false;
						}else{
							m.value = removeLeadingZero((m.value).replace(/,/g, ""));
							m.setAttribute("lastValidValue", m.value);
						}
					}
				}
			});
		}		
	});
	
	/*	Date		Author			Description
	 * 	==========	===============	==============================
	 * 	11.23.2011	mark jm			Allow decimal numbers, disregard non-digit characters (positive/negative)
	 */
	$$("input[type='text'].applyDecimalRegExp").each(function(m){
		m.setStyle("text-align: right");
		
		m.observe("focus", function(){
			m.select();
			m.value = (m.value).replace(/,/g, "");
			m.setAttribute("lastValidValue", this.value);
		});
		
		// if element has own keyup observer, kindly add the attribute "hasOwnKeyUp"
		// to that element and set it to Y. then be sure that its own observer
		// is already set before calling this function
		if(m.getAttribute("hasOwnKeyUp") != "Y"){
			m.observe("keyup", function(e){				
				var pattern = m.getAttribute("regExpPatt"); 				
				var val = m.value.replace(/,/g, "");
				
				if(pattern.substr(0,1) == "p"){
					if(this.value.include("-")){
						m.setAttribute("executeOnBlur", "N");
						showWaitingMessageBox(getNumberFieldErrMsg(m, true, (m.getAttribute("customLabel") != null ? "Y" : "N")), imgMessage.ERROR, function(){
							m.value = m.getAttribute("lastValidValue");
							m.focus();
						});
						return false;
					}else{						
						this.value = (val).match(RegExDecimal[pattern])[0];
						m.setAttribute("executeOnBlur", "Y");
					}
				}else{					
					this.value = (val).match(RegExDecimal[pattern])[0];
					m.setAttribute("executeOnBlur", "Y");
				}					    						
			});
		}		

		// if element has own blur observer, kindly add the attribute "hasOwnBlur"
		// to that element and set it to "Y". then be sure that its own observer
		// is already set before calling this function
		if(m.getAttribute("hasOwnBlur") != "Y"){
			m.observe("blur", function(e){				
				if(!((m.value).empty()) && m.getAttribute("executeOnBlur") != "N"){
					if(isNaN(parseInt((m.value).replace(/,/g, "")))){
						m.value = "";
						customShowMessageBox(getNumberFieldErrMsg(m, true , (m.getAttribute("customLabel") != null ? "Y" : "N")), imgMessage.ERROR, m.id);
					}else{
						if(parseInt(m.value) < parseInt(m.getAttribute("min"))){
							showWaitingMessageBox(getNumberFieldErrMsg(m, true,(m.getAttribute("customLabel") != null ? "Y" : "N")), imgMessage.ERROR, function(){
								m.value = m.getAttribute("lastValidValue");
								m.focus();
							});
							return false;
						}else if(parseInt(m.value) > parseInt(m.getAttribute("max"))){
							showWaitingMessageBox(getNumberFieldErrMsg(m, true,(m.getAttribute("customLabel") != null ? "Y" : "N")), imgMessage.ERROR, function(){
								m.value = m.getAttribute("lastValidValue");
								m.focus();
							});
							return false;
						}else{
							val = formatNumberByRegExpPattern(m);				
							
							m.value = addSeparatorToNumber2(val, ",");
						}
					}
				}
			});
		}
		
		// if element has own change observer, kindly add the attribute "hasOwnChange"
		// to that element and set it to "Y". then be sure that its own observer
		// is already set before calling this function
		if(m.getAttribute("hasOwnChange") != "Y"){
			m.observe("change", function(){
				if(!((m.value).empty()) && m.getAttribute("executeOnBlur") != "N"){
					if(isNaN(parseInt((m.value).replace(/,/g, "")))){
						m.value = "";
						customShowMessageBox(getNumberFieldErrMsg(m, true,(m.getAttribute("customLabel") != null ? "Y" : "N")), imgMessage.ERROR, m.id);
					}else{
						if(parseInt(m.value) < parseInt(m.getAttribute("min"))){
							showWaitingMessageBox(getNumberFieldErrMsg(m, true,(m.getAttribute("customLabel") != null ? "Y" : "N")), imgMessage.ERROR, function(){
								m.value = m.getAttribute("lastValidValue");
								m.focus();
							});
							return false;
						}else if(parseInt(m.value) > parseInt(m.getAttribute("max"))){
							showWaitingMessageBox(getNumberFieldErrMsg(m, true,(m.getAttribute("customLabel") != null ? "Y" : "N")), imgMessage.ERROR, function(){
								m.value = m.getAttribute("lastValidValue");
								m.focus();
							});
							return false;
						}else{
							val = formatNumberByRegExpPattern(m);							
							m.value = val;							
							m.setAttribute("lastValidValue", m.value);
						}
					}
				}
			});
		}		
	});
	
	// shan 03.20.2014 : to prevent 0 if valid minimum value is greater than 0 and below 1
	$$("input[type='text'].applyDecimalRegExp2").each(function(m){
		m.setStyle("text-align: right");
		
		m.observe("focus", function(){
			m.select();
			m.value = (m.value).replace(/,/g, "");
			m.setAttribute("lastValidValue", this.value);
		});
		
		
		// if element has own keyup observer, kindly add the attribute "hasOwnKeyUp"
		// to that element and set it to Y. then be sure that its own observer
		// is already set before calling this function
		if(m.getAttribute("hasOwnKeyUp") != "Y"){
			m.observe("keyup", function(e){				
				var pattern = m.getAttribute("regExpPatt"); 				
				var val = m.value.replace(/,/g, "");
				
				if(pattern.substr(0,1) == "p"){
					if(this.value.include("-")){
						m.setAttribute("executeOnBlur", "N");
						if (m.getAttribute("hideErrMsg")){	// added by shan 03.20.2014 : auto-delete invalid characters w/o showing errMsg
							m.value = m.getAttribute("lastValidValue");
							m.focus();
							return false;
						}
						showWaitingMessageBox(getNumberFieldErrMsg(m, true, (m.getAttribute("customLabel") != null ? "Y" : "N")), imgMessage.ERROR, function(){
							m.value = m.getAttribute("lastValidValue");
							m.focus();
						});
						return false;
					}else{						
						this.value = (val).match(RegExDecimal[pattern])[0];
						m.setAttribute("executeOnBlur", "Y");
					}
				}else{					
					this.value = (val).match(RegExDecimal[pattern])[0];
					m.setAttribute("executeOnBlur", "Y");
				}					    						
			});
		}		

		// if element has own blur observer, kindly add the attribute "hasOwnBlur"
		// to that element and set it to "Y". then be sure that its own observer
		// is already set before calling this function
		if(m.getAttribute("hasOwnBlur") != "Y"){
			m.observe("blur", function(e){				
				if(!((m.value).empty()) && m.getAttribute("executeOnBlur") != "N"){
					if(isNaN(parseFloat((m.value).replace(/,/g, "")))){
						m.value = "";
						customShowMessageBox(getNumberFieldErrMsg(m, true , (m.getAttribute("customLabel") != null ? "Y" : "N")), imgMessage.ERROR, m.id);
					}else{
						if(parseFloat(m.value) < parseFloat(m.getAttribute("min"))){
							showWaitingMessageBox(getNumberFieldErrMsg(m, true,(m.getAttribute("customLabel") != null ? "Y" : "N")), imgMessage.ERROR, function(){
								m.value = m.getAttribute("lastValidValue");
								m.focus();
							});
							return false;
						}else if(parseFloat(m.value) > parseFloat(m.getAttribute("max"))){
							showWaitingMessageBox(getNumberFieldErrMsg(m, true,(m.getAttribute("customLabel") != null ? "Y" : "N")), imgMessage.ERROR, function(){
								m.value = m.getAttribute("lastValidValue");
								m.focus();
							});
							return false;
						}else{
							val = formatNumberByRegExpPattern(m);				
							
							m.value = addSeparatorToNumber2(val, ",");
						}
					}
				}
			});
		}
		
		// if element has own change observer, kindly add the attribute "hasOwnChange"
		// to that element and set it to "Y". then be sure that its own observer
		// is already set before calling this function
		if(m.getAttribute("hasOwnChange") != "Y"){
			m.observe("change", function(){
				if(!((m.value).empty()) && m.getAttribute("executeOnBlur") != "N"){
					
					if (m.value.indexOf(".") == 0){
						m.value = "0" + m.value;
					}
				
					if(isNaN(parseFloat((m.value).replace(/,/g, "")))){
						m.value = "";
						customShowMessageBox(getNumberFieldErrMsg(m, true,(m.getAttribute("customLabel") != null ? "Y" : "N")), imgMessage.ERROR, m.id);
					}else{
						if(parseFloat(m.value) < parseFloat(m.getAttribute("min"))){
							showWaitingMessageBox(getNumberFieldErrMsg(m, true,(m.getAttribute("customLabel") != null ? "Y" : "N")), imgMessage.ERROR, function(){
								m.value = m.getAttribute("lastValidValue");
								m.focus();
							});
							return false;
						}else if(parseFloat(m.value) > parseFloat(m.getAttribute("max"))){
							showWaitingMessageBox(getNumberFieldErrMsg(m, true,(m.getAttribute("customLabel") != null ? "Y" : "N")), imgMessage.ERROR, function(){
								m.value = m.getAttribute("lastValidValue");
								m.focus();
							});
							return false;
						}else{
							val = formatNumberByRegExpPattern(m);							
							m.value = val;							
							m.setAttribute("lastValidValue", m.value);
						}
					}
				}
			});
		}		
	});
	
	// to be used for text fields with manually entered date
	$$("input[type='text'].formattedDate").each(function(m){
		m.setStyle("text-align: left;");
		
		m.observe("focus", function(){
			m.select();
			if(m.value != "") m.value = (m.value).replace(/,/g, "");
		});
		
		m.observe("change", function() {
			if(m.value != "" && m.value != null) {
				if(checkDate2(m.value)) {
					m.value = m.value;
				} else {
					m.value = "";
				}
			}
		});
		
		m.observe("keyup", function(){ //belle 12.13.12
			if(isNaN(parseInt((m.value).replace(/,/g, "")))){
				m.value = "";
			}
		});
	});
	/*	Date		Author			Description
	 * 	==========	===============	==============================
	 * 	03.01.2012	Irwin Tabisora	Disables the button inputs with "disabledButton" as a class
	 */
	$$("input[type='button'].disabledButton").each(function(m){
		disableButton(m.id);
	});
	//end initializeAll
}