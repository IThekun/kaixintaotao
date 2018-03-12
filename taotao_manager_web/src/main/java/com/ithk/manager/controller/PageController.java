package com.ithk.manager.controller;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;

@Controller
@RequestMapping(value = "/page")
public class PageController {
    /**
     * 通用页面跳转方法,访问路径:http://localhost:8080/rest/page/index到达index页面
     * @param pageName
     * @return
     */
@RequestMapping(value = "/{pageName}")
    public String toPage(@PathVariable(value = "pageName")String pageName){
        return pageName;
    }
}
