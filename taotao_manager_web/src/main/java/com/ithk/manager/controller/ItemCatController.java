package com.ithk.manager.controller;

import com.ithk.manager.service.ItemCatService;
import com.ithk.manager.pojo.ItemCat;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import java.util.List;

@Controller
@RequestMapping("/itemCat")
public class ItemCatController {

    @Autowired
    private ItemCatService itemCatService;

    @RequestMapping(value = "/query/{page}")
    @ResponseBody
    public List<ItemCat> queryItemCatByPage(@PathVariable("page") Integer page, @RequestParam(value = "rows") Integer rows) {
        List<ItemCat> list = this.itemCatService.queryByPage(page, rows);
        return list;

    }

}
