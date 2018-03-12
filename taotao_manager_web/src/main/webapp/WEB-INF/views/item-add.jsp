<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<link href="/js/kindeditor-4.1.10/themes/default/default.css" type="text/css" rel="stylesheet">
<script type="text/javascript" charset="utf-8" src="/js/kindeditor-4.1.10/kindeditor-all-min.js"></script>
<script type="text/javascript" charset="utf-8" src="/js/kindeditor-4.1.10/lang/zh_CN.js"></script>
<div style="padding:10px 10px 10px 10px">
	<form id="itemAddForm" class="itemForm" method="post">
	    <table cellpadding="5">
	        <tr>
	            <td>商品类目:</td>
	            <td>
	            	<a href="javascript:void(0)" class="easyui-linkbutton selectItemCat">选择类目</a>
	            	<span ></span>
	            	<input type="hidden" name="cid" style="width: 280px;"></input>
	            </td>
	        </tr>
	        <tr>
	            <td>商品标题:</td>
	            <td><input class="easyui-textbox" type="text" name="title" data-options="required:true" style="width: 280px;"></input></td>
	        </tr>
	        <tr>
	            <td>商品卖点:</td>
	            <td><input class="easyui-textbox" name="sellPoint" data-options="multiline:true,validType:'length[0,150]'" style="height:60px;width: 280px;"></input></td>
	        </tr>
	        <tr>
	            <td>商品价格:</td>
	            <td><input class="easyui-numberbox" type="text" name="price" data-options="min:1,max:99999999,precision:2,required:true" />
	            </td>
	        </tr>
	        <tr>
	            <td>库存数量:</td>
	            <td><input class="easyui-numberbox" type="text" name="num" data-options="min:1,max:99999999,precision:0,required:true" /></td>
	        </tr>
	        <tr>
	            <td>条形码:</td>
	            <td>
	                <input class="easyui-textbox" type="text" name="barcode" data-options="validType:'length[1,30]'" />
	            </td>
	        </tr>
	        <tr>
	            <td>商品图片:</td>
	            <td>
	            	 <a href="javascript:void(0)" class="easyui-linkbutton picFileUpload">上传图片</a>
	            	 <div class="pics"><ul></ul></div>
	                 <input type="hidden" name="image"/>
	            </td>
	        </tr>
	        <tr>
	            <td>商品描述:</td>
	            <td>
	                <textarea style="width:800px;height:300px;visibility:hidden;" name="desc"></textarea>
	            </td>
	        </tr>
	        <tr class="params hide">
	        	<td>商品规格:</td>
	        	<td>
	        		
	        	</td>
	        </tr>
	    </table>
	    <input type="hidden" name="itemParams"/>
	</form>
	<div style="padding:5px">
	    <a href="javascript:void(0)" class="easyui-linkbutton" onclick="submitForm()">提交</a>
	    <a href="javascript:void(0)" class="easyui-linkbutton" onclick="clearForm()">重置</a>
	</div>
