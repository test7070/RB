<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" dir="ltr">
	<head>
		<title> </title>
		<script src="../script/jquery.min.js" type="text/javascript"></script>
		<script src='../script/qj2.js' type="text/javascript"></script>
		<script src='qset.js' type="text/javascript"></script>
		<script src='../script/qj_mess.js' type="text/javascript"></script>
		<script src="../script/qbox.js" type="text/javascript"></script>
		<script src='../script/mask.js' type="text/javascript"></script>
		<link href="../qbox.css" rel="stylesheet" type="text/css" />
		<script type="text/javascript">
			this.errorHandler = null;
			function onPageError(error) {
				alert("An error occurred:\r\n" + error.Message);
			}

			q_tables = 's';
			var q_name = "cng";
			var q_readonly = ['txtNoa','txtStorein','txtStore','txtNamea', 'txtWorker', 'txtWorker2','txtTranstart','txtComp'];
			var q_readonlys = ['txtRetno','txtRetnoq'];
			var bbmNum = [];
			var bbsNum = [];
			var bbmMask = [];
			var bbsMask = [];
			q_sqlCount = 6;
			brwCount = 6;
			brwList = [];
			brwNowPage = 0;
			brwKey = 'Datea';
			aPop = new Array(
				['txtStoreno', 'lblStore', 'store', 'noa,store', 'txtStoreno,txtStore', 'store_b.aspx'],
				['txtRackno', 'lblRackno', 'rack', 'noa,rack,storeno,store', 'txtRackno', 'rack_b.aspx'],
				['txtStoreinno', 'lblStorein', 'store', 'noa,store', 'txtStoreinno,txtStorein', 'store_b.aspx'],
				['txtRackinno', 'lblRackinno', 'rack', 'noa,rack,storeno,store', 'txtRackinno', 'rack_b.aspx'],
				['txtProductno_', 'btnProductno_', 'ucaucc', 'noa,product,unit,spec', 'txtProductno_,txtProduct_,txtUnit_,txtSpec_', 'ucaucc_b2.aspx'],
				['txtSssno', 'lblSssno', 'sss', 'noa,namea', 'txtSssno,txtNamea', 'sss_b.aspx'],
				['txtTranstartno', 'lblPart', 'part', 'noa,part', 'txtTranstartno,txtTranstart', 'part_b.aspx'],
				['txtCustno', 'lblCust', 'cust', 'noa,comp,addr_home,tel', 'txtCustno,txtComp,txtAddr,txtTel', 'cust_b.aspx']
			);

			$(document).ready(function() {
				bbmKey = ['noa'];
				bbsKey = ['noa', 'noq'];
				q_brwCount();
				q_gt(q_name, q_content, q_sqlCount, 1, 0, '', r_accy);

			});

			function main() {
				if (dataErr) {
					dataErr = false;
					return;
				}
				mainForm(1);
			}

			function mainPost() {
				q_getFormat();
				bbmMask = [['txtDatea', r_picd],['txtPost', r_picd],['txtTranstyle', '99:99']];
				bbsNum = [['txtMount', 10, q_getPara('vcc.mountPrecision'), 1]];
				q_mask(bbmMask);
				q_cmbParse("cmbTypea", q_getPara('cng.typea'));
				q_cmbParse("cmbTrantype", q_getPara('sys.tran'));
				q_cmbParse("cmbKind", ",折讓,作廢,空白欄");
				
				$('#btnRet').click(function() {
					var t_where = '';
					var t_custno = $('#txtCustno').val();
					if (t_custno.length > 0 ){
						if((q_cur==1 || q_cur==2)){
							t_where ="typea='4' and custno='"+t_custno+"' and isnull(tranadd,0)=0 "
							t_where += "and exists (select * from view_cngs ca outer apply (select sum(mount)rmount,sum(weight) rweight from view_cngs where retno=ca.noa and retnoq=ca.noq ) cb where ca.noa=view_cng.noa and ca.mount-isnull(cb.rmount,0)>0 )";
							//t_where = "typea='4' and exists(select * from view_cng where custno='"+t_custno+"' and noa=a.noa) ";
							//t_where += " and mount-isnull(b.rmount,0)>0 ";
							q_box("cng_rb_b.aspx?" + r_userno + ";" + r_name + ";" + q_time + ";" + t_where, 'cng', "500px", "95%", q_getMsg('popCngs'));
						}
					}else{
						alert("請輸入客戶編號!!");
					}
				});
				
				$('#cmbTypea').change(function() {
					HiddenTreat();
				});
			}

			function q_boxClose(s2) {
				var ret;
				switch (b_pop) {
					case 'cng':
						if (q_cur > 0 && q_cur < 4) {
							b_ret = getb_ret();
							if (!b_ret || b_ret.length == 0) {
								b_pop = '';
								return;
							}
							if(b_ret[0].noa!=undefined){
								var t_where = "where=^^typea='4' and noa='"+b_ret[0].noa+"' and mount-isnull(b.rmount,0)>0 ^^";
								q_gt('cngs_re', t_where, 0, 0, 0, "", r_accy);	
							}
						}
						break;
					case 'cngs':
						if (q_cur > 0 && q_cur < 4) {
							b_ret = getb_ret();
							if (!b_ret || b_ret.length == 0) {
								b_pop = '';
								return;
							}
							
							ret = q_gridAddRow(bbsHtm, 'tbbs', 'txtProductno,txtProduct,txtUnit,txtMount,txtRetno,txtRetnoq'
								, b_ret.length, b_ret, 'productno,product,unit,umount,noa,noq', 'txtProductno,txtProduct');
							bbsAssign();
						}
						break;
					case q_name + '_s':
						q_boxClose2(s2);
						break;
				}
				if(s2[0]!=undefined){
					if(s2[0]=='view_ucaucc' && q_getPara('sys.project').toUpperCase()=='RB'){
						if (q_cur > 0 && q_cur < 4) {
							b_ret = getb_ret();
							if (!b_ret || b_ret.length == 0)
								return;
							if (b_ret.length>0)
								b_ret.splice(0, 1);
							if (b_ret.length>0)
								ret = q_gridAddRow(bbsHtm, 'tbbs', 'txtProductno,txtProduct,txtSpec,txtUnit', b_ret.length, b_ret, 'noa,product,spec,unit', 'txtProductno,txtProduct,txtSpec');
						}
					}
				}
				b_pop = '';
			}
			
			function q_popPost(s1) {
				switch (s1) {
					
				}
			}
			
			var t_msg='';
			var carnoList = [];
			var thisCarSpecno = '';
			function q_gtPost(t_name) {
				switch (t_name) {
					case 'cngs_re':
						var as = _q_appendData("view_cngs", "", true);
							q_gridAddRow(bbsHtm, 'tbbs', 'txtProductno,txtProduct,txtUnit,txtMount,txtRetno,txtRetnoq'
								, as.length, as, 'productno,product,unit,umount,noa,noq', 'txtProductno,txtProduct');
						break;
					case 'msg_stk':
						var as = _q_appendData("stkucc", "", true);
						var stkmount = 0;
						t_msg = '';
						for (var i = 0; i < as.length; i++) {
							stkmount = q_add(stkmount, dec(as[i].mount));
						}
						t_msg = "庫存量：" + stkmount;
						q_msg($('#txtMount_' + b_seq), t_msg);
						break;
					case q_name:
						if (q_cur == 4)
							q_Seek_gtPost();
						break;
				}
			}

			function btnOk() {
				t_err = q_chkEmpField([['txtNoa', q_getMsg('lblNoa')], ['txtDatea', q_getMsg('lblDatea')]]);
				if (t_err.length > 0) {
					alert(t_err);
					return;
				}
				
				if($('#cmbTypea').val()=='4' || $('#cmbTypea').val()=='5'){
					t_err = q_chkEmpField([['txtCustno', q_getMsg('lblCust')],['txtStoreno', q_getMsg('lblStore')],['txtStoreinno', q_getMsg('lblStorein')]]);
					if (t_err.length > 0) {
						alert(t_err);
						return;
					}
				}
				
				if($('#cmbTypea').val()!='5'){
					$("#tbbs .ret").val('');
				}
				
				if (q_cur == 1)
					$('#txtWorker').val(r_name);
				else
					$('#txtWorker2').val(r_name);
				
				var s1 = $('#txt' + bbmKey[0].substr(0, 1).toUpperCase() + bbmKey[0].substr(1)).val();
				
				var t_typea='';
				if(!emp($('#cmbTypea').val())){
					t_typea=String.fromCharCode(q_float('cmbTypea')+64);
				}
				
				if (s1.length == 0 || s1 == "AUTO")
					q_gtnoa(q_name, replaceAll(q_getPara('sys.key_cng') +t_typea+ $('#txtDatea').val(), '/', ''));
				else
					wrServer(s1);
			}

			function _btnSeek() {
				if (q_cur > 0 && q_cur < 4)
					return;
				q_box('cng_s.aspx', q_name + '_s', "500px", "330px", q_getMsg("popSeek"));
			}

			function bbsAssign() {
				for (var i = 0; i < q_bbsCount; i++) {
					if (!$('#btnMinus_' + i).hasClass('isAssign')) {
												
						$('#txtMount_' + i).focusin(function() {
							if (q_cur == 1 || q_cur == 2) {
								t_IdSeq = -1;
								q_bodyId($(this).attr('id'));
								b_seq = t_IdSeq;
								if (!emp($('#txtProductno_' + b_seq).val())) {
									//庫存
									var t_storeno=$('#txtStoreno').val();
									var t_where = "where=^^ ['" + q_date() + "','"+t_storeno+"','"+$('#txtProductno_' + b_seq).val()+"')  ^^";
									q_gt('calstk', t_where, 0, 0, 0, "msg_stk", r_accy);
								}
							}
						});
						
						$('#txtRetno_'+i).click(function() {
							t_IdSeq = -1;
							q_bodyId($(this).attr('id'));
							b_seq = t_IdSeq;
							if (!(q_cur == 1 || q_cur == 2) &&!emp($('#txtRetno_'+b_seq).val())) {
								var t_noa=trim($('#txtRetno_'+b_seq).val());
								q_box("cng_rb.aspx?" + r_userno + ";" + r_name + ";" + q_time + ";noa='" + t_noa+ "';" + r_accy, 'cng_rb', "95%", "95%", '借出調撥單');
							}
						});
					}
				}
				_bbsAssign();
				HiddenTreat();
			}

			function btnIns() {
				_btnIns();
				$('#txt' + bbmKey[0].substr(0, 1).toUpperCase() + bbmKey[0].substr(1)).val('AUTO');
				$('#txtDatea').val(q_date());
				$('#txtDatea').focus();
			}

			function btnModi() {
				if (emp($('#txtNoa').val()))
					return;
				_btnModi();
				//104/10/14 禁止改單別 避免借出轉銷單錯誤
				$('#cmbTypea').attr('disabled', 'disabled');
				
				//判斷是否由撥料作業轉來>>鎖定欄位
				if(!emp($('#txtWorkkno').val()) || !emp($('#txtWorklno').val())){
					$('#cmbTypea').attr('disabled', 'disabled');
					$('#txtDatea').attr('disabled', 'disabled');
					$('#txtStoreno').attr('disabled', 'disabled');
					$('#txtStoreinno').attr('disabled', 'disabled');
					$('#lblStorek').css('display', 'inline').text($('#lblStore').text());
					$('#lblStoreink').css('display', 'inline').text($('#lblStorein').text());
					$('#lblStore').css('display','none');
					$('#lblStorein').css('display','none');
					
					$('#btnPlus').attr('disabled', 'disabled');
					for (var j = 0; j < q_bbsCount; j++) {
						$('#btnMinus_'+j).attr('disabled', 'disabled');
						$('#txtProductno_'+j).attr('disabled', 'disabled');
						$('#btnProductno_'+j).attr('disabled', 'disabled');
						$('#txtProduct_'+j).attr('disabled', 'disabled');
						$('#txtUnit_'+j).attr('disabled', 'disabled');
						$('#txtSpec_'+j).attr('disabled', 'disabled');
						$('#txtMount_'+j).attr('disabled', 'disabled');
					}
				}
				
				$('#txtProduct').focus();
			}

			function btnPrint() {
				q_box('z_cngp_rb.aspx' + "?;;;noa=" + trim($('#txtNoa').val()) + ";" + r_accy, '', "95%", "95%", q_getMsg("popPrint"));
					
			}

			function wrServer(key_value) {
				var i;
				$('#txt' + bbmKey[0].substr(0, 1).toUpperCase() + bbmKey[0].substr(1)).val(key_value);
				_btnOk(key_value, bbmKey[0], bbsKey[1], '', 2);
			}

			function bbsSave(as) {
				if (!as['productno']) {
					as[bbsKey[1]] = '';
					return;
				}

				q_nowf();
				as['datea'] = abbm2['datea'];
				as['tggno'] = abbm2['tggno'];
				as['typea'] = abbm2['typea'];
				as['storeno'] = abbm2['storeno'];
				as['storeinno'] = abbm2['storeinno'];
				return true;
			}

			function refresh(recno) {
				_refresh(recno);
				$('#lblStore').css('display','inline');
				$('#lblStorein').css('display','inline');
				$('#lblStorek').css('display', 'none');
				$('#lblStoreink').css('display', 'none');
				HiddenTreat();
			}

			function HiddenTreat(returnType){
				returnType = $.trim(returnType).toLowerCase();
				var hasStyle = q_getPara('sys.isstyle');
				var isStyle = (hasStyle.toString()=='1'?$('.isStyle').show():$('.isStyle').hide());
				var hasSpec = q_getPara('sys.isspec');
				var isSpec = (hasSpec.toString()=='1'?$('.isSpec').show():$('.isSpec').hide());
				var hasRackComp = q_getPara('sys.rack');
				var isRack = (hasRackComp.toString()=='1'?$('.isRack').show():$('.isRack').hide());
				if(returnType=='style'){
					return (hasStyle.toString()=='1');
				}else if(returnType=='spec'){
					return (hasSpec.toString()=='1');
				}else if(returnType=='rack'){
					return (hasRackComp.toString()=='1');
				}
				
				if($('#cmbTypea').val()=='5')
					$('.ret').show();
				else
					$('.ret').hide();
			}

			function readonly(t_para, empty) {
				_readonly(t_para, empty);
				HiddenTreat();
			}

			function btnMinus(id) {
				_btnMinus(id);
			}

			function btnPlus(org_htm, dest_tag, afield) {
				_btnPlus(org_htm, dest_tag, afield);
			}

			function q_appendData(t_Table) {
				return _q_appendData(t_Table);
			}

			function btnSeek() {
				_btnSeek();
			}

			function btnTop() {
				_btnTop();
			}

			function btnPrev() {
				_btnPrev();
			}

			function btnPrevPage() {
				_btnPrevPage();
			}

			function btnNext() {
				_btnNext();
			}

			function btnNextPage() {
				_btnNextPage();
			}

			function btnBott() {
				_btnBott();
			}

			function q_brwAssign(s1) {
				_q_brwAssign(s1);
			}

			function btnDele() {
				if(!emp($('#txtWorkkno').val())){
					alert("該調撥單由撥料作業("+$('#txtWorkkno').val()+")轉來，請至撥料作業刪除!!!")
					return;
				}
				
				if(!emp($('#txtWorklno').val())){
					alert("該調撥單由委外撥料作業("+$('#txtWorklno').val()+")轉來，請至委外撥料作業刪除!!!")
					return;
				}
				_btnDele();
			}

			function btnCancel() {
				_btnCancel();
			}

			function sum() {
				
			}

		</script>
		<style type="text/css">
			#dmain {
				overflow: hidden;
			}
			.dview {
				float: left;
				width: 98%;
			}
			.tview {
				margin: 0;
				padding: 2px;
				border: 1px black double;
				border-spacing: 0;
				font-size: medium;
				background-color: #FFFF66;
				color: blue;
			}
			.tview td {
				padding: 2px;
				text-align: center;
				border: 1px black solid;
			}
			.dbbm {
				float: left;
				width: 98%;
				margin: -1px;
				border: 1px black solid;
				border-radius: 5px;
			}
			.tbbm {
				padding: 0px;
				border: 1px white double;
				border-spacing: 0;
				border-collapse: collapse;
				font-size: medium;
				color: blue;
				background: #cad3ff;
				width: 100%;
			}
			.tbbm tr {
				height: 35px;
			}
			.tbbm tr td {
				width: 10%;
			}
			.tbbm .tdZ {
				width: 2%;
			}
			.tbbm tr td span {
				float: right;
				display: block;
				width: 5px;
				height: 10px;
			}
			.tbbm tr td .lbl {
				float: right;
				color: blue;
				font-size: medium;
			}
			.tbbm tr td .lbl.btn {
				color: #4297D7;
				font-weight: bolder;
				font-size: medium;
			}
			.tbbm tr td .lbl.btn:hover {
				color: #FF8F19;
			}
			.tbbm select {
				font-size: medium;
			}
			.txt.c1 {
				width: 98%;
				float: left;
			}
			.txt.c2 {
				width: 38%;
				float: left;
			}
			.txt.c3 {
				width: 60%;
				float: left;
			}
			.txt.c4 {
				width: 18%;
				float: left;
			}
			.txt.c5 {
				width: 80%;
				float: left;
			}
			.txt.c6 {
				width: 49%;
				float: left;
			}
			.txt.num {
				text-align: right;
			}
			.tbbm td {
				margin: 0 -1px;
				padding: 0;
			}
			.tbbm td input[type="text"] {
				border-width: 1px;
				padding: 0px;
				margin: -1px;
				float: left;
			}
			.tbbm select {
				border-width: 1px;
				padding: 0px;
				margin: -1px;
				font-size: medium;
			}
			input[type="text"], input[type="button"] {
				font-size: medium;
			}
			.dbbs {
				width: 100%;
			}
			.dbbs .tbbs {
				margin: 0;
				padding: 2px;
				border: 2px lightgrey double;
				border-spacing: 1px;
				border-collapse: collapse;
				font-size: medium;
				color: blue;
				background: lightgrey;
				width: 100%;
			}
			.dbbs .tbbs tr {
				height: 35px;
			}
			.dbbs .tbbs tr td {
				text-align: center;
				border: 2px lightgrey double;
			}
			.dbbs .tbbs select {
				border-width: 1px;
				padding: 0px;
				margin: -1px;
				font-size: medium;
			}
		</style>
	</head>
	<body>
		<!--#include file="../inc/toolbar.inc"-->
		<div id='dmain' style="width: 1260px;">
			<div class="dview" id="dview" style="float: left; width:500px;" >
				<table class="tview" id="tview" border="1" cellpadding='2' cellspacing='0' style="background-color: #FFFF66;">
					<tr>
						<td align="center" style="width:5%"><a id='vewChk'> </a></td>
						<td align="center" style="width:15%"><a id='vewDatea'> </a></td>
						<td align="center" style="width:25%"><a id='vewStore'> </a></td>
						<td align="center" style="width:25%"><a id='vewStorein'> </a></td>
						<td align="center" style="width:25%"><a id='vewCust'> </a></td>
					</tr>
					<tr>
						<td><input id="chkBrow.*" type="checkbox" style=' '/></td>
						<td align="center" id='datea'>~datea</td>
						<td align="center" id='store,8' class="it">~store,8</td>
						<td align="center" id='storein,8' class="it">~storein,8</td>
						<td align="center" id='comp,8' class="it">~comp,8</td>
					</tr>
				</table>
			</div>
			<div class='dbbm' style="width: 760px;float:left">
				<table class="tbbm" id="tbbm" border="0" cellpadding='2' cellspacing='0'>
					<tr class="tr1">
						<td class="td1"><span> </span><a id="lblType" class="lbl" > </a></td>
						<td class="td2"><select id="cmbTypea" class="txt c1"> </select></td>
						<td class='td3'><span> </span><a id="lblDatea" class="lbl" > </a></td>
						<td class="td4"><input id="txtDatea" type="text" class="txt c1"/></td>
						<td class='td5'><span> </span><a id="lblNoa" class="lbl" > </a></td>
						<td class="td6"><input id="txtNoa" type="text" class="txt c1"/></td>
					</tr>
					<tr class="tr2">
						<td class='td3'>
							<span> </span><a id="lblStore" class="lbl btn"> </a>
							<a id="lblStorek" class="lbl btn" style="display: none"> </a>
						</td>
						<td class="td4"><input id="txtStoreno" type="text" class="txt c1"/></td>
						<td class="td4" colspan="2"><input id="txtStore" type="text" class="txt c1"/></td>
						<td class='td3 isRack'><span> </span><a id="lblRackno" class="lbl btn"> </a></td>
						<td class="td4 isRack"><input id="txtRackno" type="text" class="txt c1"/></td>
					</tr>
					<tr class="tr3">
						<td class="td5"><span> </span><a id="lblStorein" class="lbl btn"> </a>
							<a id="lblStoreink" class="lbl btn" style="display: none"> </a>
						</td>
						<td class="td6"><input id="txtStoreinno" type="text" class="txt c1"/></td>
						<td class="td6" colspan="2"><input id="txtStorein" type="text" class="txt c1"/></td>
						<td class='td3 isRack'><span> </span><a id="lblRackinno" class="lbl btn"> </a></td>
						<td class="td4 isRack"><input id="txtRackinno" type="text" class="txt c1"/></td>
					</tr>
					<tr class="tr5">
						<td class="td1"><span> </span><a id="lblSssno" class="lbl btn"> </a></td>
						<td class="td2"><input id="txtSssno" type="text" class="txt c1"/></td>
						<td class="td3" colspan="2"><input id="txtNamea" type="text" class="txt c1"/></td>
					</tr>
					<tr class="tr5">
						<td class="td1"><span> </span><a id="lblCust" class="lbl btn"> </a></td>
						<td class="td2"><input id="txtCustno" type="text" class="txt c1"/></td>
						<td class="td2" colspan="2"><input id="txtComp" type="text" class="txt c1"/></td>
						<td class="td2"><input id="btnRet" type="button" class="ret" value="借出單匯入"/></td>
					</tr>
					<tr class="tr5">
						<td class="td1"><span> </span><a class="lbl">寄送地址 </a></td>
						<td class="td2" colspan="3"><input id="txtAddr" type="text" class="txt c1"/></td>
						<td class="td1"><span> </span><a id="lblTrantype" class="lbl" > </a></td>
						<td class="td2"><select id="cmbTrantype" class="txt c1"> </select></td>
					</tr>
					<tr class="tr5">
						<td class="td1"><span> </span><a class="lbl">電話</a></td>
						<td class="td2"><input id="txtTel" type="text" class="txt c1"/></td>
						<td class="td1"><span> </span><a class="lbl" >配送日期</a></td>
						<td class="td2"><input id="txtPost" type="text" class="txt c1"/></td>
						<td class="td1"><span> </span><a class="lbl" >配送時間</a></td>
						<td class="td2"><input id="txtTranstyle" type="text" class="txt c1"/></td>
					</tr>
					<tr class="tr5">
						<td class="td1"><span> </span><a id="lblPart" class="lbl btn">運費所屬部門</a></td>
						<td class="td2"><input id="txtTranstartno" type="text" class="txt c1"/></td>
						<td class="td2" colspan="2"><input id="txtTranstart" type="text" class="txt c1"/></td>
						<td class="td1"><span> </span><a class="lbl" >退貨發票處理</a></td>
						<td class="td2"><select id="cmbKind" class="txt c1"> </select></td>
					</tr>
					<tr class="tr7">
						<td class="td1"><span> </span><a id="lblMemo" class="lbl"> </a></td>
						<td class="td2" colspan='5'><textarea id="txtMemo" cols="10" rows="5" style="width: 99%;height: 50px;"> </textarea>
							<input id="txtWorkkno" type="hidden" /><input id="txtWorklno" type="hidden" />
						</td>
					</tr>
					<tr class="tr5">
						<td class="td1"><span> </span><a id="lblWorker" class="lbl"> </a></td>
						<td class="td2"><input id="txtWorker" type="text" class="txt c1"/></td>
						<td class="td3"><input id="txtWorker2" type="text" class="txt c1"/></td>
					</tr>
				</table>
			</div>
		</div>
		<div class='dbbs' style="width: 960px;">
			<table id="tbbs" class='tbbs' border="1" cellpadding='2' cellspacing='1' >
				<tr style='color:White; background:#003366;' >
					<td style="width:40px;" align="center">
						<input class="btn" id="btnPlus" type="button" value='＋' style="font-weight: bold;" />
					</td>
					<td style="width:200px;" align="center"><a id='lblProductnos'> </a></td>
					<td style="width:300px;" align="center"><a id='lblProducts'> </a></td>
					<td style="width:40px;" align="center"><a id='lblUnit'> </a></td>
					<td style="width:95px;" align="center" class="isStyle"><a id='lblStyle'> </a></td>
					<td style="width:100px;" align="center"><a id='lblMounts'> </a></td>
					<td align="center"><a id='lblMemos'> </a></td>
				</tr>
				<tr style='background:#cad3ff;'>
					<td><input class="btn" id="btnMinus.*" type="button" value='－' style=" font-weight: bold;" /></td>
					<td>
						<input id="txtProductno.*" type="text" style="width:80%;" />
						<input class="btn" id="btnProductno.*" type="button" value='.' style="width:15%;" />
					</td>
					<td>
						<input class="txt c1" id="txtProduct.*" type="text"/>
						<input class="txt c1 isSpec" id="txtSpec.*" type="text"/>
					</td>
					<td><input class="txt c1" id="txtUnit.*" type="text" /></td>
					<td class="isStyle"><input class="txt c1" id="txtStyle.*" type="text" /></td>
					<td><input class="txt num c1" id="txtMount.*" type="text"/></td>
					<td>
						<input class="txt c1" id="txtMemo.*" type="text"/>
						<input id="txtNoq.*" type="hidden" />
						<input id="recno.*" type="hidden" />
						<input class="txt ret" id="txtRetno.*" type="text" style="width: 75%;"/>
						<input class="txt ret" id="txtRetnoq.*" type="text" style="width: 20%;"/>
					</td>
				</tr>
			</table>
		</div>
		<input id="q_sys" type="hidden" />
	</body>
</html>