<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<link href="/js/kindeditor-4.1.10/themes/default/default.css" type="text/css" rel="stylesheet">
<script type="text/javascript" charset="utf-8" src="/js/kindeditor-4.1.10/kindeditor-all-min.js"></script>
<script type="text/javascript" charset="utf-8" src="/js/kindeditor-4.1.10/lang/zh_CN.js"></script>
<div style="padding:10px 10px 10px 10px">
	<form id="contentAddForm" class="itemForm" method="post">
		<input type="hidden" name="categoryId"/>
	    <table cellpadding="5">
	        <tr>
	            <td>内容标题:</td>
	            <td><input class="easyui-textbox" type="text" name="title" data-options="required:true" style="width: 280px;"></input></td>
	        </tr>
	        <tr>
	            <td>内容子标题:</td>
	            <td><input class="easyui-textbox" type="text" name="subTitle" style="width: 280px;"></input></td>
	        </tr>
	        <tr>
	            <td>内容描述:</td>
	            <td><input class="easyui-textbox" name="titleDesc" data-options="multiline:true,validType:'length[0,150]'" style="height:60px;width: 280px;"></input>
	            </td>
	        </tr>
	         <tr>
	            <td>URL:</td>
	            <td><input class="easyui-textbox" type="text" name="url" style="width: 280px;"></input></td>
	        </tr>
	        <tr>
	            <td>图片:</td>
	            <td>
	                <a href="javascript:void(0)" class="easyui-linkbutton onePicUpload">图片上传</a>
	                <br><input type="hidden" name="pic" />
	            </td>
	        </tr>
	        <tr>
	            <td>图片2:</td>
	            <td>
	            	<a href="javascript:void(0)" class="easyui-linkbutton onePicUpload">图片上传</a>
	            	<br><input type="hidden" name="pic2" />
	            </td>
	        </tr>
	        <tr>
	            <td>内容:</td>
	            <td>
	                <textarea style="width:800px;height:300px;visibility:hidden;" name="content"></textarea>
	            </td>
	        </tr>
	    </table>
	</form>
	<div style="padding:5px">
	    <a href="javascript:void(0)" class="easyui-linkbutton" onclick="submitForm()">提交</a>
	    <a href="javascript:void(0)" class="easyui-linkbutton" onclick="clearForm()">重置</a>
	</div>
</div>
<script type="text/javascript">
	//编辑器参数
	kingEditorParams = {
		filePostName  : "uploadFile",   
		uploadJson : '/rest/pic/upload',	
		dir : "image" 
	};

	var contentAddEditor ;
	$(function(){
		//创建富文本编辑器
		contentAddEditor =  KindEditor.create("#contentAddForm [name=content]", kingEditorParams);
		//初始化单图片上传
		initOnePicUpload();
		//把内容分类id放到input中，提交到后台
		$("#contentAddForm [name=categoryId]").val($("#contentCategoryTree").tree("getSelected").id);
	});
	
	//提交逻辑
	function submitForm(){
		//校验
		if(!$('#contentAddForm').form('validate')){
			$.messager.alert('提示','表单还未填写完成!');
			return ;
		}
		
		//编辑器的同步，把编辑器的内容同步到多行文本域中
		contentAddEditor.sync();
		
		//提交到后台的RESTful
		$.ajax({
		   type: "POST",
		   url: "/rest/content",
		   //把表单的元素序列化，拼装成key=value&key2=value2&key3=value3格式
		   data: $("#contentAddForm").serialize(),
		   success: function(msg){
			   if(msg == "0"){
				   $.messager.alert('提示','新增内容成功!');
				   //重新加载datagrid
	 			   $("#contentList").datagrid("reload");
			   }else{
				   $.messager.alert('提示','新增内容失败!');
			   }
			   
			   //关闭弹窗
 			   TT.closeCurrentWindow();
		   },
		   error: function(){
			   $.messager.alert('提示','新增内容失败!');
		   }
		});
	}
	
	function clearForm(){
		$('#contentAddForm').form('reset');
		contentAddEditor.html('');
	}
	
	//初始化单图片上传
	function initOnePicUpload(){
		//获取上传按钮，绑定点击事件
    	$(".onePicUpload").click(function(){
    		//this就是按钮，获取同级的input元素
			var input = $(this).siblings("input");
			//加载单图片上传组件
			KindEditor.editor(kingEditorParams).loadPlugin('image', function() {
				this.plugin.imageDialog({
					showRemote : false,
					//点击“确定”按钮执行逻辑
					clickFn : function(url, title, width, height, border, align) {
						//获取同级的img标签，清除，其实就是回显前，清除原来的图片
						input.parent().find("img").remove();
						input.val(url);
						//在input标签后添加a标签，里面是img标签，其实就是图片回显
						input.after("<a href='"+url+"' target='_blank'><img src='"+url+"' width='80' height='50'/></a>");
						//关闭上传界面
						this.hideDialog();
					}
				});
			});
		});
    }
			
			
</script>