</div>
<script type="text/javascript">
	//编辑器参数
	kingEditorParams = {
		filePostName  : "uploadFile",  //上传的文件名 
		uploadJson : '/rest/pic/upload', //上传的路径
		dir : "image"   //上传的文件类型
	};
	
	var itemAddEditor ;
	
	//页面加载完时执行以下逻辑
	$(function(){
		//创建富文本编辑器
		itemAddEditor = KindEditor.create("#itemAddForm [name=desc]", kingEditorParams);
		//初始化类目选择
		initItemCat();
		//初始化图片上传
		initPicUpload();
	});
	
	//提交商品信息到后台
	function submitForm(){
		//校验表单
		if(!$('#itemAddForm').form('validate')){
			$.messager.alert('提示','表单还未填写完成!');
			return ;
		}
		
		//把富文本编辑器编辑区域的html代码。同步到多行文本中，向后台提交的是多行文本
		//因为编辑器的编辑区域是div标签，不能提交
		itemAddEditor.sync();
				
		//提交到后台的RESTful
		$.ajax({
		   type: "POST",
		   url: "/rest/item",
		   data: $("#itemAddForm").serialize(),
		   success: function(msg){
			   if(msg == "0"){
				   $.messager.alert('提示','新增商品成功!');  
			   }else{
				   $.messager.alert('提示','新增商品发生异常，保存失败!'); 
			   }
		   },
		   error: function(){
			   $.messager.alert('提示','新增商品失败!');
		   }
		});
	}
	
	function clearForm(){
		$('#itemAddForm').form('reset');
		itemAddEditor.html('');
	}
	
	//类目选择初始化
	function initItemCat(){
		//获取class为selectItemCat的元素，其实就是类目选择按钮
		var selectItemCat = $(".selectItemCat");
		//给类目选择按钮增加点击事件
   		selectItemCat.click(function(){
   			//添加div标签，并设置css属性
  			//在div标签里面添加ul标签，并打开窗口
   			$("<div>").css({padding:"5px"}).html("<ul>")
   			.window({
   				//窗口属性设置
   				width:'500',
   			    height:"450",
   			    modal:true,
   			    closed:true,
   			    iconCls:'icon-save',
   			    title:'选择类目',
   				//当窗口打开后执行的逻辑
   			    onOpen : function(){
   			   		//这里的this是打开的窗口本身
   			    	var _win = this;
   			   		//在窗口范围内，搜索ul标签
  			    	//找到ul标签，并创建EasyUI树
   			    	$("ul",_win).tree({
   			    		//异步树，发起请求，创建树
   			    		url:'/rest/item/cat',
   			    		method:'GET',
   			    		animate:true,
   			    		//给树上的所有节点添加点击事件
   			    		onClick : function(node){
   			    			if($(this).tree("isLeaf",node.target)){
   			    				// 填写到cid中
   			    				selectItemCat.parent().find("[name=cid]").val(node.id);
   			    				selectItemCat.next().text(node.text);
   			    				$(_win).window('close');
   			    			}
   			    		}
   			    	});
   			    },
   			    onClose : function(){
   			    	$(this).window("destroy");
   			    }
   			}).window('open');
   		});
    }
	
	//图片上传初始化
	function initPicUpload(){
		//class选择器，其实获取到的就是上传图片按钮，绑定点击事件
       	$(".picFileUpload").click(function(){
       		//id选择器，其实获取到的就是form表单
       		var form = $('#itemAddForm');
       		//加载多图片上传组件（可参考富文本编辑器的文档）
       		KindEditor.editor(kingEditorParams).loadPlugin('multiimage',function(){
       			//editor:就是编辑器本身
       			var editor = this;
       			//执行插件的逻辑，显示上传界面
       			editor.plugin.multiImageDialog({
       				//当点击“全部插入”按钮，执行以下逻辑
       				//urlList：多图片上传成功后，返回的图片url
					clickFn : function(urlList) {
						//获取class为pics的li的标签，删除，清空之前上传的图片
						$(".pics li").remove();
						//声明图片url数组
						var imgArray = [];
						//遍历返回的图片url
						//i遍历的坐标，data遍历的变量
						KindEditor.each(urlList, function(i, data) {
							//从遍历的数据中获取url，其实就是获取图片的url
							//放到声明数组中
							imgArray.push(data.url);
							//获取class为pics的ul标签
							//在后面追加li标签，回显上传成功的图片
							$(".pics ul").append("<li><a href='"+data.url+"' target='_blank'><img src='"+data.url+"' width='80' height='50' /></a></li>");
						});
						//获取name=image的元素，其实就是获取图片上传的input标签
						//往input标签里赋值
						//imgArray.join(",")：把数据转为字符串，数组中的元素用，分隔
						form.find("[name=image]").val(imgArray.join(","));
						
						//关闭上传界面
						editor.hideDialog();
					}
				});
       		});
       	});
	}
	
</script>
