<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<div>
	 <ul id="contentCategory" class="easyui-tree">
    </ul>
</div>
<div id="contentCategoryMenu" class="easyui-menu" style="width:120px;" data-options="onClick:menuHandler">
    <div data-options="iconCls:'icon-add',name:'add'">添加</div>
    <div data-options="iconCls:'icon-remove',name:'rename'">重命名</div>
    <div class="menu-sep"></div>
    <div data-options="iconCls:'icon-remove',name:'delete'">删除</div>
</div>
<script type="text/javascript">
//页面加载完成时，执行以下逻辑
$(function(){
	//id选择器，找到easyui-tree树控件元素
	//创建树
	$("#contentCategory").tree({
		url : '/rest/content/category',
		animate: true,
		method : "GET",
		//在树菜单中点击鼠标右键，执行以下逻辑
		onContextMenu: function(e,node){
			//关闭windowns默认右击菜单
            e.preventDefault();
			//获取选中的节点
            $(this).tree('select',node.target);
			//id选择器，其实就是菜单元素组件
			//显示菜单
            $('#contentCategoryMenu').menu('show',{
            	//设置菜单出现的位置，其实就是鼠标所在位置
                left: e.pageX,
                top: e.pageY
            });
        },
        //在编辑完成后执行以下逻辑
        onAfterEdit : function(node){
        	var _tree = $(this);
        	//如果id为0，节点为新增节点
        	if(node.id == 0){
        		// 新增节点，发起异步请求
        		//parentId:${新增的父节点id},name:${新增节点的名称}
        		$.post("/rest/content/category/add",{parentId:node.parentId,name:node.text},function(data){
        			//更新树节点信息
        			_tree.tree("update",{
        				//需要更新的节点
        				target : node.target,
        				//把树节点的id改为后台返回的新增内容分类ID
        				id : data.id
        			});
        		});
        		
            //id不为0说明不是新增节点，而是修改节点
        	}else{
        		//发起异步请求
        		//id:${选中树节点的id},name:${选中树节点的名称}
        		$.ajax({
        			   type: "POST",
        			   url: "/rest/content/category/update",
        			   data: {id:node.id,name:node.text},
        			   success: function(msg){
        				   if(msg == "0"){
        					   $.messager.alert('提示','修改名称成功!');
        				   }else{
        					   $.messager.alert('提示','修改名称失败!');
        				   }
        			   },
        			   error: function(){
        				   $.messager.alert('提示','重命名失败!');
        			   }
        			});
        	}
        }
	});
});

//菜单点击事件,item就是选择的菜单项目
function menuHandler(item){
	//获取树
	var tree = $("#contentCategory");
	//获取选中的树节点
	var node = tree.tree("getSelected");
	//判断菜单的name属性，用于识别当前是点击了什么操作
	//==：(1 == 1) true	(1 == "1") true
	//===：(1 === 1) true	(1 === "1") false
	//add是添加节点操作
	if(item.name === "add"){
		//在树上追加一个节点
		tree.tree('append', {
			//确定选中节点的父节点
            parent: (node?node.target:null),
            //追加节点数据
            data: [{
                text: '新建分类',
                id : 0,
                parentId : node.id
            }]
        }); 
		//获取树目录中id为0的节点，其实就是刚新增的节点
		var _node = tree.tree('find',0);
		//选中新增节点，开始编辑
		tree.tree("select",_node.target).tree('beginEdit',_node.target);
	//判断菜单的name属性，用于识别当前是点击了什么操作
	//rename是重命名节点操作
	}else if(item.name === "rename"){
		//对选中的节点开始编辑
		tree.tree('beginEdit',node.target);
	//判断菜单的name属性，用于识别当前是点击了什么操作
	//delete是删除节点操作
	}else if(item.name === "delete"){
		//提示用户确认删除，如果没有特殊要求，删除操作必须要提示，因为删除是危险操作
		$.messager.confirm('确认','确定删除名为 '+node.text+' 的分类吗？',function(r){
			//如果用户确认，就是删除
			if(r){
				//发起异步请求删除数据库信息
				$.ajax({
     			   type: "POST",
     			   //parentId=${节点的父id}&id=${选中节点的id}
     			   url: "/rest/content/category/delete",
     			   data : {parentId:node.parentId,id:node.id},
     			   success: function(msg){
     				   //$.messager.alert('提示','新增商品成功!');
     				  //删除选中的节点
     				  tree.tree("remove",node.target);
     			   },
     			   error: function(){
     				   $.messager.alert('提示','删除失败!');
     			   }
     			});
			}
		});
	}
}
</script>