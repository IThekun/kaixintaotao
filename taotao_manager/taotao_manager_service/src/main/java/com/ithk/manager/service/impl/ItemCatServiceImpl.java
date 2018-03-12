package com.ithk.manager.service.impl;

import com.github.pagehelper.PageHelper;
import com.ithk.manager.mapper.ItemCatMapper;
import com.ithk.manager.service.ItemCatService;
import com.ithk.manager.pojo.ItemCat;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

/**
 * 商品分类
 */
@Service
public class ItemCatServiceImpl extends BaseServiceImpl<ItemCat> implements ItemCatService {

    /*@Autowired
    private ItemCatMapper itemCatMapper;*/

    /**
     * 商品分类分页查询
     * @param page
     * @param rows
     * @return
     */
    /*@Override
    public List<ItemCat> queryItemCatByPage(Integer page, Integer rows) {

        PageHelper.startPage(page,rows);
        List<ItemCat> list = itemCatMapper.select(null);

        return list;
    }*/
}
