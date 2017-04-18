//Event.observe(window, 'load', init, false);

function init(){
makeEditable('insuredOfw');
makeEditable('insuredOccupation');
makeEditable('insuredNatureOfWork');
makeEditable('insuredEmployerName');
makeEditable('insuredNatureOfBusiness');
makeEditable('insuredSof');
makeEditable('insuredGrossAnnualIncome');

}

function makeEditable(id){
Event.observe(id, 'click', function(){edit($(id))}, false);
 Event.observe(id, 'mouseover', function(){showAsEditable($(id))}, false);
 Event.observe(id, 'mouseout', function(){showAsEditable($(id), true)}, false);
}

function edit(obj){
 Element.hide(obj);

 var textarea = '<div id="'+obj.id+'_editor"><input class="inpt_text_req" type="text" id="'+obj.id+'_edit" name="'+obj.id+'" value="'+obj.innerHTML+'" />';
 var button = '<div><input id="'+obj.id+'_save" type="button" value="SAVE" /> OR <a id="'+obj.id+'_cancel" >cancel</a></div></div>';

 new Insertion.After(obj, textarea+button);

 Event.observe(obj.id+'_save', 'click', function(){saveChanges(obj)}, false);
 Event.observe(obj.id+'_cancel', 'click', function(){cleanUp(obj)}, false);

}

function showAsEditable(obj, clear){
 if (!clear){
 Element.addClassName(obj, 'editable');
 }else{
 Element.removeClassName(obj, 'editable');
 }
}

function saveChanges(obj){
 var new_content = escape($F(obj.id+'_edit'));

 obj.innerHTML = "Saving...";
 cleanUp(obj, true);

 var success = function(t){editComplete(t, obj);}
 var failure = function(t){editFailed(t, obj);}

 var url = 'PoltApplicationController?action=editField';
 var pars = 'id='+obj.id+'&content='+new_content;
 var myAjax = new Ajax.Request(url, {method:'post', postBody:pars, onSuccess:success, onFailure:failure, onException:failure});

}

function cleanUp(obj, keepEditable){
 Element.remove(obj.id+'_editor');
 Element.show(obj);
 if (!keepEditable) showAsEditable(obj, true);
}

function editComplete(t, obj){
 obj.innerHTML = t.responseText;
 showAsEditable(obj, true);
}

function editFailed(t, obj){
 obj.innerHTML = 'Sorry, the update failed.';
 cleanUp(obj);
}